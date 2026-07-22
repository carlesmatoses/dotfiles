return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "catppuccin/nvim",
    opts = {
      -- Catppuccin defaults WinSeparator/FloatBorder to "crust", which is
      -- nearly black on the "base" background — bump it to "overlay0" so
      -- window/float borders are actually visible.
      custom_highlights = function(colors)
        return {
          WinSeparator = { fg = colors.overlay0 },
          FloatBorder = { fg = colors.overlay0 },
        }
      end,
    },
  },
}
