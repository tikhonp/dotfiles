return {

    "github/copilot.vim",

    config = function()
        local proxy_server = os.getenv("MY_PROXY_SERVER")
        if (proxy_server == nil) then
            vim.notify("[Copilot] Environment variable MY_PROXY_SERVER not set", vim.log.levels.ERROR)
            return
        end
        vim.g.copilot_proxy = proxy_server

        vim.keymap.set("n", "<leader>cp", "<cmd>Copilot panel<CR>", { desc = "Open [C]opilot [P]anel" })
        vim.keymap.set("n", "<leader>ce", function()
            vim.cmd("Copilot enable")
            vim.notify("[Copilot] Enabled")
        end, { desc = "Open [C]opilot [E]nable" })
        vim.keymap.set("n", "<leader>cd", function()
            vim.cmd("Copilot disable")
            vim.notify("[Copilot] Disabled")
        end, { desc = "Open [C]opilot [D]isable" })
    end,

}

