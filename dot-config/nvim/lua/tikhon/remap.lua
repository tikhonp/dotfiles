vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.langmap =
"ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open [P]roject [V]iew file browser." })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlight on ESC" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected visual block one line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected visual block one line up" })

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end, { desc = "Resource nvim confing" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Stay cursor in place while jumping" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Stay cursor in place while jumping" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Also stay cursor in middle while search jumps" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Also stay cursor in middle while search jumps" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank to system" })

vim.keymap.set("n", "<leader>i", "gg=G", { desc = "Indent whole file" })

vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
