-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Quick escape from insert mode without reaching for <Esc>.
vim.keymap.set("i", "jj", "<Esc>", { desc = "Escape insert mode" })
vim.keymap.set("i", "kk", "<Esc>", { desc = "Escape insert mode" })

-- <c-/> doesn't reach nvim on a Spanish keyboard, so use <c-t> instead for
-- the terminal toggle (same as LazyVim's default <c-/> / <c-_> mapping).
vim.keymap.set({ "n", "t" }, "<c-t>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (root dir)" })
