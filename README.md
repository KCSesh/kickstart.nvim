# Modular Neovim Configuration

This is a modular Neovim configuration based on kickstart.nvim, reorganized for better maintainability.

## Structure

```
~/.config/nvim-new/
├── init.lua                    # Main entry point
├── lua/
│   ├── config/
│   │   ├── autocmds.lua       # All autocommands
│   │   ├── keymaps.lua        # Centralized keymaps
│   │   └── options.lua        # Vim options/settings
│   └── plugins/               # Individual plugin files
│       ├── bufferline.lua     # Buffer tabs
│       ├── colorscheme.lua    # Kanagawa theme
│       ├── conform.lua        # Code formatting
│       ├── gitsigns.lua       # Git integration
│       ├── harpoon.lua        # File navigation (commented out)
│       ├── lazygit.lua        # Git UI
│       ├── lsp.lua            # LSP configuration (commented out)
│       ├── lualine.lua        # Status line
│       ├── mini.lua           # Mini.nvim modules
│       ├── neotree.lua        # File explorer
│       ├── nvim-cmp.lua       # Autocompletion
│       ├── rustaceanvim.lua   # Rust support
│       ├── telescope.lua      # Fuzzy finder
│       ├── todo-comments.lua  # TODO highlighting
│       ├── treesitter.lua     # Syntax highlighting
│       ├── undotree.lua       # Undo history
│       └── which-key.lua      # Keymap help
```

## Key Features

### Centralized Keymaps
All keymaps are defined in `lua/config/keymaps.lua` for easy management:

- **Buffer Navigation**: `Shift+h/l` (prev/next), `<leader>bd` (delete)
- **File Explorer**: `\` (toggle NeoTree)
- **Git**: `<leader>lg` (LazyGit)
- **Undo**: `<leader>u` (UndoTree)
- **Telescope**: `<leader>sf`, `<leader>sg`, `<leader>sh`, etc.

### Plugin Setup Functions
Plugins that need complex keymaps use setup functions called from the plugin config:
- `M.setup_lsp_keymaps(event)` - LSP keymaps when attached
- `M.setup_rustacean_keymaps(bufnr)` - Rust-specific keymaps

### Current Status
- ✅ Working: All plugins except LSP and Harpoon
- ❌ LSP: Commented out due to mason-lspconfig version compatibility issue
- ❌ Harpoon: Commented out temporarily

## Usage

## Adding New Plugins

1. Create a new file in `lua/plugins/`
2. Add keymaps to `lua/config/keymaps.lua`
3. For complex plugin keymaps, create a setup function in keymaps.lua and call it from the plugin config

## Colorscheme

Currently using Kanagawa theme. To switch back to Tokyo Night, uncomment the tokyonight section in `lua/plugins/colorscheme.lua` and update the lualine theme accordingly.
