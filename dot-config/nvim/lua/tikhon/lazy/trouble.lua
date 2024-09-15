return {
    "folke/trouble.nvim",
    dependencies = {
        "artemave/workspace-diagnostics.nvim",
    },
    config = function()
        require("trouble").setup({})

        local remap_lsp_group = vim.api.nvim_create_augroup("TroubleRemapLsp", {})
        vim.api.nvim_create_autocmd("LspAttach", {
            group = remap_lsp_group,
            callback = function()
                vim.keymap.set("n", "<leader>e", "<cmd>Trouble diagnostics toggle<CR>")
                vim.keymap.set("n", "<leader>vs", "<cmd>Trouble symbols toggle focus=false<cr>")
                vim.keymap.set("n", "<leader>qfl", "<cmd>Trouble qflist toggle<cr>")

                vim.keymap.set("n", "<leader>we", function()
                    for _, client in ipairs(vim.lsp.get_clients()) do
                        require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
                    end
                    vim.cmd("Trouble diagnostics")
                end)

                vim.keymap.set("n", "]dd", function()
                    require("trouble").next({ skip_groups = true, jump = true });
                end)

                vim.keymap.set("n", "[dd", function()
                    require("trouble").previous({ skip_groups = true, jump = true });
                end)
            end
        })
    end,
}
