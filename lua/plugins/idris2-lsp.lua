return {
  {
    "idris-community/idris2-nvim",
    lazy = true,
    ft = { "idris2", "idr" }, -- filetypes to load on
    config = function()
      require("idris2").setup{} -- basic setup, extend as needed
    end,
  },
}
