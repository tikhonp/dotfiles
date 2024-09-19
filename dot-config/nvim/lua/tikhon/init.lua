vim.filetype.add({ extension = { templ = "templ" } })

require("tikhon.set")
require("tikhon.remap")
require("tikhon.lazy_init")

local api = vim.api

local add_newline_at_end = function()
    local n_lines = api.nvim_buf_line_count(0)
    local last_nonblank = vim.fn.prevnonblank(n_lines)
    if last_nonblank <= n_lines then
        api.nvim_buf_set_lines(0,
            last_nonblank, n_lines, true, { '' })
    end
end

---@param bufnr integer
---@param mode "v"|"V"
---@return table {start={row,col}, end={row,col}} using (1, 0) indexing
local function range_from_selection(bufnr, mode)
    -- [bufnum, lnum, col, off]; both row and column 1-indexed
    local start = vim.fn.getpos('v')
    local end_ = vim.fn.getpos('.')
    local start_row = start[2]
    local start_col = start[3]
    local end_row = end_[2]
    local end_col = end_[3]

    -- A user can start visual selection at the end and move backwards
    -- Normalize the range to start < end
    if start_row == end_row and end_col < start_col then
        end_col, start_col = start_col, end_col
    elseif end_row < start_row then
        start_row, end_row = end_row, start_row
        start_col, end_col = end_col, start_col
    end
    if mode == 'V' then
        start_col = 1
        local lines = api.nvim_buf_get_lines(bufnr, end_row - 1, end_row, true)
        end_col = #lines[1]
    end
    return {
        ['start'] = { start_row, start_col - 1 },
        ['end'] = { end_row, end_col - 1 },
    }
end

local lsp_buf_format = function()
    local bufnr = api.nvim_get_current_buf()
    local mode = api.nvim_get_mode().mode
    local range ---@type {start:[integer,integer],end:[integer, integer]}|{start:[integer,integer],end:[integer,integer]}[]
    if not range and mode == 'v' or mode == 'V' then
        range = range_from_selection(bufnr, mode)
    end

    local ms = require('vim.lsp.protocol').Methods
    local passed_multiple_ranges = (range and #range ~= 0 and type(range[1]) == 'table')
    local method ---@type string
    if passed_multiple_ranges then
        method = ms.textDocument_rangesFormatting
    elseif range then
        method = ms.textDocument_rangeFormatting
    else
        method = ms.textDocument_formatting
    end

    local clients = vim.lsp.get_clients({
        bufnr = api.nvim_get_current_buf(),
        method = method,
    })
    if #clients == 0 then
        -- no matching language servers
        return
    end
    if vim.bo.filetype == "templ" then
        local filename = api.nvim_buf_get_name(bufnr)
        local cmd = "templ fmt " .. vim.fn.shellescape(filename)
        vim.fn.jobstart(cmd, {
            on_exit = function()
                -- Reload the buffer only if it's still the current buffer
                if api.nvim_get_current_buf() == bufnr then
                    vim.cmd('e!')
                end
            end,
        })
    else
        vim.lsp.buf.format()
    end
    add_newline_at_end()
end


local augroup = api.nvim_create_augroup
local autocmd = api.nvim_create_autocmd

local yank_group = augroup("HighlightYank", {})
autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 100,
        })
    end,
})

local remap_lsp_group = augroup("RemapLsp", {})
autocmd("LspAttach", {
    group = remap_lsp_group,
    callback = function(e)
        local opts = { buffer = e.buf }

        local format_on_save_group = augroup("formatOnSave", {})
        autocmd("BufWritePre", {
            group = format_on_save_group,
            buffer = e.buf,
            callback = lsp_buf_format,
        })

        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>f", lsp_buf_format, { desc = "Format current buffer" })

        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    end
})

vim.g.netrw_bufsettings = "noma nomod nu nowrap ro nobl"
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

