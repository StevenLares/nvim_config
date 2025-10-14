return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          -- Disable macro recording on plain q
          ["q"] = false,

          -- Remap macro recording to <Leader>0
          ["<Leader>0"] = { "q", desc = "Start/stop macro recording" },

          -- Example buffer mappings from docs (optional)
          ["<Leader>b"] = { desc = "Buffers" },
          ["<Leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
          ["<Leader>bD"] = {
            function()
              require("astroui.status").heirline.buffer_picker(function(bufnr)
                require("astrocore.buffer").close(bufnr)
              end)
            end,
            desc = "Pick to close",
          },
        },
      },
    },
  },
}
