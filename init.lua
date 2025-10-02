-- ─────────────────────────────────────────────────────────────────────────────
-- Plugin Manager: lazy.nvim
-- ─────────────────────────────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- ─────────────────────────────────────────────────────────────────────────────
-- Plugins
-- ─────────────────────────────────────────────────────────────────────────────
require("lazy").setup({

  -- Mason core
  { "williamboman/mason.nvim" },

  -- Mason <-> LSP bridge
  { "williamboman/mason-lspconfig.nvim" },

  -- CLI tool installer (replacement for mason-null-ls)
  { "WhoIsSethDaniel/mason-tool-installer.nvim" },

  -- Colors
  { "morhetz/gruvbox" },

  -- File Explorer
  { "nvim-tree/nvim-tree.lua", dependencies = "nvim-tree/nvim-web-devicons" },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- LSP + Autocompletion
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" }
  },

  -- Git signs
  { "lewis6991/gitsigns.nvim" },

  -- Terminal toggler
  { "akinsho/toggleterm.nvim" },

  -- Debugging stack
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "williamboman/mason.nvim"
    },
  },
})

-- ─────────────────────────────────────────────────────────────────────────────
-- General Settings
-- ─────────────────────────────────────────────────────────────────────────────
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.cmd("colorscheme gruvbox")

-- ─────────────────────────────────────────────────────────────────────────────
-- File Explorer
-- ─────────────────────────────────────────────────────────────────────────────
require("nvim-tree").setup()
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle Explorer" })

-- ─────────────────────────────────────────────────────────────────────────────
-- Telescope
-- ─────────────────────────────────────────────────────────────────────────────
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help" })

-- ─────────────────────────────────────────────────────────────────────────────
-- Treesitter (auto-install languages)
-- ─────────────────────────────────────────────────────────────────────────────
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "python", "javascript" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- ─────────────────────────────────────────────────────────────────────────────
-- LSP Keymaps
-- ─────────────────────────────────────────────────────────────────────────────
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, opts)

  -- ─────────────── Autoformat on save ───────────────
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end

  -- ─────────────── Lint on save ───────────────
  if client.name == "efm" then
    vim.api.nvim_create_autocmd("BufWritePost", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.diagnostics() -- updates linting diagnostics
      end,
    })
  end
end


-- ─────────────────────────────────────────────────────────────────────────────
-- LSP + Completion + Snippets
-- ─────────────────────────────────────────────────────────────────────────────
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

require("mason").setup()

local cmp = require("cmp")
cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { "i", "s" }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = { { name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" }, { name = "path" } },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "tsserver", "efm" },
})

local lspconfig = require("lspconfig")
require("mason-lspconfig").setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({ capabilities = capabilities, on_attach = on_attach })
  end,
})

-- ─────────────────────────────────────────────────────────────────────────────
-- EFM (replacement for null-ls)
-- ─────────────────────────────────────────────────────────────────────────────
local efm_languages = {
  python = { { formatCommand = "black --fast -", formatStdin = true } },
  javascript = { { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true } },
  typescript = { { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true } },
}

lspconfig.efm.setup({
  on_attach = on_attach,
  init_options = { documentFormatting = true, codeAction = true },
  settings = { rootMarkers = { ".git/" }, languages = efm_languages },
})

-- ─────────────────────────────────────────────────────────────────────────────
-- Mason Tool Installer
-- ─────────────────────────────────────────────────────────────────────────────
require("mason-tool-installer").setup({
  ensure_installed = { "black", "prettier", "eslint_d", "efm-langserver" },
  run_on_start = true,
  auto_update = true,
})

-- ─────────────────────────────────────────────────────────────────────────────
-- Git Signs
-- ─────────────────────────────────────────────────────────────────────────────
require("gitsigns").setup()

-- ─────────────────────────────────────────────────────────────────────────────
-- Terminal
-- ─────────────────────────────────────────────────────────────────────────────
require("toggleterm").setup()
vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", { desc = "Toggle Terminal" })

-- ─────────────────────────────────────────────────────────────────────────────
-- Debugging (DAP)
-- ─────────────────────────────────────────────────────────────────────────────
require("mason-nvim-dap").setup({ ensure_installed = { "python", "node2" }, automatic_installation = true })

local dap = require("dap")
local dapui = require("dapui")
require("nvim-dap-virtual-text").setup()
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "Start/Continue Debugging" })
vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "Step Over" })
vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "Step Out" })
vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>B", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, { desc = "Open DAP REPL" })
vim.keymap.set("n", "<leader>dl", function() dap.run_last() end, { desc = "Run Last Debug" })

-- ─────────────────────────────────────────────────────────────────────────────
-- Auto-sync Lazy plugins on first install
-- ─────────────────────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  once = true,
  callback = function()
    require("lazy").sync()
    require("mason-lspconfig").setup()
    require("mason-tool-installer").setup()
    require("mason-nvim-dap").setup()
  end,
})
