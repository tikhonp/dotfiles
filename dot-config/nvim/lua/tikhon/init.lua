vim.filetype.add({ extension = { templ = "templ" } })

require("tikhon.set")
require("tikhon.remap")
require("tikhon.lazy_init")

local add_newline_at_end = function()
    local n_lines = vim.api.nvim_buf_line_count(0)
    local last_nonblank = vim.fn.prevnonblank(n_lines)
    if last_nonblank <= n_lines then
        vim.api.nvim_buf_set_lines(0,
            last_nonblank, n_lines, true, { '' })
    end
end

local lsp_buf_format = function()
    if vim.bo.filetype == "templ" then
        local bufnr = vim.api.nvim_get_current_buf()
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local cmd = "templ fmt " .. vim.fn.shellescape(filename)
        vim.fn.jobstart(cmd, {
            on_exit = function()
                -- Reload the buffer only if it's still the current buffer
                if vim.api.nvim_get_current_buf() == bufnr then
                    vim.cmd('e!')
                end
            end,
        })
    else
        vim.lsp.buf.format()
    end
    add_newline_at_end()
end


local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

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
            callback = function()
                lsp_buf_format()
            end,
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
