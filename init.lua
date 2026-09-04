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
opt.splitbelow = true
opt.splitright = true

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
		map("K", vim.lsp.buf.hover, "Hover documentation")
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
	keymap = { preset = "default" },
})

require("gitsigns").setup({
	on_attach = function(buffer)
		local gitsigns = require("gitsigns")
		local function git_map(mode, lhs, rhs, description)
			vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = description })
		end

		git_map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end, "Next Git hunk")
		git_map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end, "Previous Git hunk")
		git_map("n", "<leader>hs", gitsigns.stage_hunk, "Stage Git hunk")
		git_map("n", "<leader>hr", gitsigns.reset_hunk, "Reset Git hunk")
		git_map("x", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "Stage selected Git hunk")
		git_map("x", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "Reset selected Git hunk")
		git_map("n", "<leader>hp", gitsigns.preview_hunk, "Preview Git hunk")
		git_map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end, "Git blame line")
		git_map("n", "<leader>hd", gitsigns.diffthis, "Git diff against index")
	end,
})

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
	{ "<leader>h", group = "Git Hunk" },
	{ "<leader>w", group = "Window" },
	{ "<leader>x", group = "Diagnostics" },
})

local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>buffer #<cr>", { desc = "Alternate buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Split below" })
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Split right" })
map("n", "<leader>wd", "<cmd>close<cr>", { desc = "Close window" })
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map({ "n", "x" }, "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format file" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix list" })
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location list" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Previous quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("n", "[e", function()
	vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Previous error" })
map("n", "]e", function()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Next error" })
map("n", "[w", function()
	vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN, float = true })
end, { desc = "Previous warning" })
map("n", "]w", function()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN, float = true })
end, { desc = "Next warning" })
