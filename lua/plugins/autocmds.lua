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
              vim.keymap.set("n", "q", function()
                local buftype = vim.bo.buftype
                local filetype = vim.bo.filetype
                local recording = vim.fn.reg_recording() -- returns the register being recorded, or "" if none

                if recording ~= "" then
                  -- already recording: allow 'q' to stop recording
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
            end,
          },
        },
      },
    },
  },
}
