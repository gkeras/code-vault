-- ============================================================
-- BASIC DEFAULTS
-- ============================================================
local vim = vim
vim.g.mapleader = " "

vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.tabstop = 4       -- Render tabs as 4 spaces
vim.opt.softabstop = 4    -- Insert 4 spaces when pressing tab 
vim.opt.shiftwidth = 4    -- Indent by 4 spaces for auto-indent 
vim.opt.expandtab = true  -- Convert all tabs into spaces 

vim.opt.background = "dark"

-- ============================================================
-- BOOTSTRAP DE LAZY.NVIM
-- ============================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================
-- DECLARACIÓN DE PLUGINS (Carga asíncrona automatizada)
-- ============================================================
require("lazy").setup({
  -- Tema: Se carga de inmediato para evitar parpadeos (Priority 1000)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Línea de estado: Carga diferida en el primer evento UI
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require('lualine').setup()
    end,
  },

  -- Treesitter: Automatizado y anclado a versión estable para evitar errores
  {
    "nvim-treesitter/nvim-treesitter",
    version = "^0.9.3",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" }, -- Se carga solo al abrir un archivo
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "query", "python", "javascript", "typescript", "rust", "c" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Suite de LSP & Mason: Automatizado sin bloqueos en el arranque
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, -- Carga diferida hasta que abres código
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup({
        -- Recuerda tener instalados en tu Arch: 'nodejs', 'npm' (para pyright/ts_ls)
        ensure_installed = { 'lua_ls', 'pyright', 'ts_ls', 'rust_analyzer', 'clangd' },
        automatic_enable = true,
      })
    end,
  },
})

-- ============================================================
-- COMPLETION & CONFIGURACIONES NATIVAS (0.11+)
-- ============================================================
vim.opt.completeopt = 'menu,menuone,noselect,popup'
vim.o.autocomplete  = true

-- Mapeos nativos de LSP al adjuntarse el cliente al buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(ev)
    local map = function(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = desc })
    end

    map('n', 'gd',        vim.lsp.buf.definition,      'LSP: Go to definition')
    map('n', 'gD',        vim.lsp.buf.declaration,     'LSP: Go to declaration')
    map('n', 'gri',       vim.lsp.buf.implementation,  'LSP: Go to implementation')
    map('n', 'grt',       vim.lsp.buf.type_definition, 'LSP: Go to type definition')
    map('n', 'grr',       vim.lsp.buf.references,      'LSP: References')
    map('n', 'gO',        vim.lsp.buf.document_symbol, 'LSP: Document symbols')
    map('n', 'grn',       vim.lsp.buf.rename,          'LSP: Rename symbol')
    map({'n','v'}, 'gra', vim.lsp.buf.code_action,     'LSP: Code action')
    map('n', '<leader>f', vim.lsp.buf.format,          'LSP: Format buffer')
    map('n', 'K',         vim.lsp.buf.hover,           'LSP: Hover docs')
    map('i', '<C-s>',     vim.lsp.buf.signature_help,  'LSP: Signature help')
    map('n', ']d',         vim.diagnostic.goto_next,   'LSP: Next diagnostic')
    map('n', '[d',         vim.diagnostic.goto_prev,   'LSP: Prev diagnostic')
    map('n', '<leader>e',  vim.diagnostic.open_float,  'LSP: Show diagnostic float')
  end,
})
