return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          -- Disable macro recording on plain q

          -- Remap macro recording to <Leader>0
          ["<Leader>0"] = { "q", desc = "Start/stop macro recording" },

        },
        t = {
          ["q"] = false,
        },
      },
    },
  },
}
