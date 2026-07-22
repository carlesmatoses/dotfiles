-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- <c-/> doesn't reach nvim on a Spanish keyboard, so use <c-t> instead for
-- the terminal toggle (same as LazyVim's default <c-/> / <c-_> mapping).
vim.keymap.set({ "n", "t" }, "<c-t>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (root dir)" })
