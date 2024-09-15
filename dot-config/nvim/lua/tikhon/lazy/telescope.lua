return {
    "nvim-telescope/telescope.nvim",

    branch = "0.1.x",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
    },

    config = function()
        require('telescope').setup {
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_cursor {
                        layout_config = {
                            height = 0.4,
                            width = 0.3,
                            prompt_position = "bottom",
                        },
                    }
                }
            }
        }

        local builtin = require("telescope.builtin")
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>saf', '<cmd>Telescope find_files hidden=true<cr>')
        vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find)

        require("telescope").load_extension("ui-select")
    end,
}
