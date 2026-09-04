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
| `<C-s>` | Save file |
| `<leader>qq` | Quit all |
| `H` / `L`, `[b` / `]b` | Previous/next buffer |
| `<leader>bb` | Alternate buffer |
| `<leader>bd` | Delete buffer |
| `<leader>-` / `<leader>\|` | Horizontal/vertical split |
| `<leader>wd` | Close window |
| `<C-h/j/k/l>` | Navigate windows |
| `gd` / `gD` | Go to definition/declaration |
| `grr` / `gri` | Go to references/implementation |
| `grn` / `gra` | Rename/code action |
| `grt` | Go to type definition |
| `K` | Hover documentation |
| `<leader>cf` | Format file |
| `[d` / `]d` | Previous/next diagnostic |
| `[e` / `]e` | Previous/next error |
| `[w` / `]w` | Previous/next warning |
| `[q` / `]q` | Previous/next quickfix item |
| `<leader>xq` / `<leader>xl` | Quickfix/location list |
| `[c` / `]c` | Previous/next Git hunk |
| `<leader>hs` / `<leader>hr` | Stage/reset Git hunk |
| `<leader>hp` | Preview Git hunk |
| `<leader>hb` | Git blame line |
| `<leader>hd` | Diff against Git index |
| `<C-y>` | Accept completion |
| `<C-n>` / `<C-p>` | Select next/previous completion |
| `<C-Space>` | Open completion/documentation |
