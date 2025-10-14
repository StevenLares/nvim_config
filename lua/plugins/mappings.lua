return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {

          -- Use <Leader>0 to toggle macro recording safely (records into @m)
          ["<Leader>0"] = {
            function()
              if vim.fn.reg_recording() == "" then
                -- Start recording into register m to avoid potential conflicts
                vim.api.nvim_feedkeys("qm", "n", false)
                vim.notify("⏺️ Started recording macro @m", vim.log.levels.INFO, { title = "Macro" })
              else
                -- Stop recording
                vim.api.nvim_feedkeys("q", "n", false)
                vim.notify("⏹️ Stopped recording macro", vim.log.levels.INFO, { title = "Macro" })
              end
            end,
            desc = "Toggle macro recording (@m)",
          },
        },
      },
    },
  },
}
