-- Minimal Neovim configuration using the built-in package manager (Neovim 0.12+).

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true
opt.cursorline = true
opt.cursorlineopt = "number"
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.clipboard = "unnamedplus"

vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/catppuccin/nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/Saghen/blink.lib",
	"https://github.com/Saghen/blink.cmp",
})

vim.cmd.colorscheme("catppuccin-nvim")

require("nvim-treesitter").install({
	"c",
	"cpp",
	"cmake",
	"json",
	"lua",
	"markdown",
	"python",
	"rust",
	"toml",
	"vim",
	"vimdoc",
	"yaml",
	"zig",
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

vim.lsp.enable({ "clangd", "lua_ls", "pyright", "rust_analyzer", "zls" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local buffer = args.buf
		local function map(lhs, rhs, description)
			vim.keymap.set("n", lhs, rhs, { buffer = buffer, desc = description })
		end

		map("gd", vim.lsp.buf.definition, "Go to definition")
		map("gD", vim.lsp.buf.declaration, "Go to declaration")
		map("gr", vim.lsp.buf.references, "Go to references")
		map("gi", vim.lsp.buf.implementation, "Go to implementation")
		map("K", vim.lsp.buf.hover, "Hover documentation")
		map("<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
		map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
		map("[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, "Previous diagnostic")
		map("]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "Next diagnostic")
	end,
})

local cmp = require("blink.cmp")
cmp.setup({
	completion = { ghost_text = { enabled = true } },
	fuzzy = { implementation = "lua" },
	keymap = {
		preset = "default",
		["<CR>"] = { "accept", "fallback" },
	},
})

require("gitsigns").setup()

require("lualine").setup({
	options = {
		theme = "catppuccin-nvim",
		component_separators = "|",
		section_separators = "",
	},
})

require("conform").setup({
	formatters_by_ft = {
		c = { "clang_format" },
		cpp = { "clang_format" },
		json = { "prettier" },
		lua = { "stylua" },
		markdown = { "prettier" },
		python = { "ruff_format" },
		rust = { "rustfmt" },
		yaml = { "prettier" },
		zig = { "zigfmt" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

require("which-key").setup({ delay = 300 })
require("which-key").add({
	{ "<leader>b", group = "Buffer" },
	{ "<leader>c", group = "Code" },
	{ "<leader>f", group = "File" },
	{ "<leader>g", group = "Git" },
	{ "<leader>w", group = "Window" },
	{ "<leader>x", group = "Diagnostics" },
})

local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Split below" })
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Split right" })
map("n", "<leader>wd", "<cmd>close<cr>", { desc = "Close window" })
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format file" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix list" })
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location list" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Previous quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("n", "]c", function()
	require("gitsigns").nav_hunk("next")
end, { desc = "Next git hunk" })
map("n", "[c", function()
	require("gitsigns").nav_hunk("prev")
end, { desc = "Previous git hunk" })
map("n", "<leader>gb", function()
	require("gitsigns").blame_line()
end, { desc = "Git blame" })
map("n", "<leader>gp", function()
	require("gitsigns").preview_hunk()
end, { desc = "Preview git hunk" })
map("n", "<leader>gr", function()
	require("gitsigns").reset_hunk()
end, { desc = "Reset git hunk" })
