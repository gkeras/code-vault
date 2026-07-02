-- ============================================================
-- BASIC DEFAULTS
-- ============================================================
vim.g.mapleader = " "        -- Setear ANTES de cargar plugins
local vim = vim

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.background = "dark"

-- ============================================================
-- PLUGINS 
-- ============================================================
vim.pack.add({
  { src = "https://github.com/catppuccin/nvim",                  name = "catppuccin" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter",  version = "main" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
})

-- ============================================================
-- COLORSCHEME (con protección para no romper el resto del init)
-- ============================================================
local ok_colors = pcall(vim.cmd.colorscheme, "catppuccin")
if not ok_colors then
  vim.notify("No se pudo cargar catppuccin", vim.log.levels.WARN)
end

-- ============================================================
-- TREESITTER
-- ============================================================
local ts = require("nvim-treesitter")

local parsers = {
  "lua", "vim", "vimdoc", "query",
  "python", "javascript", "typescript", "rust", "c",
}

-- Instala solo lo que falte, de forma asíncrona (API oficial, no :TSInstall)
local instalados = ts.get_installed and ts.get_installed() or {}
local faltantes = vim.tbl_filter(function(p)
  return not vim.tbl_contains(instalados, p)
end, parsers)

if #faltantes > 0 then
  ts.install(faltantes)
end

-- Activa el highlighting con treesitter para esos filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = parsers,
  callback = function() vim.treesitter.start() end,
})

-- ── LSP (fully automatic) ────────────────────────────────────────────
-- Add server names here when starting with a new language.
-- Find names via :Mason or https://github.com/mason-org/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
require('mason').setup()
require('mason').setup()

require('mason-lspconfig').setup({
  -- These get installed automatically if missing:
  ensure_installed = { 'lua_ls', 'pyright', 'ts_ls', 'rust_analyzer', 'clangd' },
  -- Installed servers are enabled automatically — no vim.lsp.enable() needed:
  automatic_enable = true,
})

-- ── Completion (built-in) ─────────────────────────────────────────────
vim.opt.completeopt = 'menu,menuone,noselect,popup'
vim.o.autocomplete  = true

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(ev)
    local map = function(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = desc })
    end

    -- ── Navigation ────────────────────────────────────────────────────
    map('n', 'gd',        vim.lsp.buf.definition,      'LSP: Go to definition')
    map('n', 'gD',        vim.lsp.buf.declaration,     'LSP: Go to declaration')
    map('n', 'gri',       vim.lsp.buf.implementation,  'LSP: Go to implementation')
    map('n', 'grt',       vim.lsp.buf.type_definition, 'LSP: Go to type definition')

    -- ── Symbols ───────────────────────────────────────────────────────
    map('n', 'grr',       vim.lsp.buf.references,      'LSP: References')
    map('n', 'gO',        vim.lsp.buf.document_symbol, 'LSP: Document symbols')
    map('n', '<leader>ws', vim.lsp.buf.workspace_symbol, 'LSP: Workspace symbols')

    -- --- Jerarquía de llamadas ---
    map('n', 'grc', vim.lsp.buf.incoming_calls, 'LSP: Incoming calls')
    map('n', 'gro', vim.lsp.buf.outgoing_calls, 'LSP: Outgoing calls')

    -- ── Actions ───────────────────────────────────────────────────────
    map('n', 'grn',       vim.lsp.buf.rename,          'LSP: Rename symbol')
    map({'n','v'}, 'gra', vim.lsp.buf.code_action,     'LSP: Code action')
    map('n', 'grx',       vim.lsp.codelens.run,        'LSP: Run code lens')
    map('n', '<leader>f', vim.lsp.buf.format,          'LSP: Format buffer')

    -- ── Docs / hints ──────────────────────────────────────────────────
    map('n', 'K',         vim.lsp.buf.hover,           'LSP: Hover docs')
    map('i', '<C-s>',     vim.lsp.buf.signature_help,  'LSP: Signature help')

    -- ── Diagnostics ───────────────────────────────────────────────────
    map('n', ']d',         vim.diagnostic.goto_next,   'LSP: Next diagnostic')
    map('n', '[d',         vim.diagnostic.goto_prev,   'LSP: Prev diagnostic')
    map('n', '<leader>e',  vim.diagnostic.open_float,  'LSP: Show diagnostic float')
    map('n', '<leader>D',  function()
      vim.diagnostic.open_float(nil, { scope = 'cursor' })
    end, 'LSP: Diagnostic under cursor')
    map('n', '<leader>q',  vim.diagnostic.setloclist,  'LSP: Diagnostics to loclist')
    map('n', '<leader>td', function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, 'LSP: Toggle diagnostics')
  end,
})

-- Starts lualine
require('lualine').setup()
