# Neovim configuration

Minimal Neovim 0.12+ configuration using the built-in `vim.pack` package
manager. Plugins are installed automatically the first time Neovim starts.
Blink uses its portable Lua fuzzy matcher, so the configuration does not need a
Rust toolchain merely to provide completion.

## C and C++

The configuration enables Treesitter parsing, `clangd` language intelligence,
Blink completion, and `clang-format` formatting for C and C++.

Clangd needs the real compiler flags for non-trivial projects. CMake can
generate them in the conventional `build` directory, where clangd discovers
them automatically:

```bash
cmake -S . -B build -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

Use `:checkhealth vim.lsp` to inspect LSP activation and `:ConformInfo` to
inspect formatter availability.

## Keybindings

The leader key is `<Space>`.

| Key | Action |
| --- | --- |
| `<leader>w` | Save file |
| `<leader>qq` | Quit all |
| `H` / `L` | Previous/next buffer |
| `<leader>bd` | Delete buffer |
| `<leader>-` / `<leader>\|` | Horizontal/vertical split |
| `<C-h/j/k/l>` | Navigate windows |
| `gd` / `gD` | Go to definition/declaration |
| `gr` / `gi` | Go to references/implementation |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format file |
| `[d` / `]d` | Previous/next diagnostic |
| `[c` / `]c` | Previous/next Git hunk |
| `<leader>gb` | Git blame line |
| `<leader>gp` | Preview Git hunk |
