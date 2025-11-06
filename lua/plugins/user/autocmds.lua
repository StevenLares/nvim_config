return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        smart_q = {
          {
            event = "VimEnter",
            desc = "Disable macro recording on 'q', allow stopping existing macros, allow closing popups",
            callback = function()
              -- Smart 'q' for normal mode
              vim.keymap.set("n", "q", function()
                local buftype = vim.bo.buftype
                local filetype = vim.bo.filetype
                local recording = vim.fn.reg_recording() -- currently recording register

                if recording ~= "" then
                  -- already recording: allow 'q' to stop
                  return "q"
                end

                -- allow 'q' to close floating/special buffers
                if buftype == "prompt" or buftype == "help" or buftype == "quickfix" then
                  return "q"
                elseif filetype == "TelescopePrompt" or filetype == "lazy" then
                  return "q"
                end

                -- otherwise, disable starting a macro
                vim.notify("⛔ Macro recording disabled. Use <Leader>0.", vim.log.levels.WARN, { title = "Macro" })
                return ""
              end, { expr = true, noremap = true, silent = true })

              -- <Leader>0 toggle for macro recording into @m
              vim.keymap.set("n", "<Leader>0", function()
                local recording = vim.fn.reg_recording()
                if recording == "" then
                  -- start recording into @m
                  vim.api.nvim_feedkeys("qm", "n", false)
                  vim.notify("⏺️ Started recording macro @m", vim.log.levels.INFO, { title = "Macro" })
                else
                  -- stop recording
                  vim.api.nvim_feedkeys("q", "n", false)
                  vim.notify("⏹️ Stopped recording macro @m", vim.log.levels.INFO, { title = "Macro" })
                end
              end, { noremap = true, silent = true, desc = "Toggle macro recording (@m)" })
            end,
          },
        },
      },
    },
  },
}
