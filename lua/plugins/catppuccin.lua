return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- make sure it loads before other plugins that depend on colors
  lazy = false,    -- load immediately
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- can be "latte", "frappe", "macchiato", or "mocha"
      background = {     -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      integrations = {
        treesitter = true,
        telescope = true,
        mason = true,
        cmp = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
      },
    })

    -- Set the colorscheme
    vim.cmd.colorscheme "catppuccin"
  end,
}
