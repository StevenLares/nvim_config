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
  -- Colors
  { "morhetz/gruvbox" },

  -- File Explorer
  { "nvim-tree/nvim-tree.lua", dependencies = "nvim-tree/nvim-web-devicons" },

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  -- Treesitter (better syntax highlighting)
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- LSP + Autocompletion
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },

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
-- Treesitter
-- ─────────────────────────────────────────────────────────────────────────────
require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = true },
})

-- ─────────────────────────────────────────────────────────────────────────────
-- LSP + Completion
-- ─────────────────────────────────────────────────────────────────────────────
local lspconfig = require("lspconfig")
local cmp = require("cmp")
cmp.setup({
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = { { name = "nvim_lsp" } },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.pyright.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig.tsserver.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- ─────────────────────────────────────────────────────────────────────────────
-- LSP Keymaps (VSCode-like)
-- ─────────────────────────────────────────────────────────────────────────────
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- Go to definition / declaration
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

  -- Hover documentation
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

  -- Signature help (parameter hints)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

  -- Rename symbol
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

  -- Code actions (quick fixes)
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

  -- List references
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

  -- Format file
  vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, opts)
end


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
require("mason").setup()
require("mason-nvim-dap").setup({
  ensure_installed = { "python", "node2" }, -- pick your adapters here
  automatic_installation = true,
})

local dap = require("dap")
local dapui = require("dapui")
require("nvim-dap-virtual-text").setup()
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- DAP keymaps
vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "Start/Continue Debugging" })
vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "Step Over" })
vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "Step Out" })
vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>B", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, { desc = "Open DAP REPL" })
vim.keymap.set("n", "<leader>dl", function() dap.run_last() end, { desc = "Run Last Debug" })
