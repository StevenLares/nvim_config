return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          -- disable direct q to avoid accidental quit/record
          ["q"] = false,

          -- Leader + 0 starts/stops macro recording (like qq)
          ["<Leader>0"] = {
            function()
              vim.api.nvim_feedkeys("qq", "n", false)
            end,
            desc = "Start/stop macro recording (qq)",
          },
        },
      },
    },
  },
}
