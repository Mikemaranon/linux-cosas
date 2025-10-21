
-- ============================
-- Bootstrap lazy.nvim
-- ============================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- ============================
-- Plugins
-- ============================

require("lazy").setup({
  -- File tree
  { "nvim-tree/nvim-tree.lua", dependencies = "nvim-tree/nvim-web-devicons" },
  -- Terminal
  { "akinsho/toggleterm.nvim", version = "*", config = true },
  -- Bufferline
  { "akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons" },
  -- Colorscheme
  { "folke/tokyonight.nvim", lazy = false },
  -- LSP and completion
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  -- Fuzzy finder
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  -- Git integration
  { "lewis6991/gitsigns.nvim" },
})

-- ============================
-- Basic options
-- ============================

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.cursorline = true

-- ============================ 
-- Keymaps 
-- ============================ 
vim.g.mapleader = " "
local map = vim.keymap.set

-- NvimTree
map("n", "<leader>e", function()
    if vim.fn.mode() == "n" then
        vim.cmd("NvimTreeToggle")
    end
end, { desc = "Toggle file tree" })

-- ToggleTerm
map("n", "<leader>t", function()
    if vim.fn.mode() == "n" then
        vim.cmd("ToggleTerm")
    end
end, { desc = "Toggle terminal" })

-- Buffers
map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })

-- Telescope
map("n", "<leader>f", ":Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>g", ":Telescope live_grep<CR>", { desc = "Live grep" })

-- Abrir keybinds.txt
local keybinds_file = vim.fn.stdpath("config") .. "/keybinds.txt"
map("n", "<leader>B", function()
    vim.cmd("edit " .. keybinds_file)
end, { desc = "Open keybinds.txt" })

-- ============================
-- Salir del modo terminal con Esc
-- ============================
vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })

-- ============================
-- Colorscheme
-- ============================
vim.cmd([[colorscheme tokyonight]])

-- ============================
-- Nvim-tree setup (updated API)
-- ============================
local nvim_tree_api = require("nvim-tree.api")
require("nvim-tree").setup({
  view = { width = 30 },
  git = { enable = true },
  filters = { dotfiles = false },
})

-- ============================
-- ToggleTerm setup
-- ============================
require("toggleterm").setup{
  size = 10,
  open_mapping = [[<leader>t]],
  direction = "horizontal",
  close_on_exit = true,
}

-- ============================
-- Bufferline setup
-- ============================
require("bufferline").setup{}

-- ============================
-- Treesitter setup
-- ============================
require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
})

-- ============================
-- Git signs setup
-- ============================

require("gitsigns").setup()

-- ============================
-- LSP setup
-- ============================

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- LSP setup con nvim-lspconfig
lspconfig.pyright.setup{
  capabilities = capabilities,
}

lspconfig.lua_ls.setup{
  capabilities = capabilities,
}

-- ============================
-- Open layout at startup
-- ============================
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local nvim_tree_api = require("nvim-tree.api")

    -- Open terminal (toggleterm)
    -- require("toggleterm").toggle(1)
    
    -- Open NvimTree
    nvim_tree_api.tree.open()

    -- Focus stays on the main buffer
    vim.cmd("wincmd p")
  end,
})

-- ============================
-- Auto-refresh NvimTree when changing directories
-- ============================
vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    nvim_tree_api.tree.reload()
  end,
})
