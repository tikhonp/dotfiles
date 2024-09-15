return {

    "tpope/vim-fugitive",

    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

        local tikhon_fugitive_group = vim.api.nvim_create_augroup("tikhon_fugitive_group", {})

        vim.api.nvim_create_autocmd("BufWinEnter", {
            group = tikhon_fugitive_group,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                local opts = { buffer = bufnr, remap = false }
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git('push')
                end, opts)
            end,
        })
    end,

}
