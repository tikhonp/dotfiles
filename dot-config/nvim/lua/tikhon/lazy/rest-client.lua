return {

    "diepm/vim-rest-console",

    config = function()
        vim.g.vrc_set_default_mapping = 0
        vim.g.vrc_split_request_body = 0

        vim.g.vrc_curl_opts = {
            ["--silent"] = "",
            ["--include"] = "",
            ["--compressed"] = "",
        }

        vim.g.vrc_auto_format_response_patterns = {
            json = "jq",
            html = "tidy -i -q --tidy-mark no --show-body-only auto --show-errors 0 --show-warnings 0 -",
            xml = "tidy -xml -i -q --tidy-mark no --show-body-only auto --show-errors 0 --show-warnings 0 -",
        }

        vim.keymap.set("n", "<leader>rr", "<cmd>call VrcQuery ()<CR>", { desc = "[R]un [R]equest under the cursor" })

        vim.keymap.set("n", "<leader>rsj", function()
            vim.g.vrc_body_preprocessor = "jq -c ."
            vim.notify("[Rest Console] vrc_body_preprocessor set to JSON")
        end, { desc = "[R]est [S]et [J]son vrc_body_preprocessor" })

        vim.keymap.set("n", "<leader>ruj", function()
            vim.g.vrc_body_preprocessor = ""
            vim.notify("[Rest Console] vrc_body_preprocessor set to NULL")
        end, { desc = "[R]est [U]nset [J]son vrc_body_preprocessor" })
    end

}

