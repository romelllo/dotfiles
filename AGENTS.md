# AGENTS.md

## Repository Overview

Personal dotfiles repository managed with **GNU Stow**. Each top-level directory
(`nvim/`, `wezterm/`, `zed/`, `zsh/`, `opencode/`) mirrors the home directory
structure (e.g., `nvim/.config/nvim/`). The repository configures five tools:

- **Neovim** -- kickstart.nvim-based config (`init.lua` + Lua modules)
- **WezTerm** -- terminal emulator config (`.wezterm.lua`)
- **Zed** -- editor settings, keymaps, themes, snippets, AI prompts (`settings.json`)
- **Zsh** -- shell config (`.zshrc`, `.zprofile`)
- **OpenCode** -- AI coding agent config (`opencode.json`, custom agents)

Platform: **macOS** (Homebrew, OrbStack). Consistent **Nord theme** across all tools.

## Build / Lint / Test Commands

There is **no build system, test suite, or CI/CD pipeline** in this repository.
The dotfiles are deployed via GNU Stow symlinks.

### Deployment (GNU Stow)

```bash
# Symlink a single package to $HOME
stow nvim          # creates ~/.config/nvim -> dotfiles/nvim/.config/nvim
stow zsh           # creates ~/.zshrc -> dotfiles/zsh/.zshrc

# Remove symlinks for a package
stow -D nvim

# Re-stow (remove then re-link)
stow -R nvim
```

### OpenCode Plugin Dependencies

```bash
# In opencode/.config/opencode/
bun install        # installs @opencode-ai/plugin
```

### Neovim Plugin Management

Plugins are managed by **lazy.nvim** (bootstrapped in `init.lua`).
LSP servers and tools are installed via **Mason** inside Neovim.

```
:Lazy sync          # update all Neovim plugins
:Mason              # manage LSP servers / formatters / linters
```

### Formatting Tools Referenced

| Tool      | Scope       | Config Location                       |
|-----------|-------------|---------------------------------------|
| `stylua`  | Lua files   | Neovim conform.nvim in `init.lua`     |
| `ruff`    | Python      | Zed `settings.json` (inline config)   |
| `ty`      | Python types| Zed `settings.json` language server   |

### Validation (manual)

```bash
# Check Lua syntax
luacheck nvim/.config/nvim/init.lua     # if luacheck installed

# Check JSON validity
python3 -m json.tool zed/.config/zed/settings.json > /dev/null

# Verify stow would work (dry run)
stow -n -v nvim
```

## Code Style Guidelines

### General Principles

- **Minimal, declarative configuration** -- prefer concise settings over verbose blocks.
- **Comments** -- use comments to explain *why*, not *what*. Commented-out code is
  acceptable for optional features that may be toggled later (see Neovim plugin files
  and Ruff rule ignores).
- **Trailing whitespace** -- remove on save (enforced in Zed `settings.json`).

### Lua (Neovim, WezTerm)

- **Formatter**: `stylua` (installed via Mason, run via conform.nvim).
- **Indentation**: 2 spaces (Neovim default for Lua in kickstart).
- **Strings**: double quotes for strings (`"string"`).
- **Local variables**: always use `local` -- avoid polluting the global scope.
- **Module pattern**: WezTerm uses `local config = wezterm.config_builder()` then
  `return config`. Neovim uses `require()` for module loading.
- **Naming**: `snake_case` for variables and functions; plugin specs use the standard
  lazy.nvim table format with string plugin names.
- **Comments**: `--` for single-line, `--[[ ]]` for multi-line blocks.

```lua
-- Good: local variable, double quotes, descriptive name
local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.font_size = 12
return config
```

### JSON (Zed, OpenCode)

- **Indentation**: 2 spaces.
- **Trailing commas**: allowed (Zed settings.json uses JSONC with trailing commas).
- **Comments**: `//` comments are used in Zed settings (JSONC format).
  OpenCode config (`opencode.json`) is strict JSON -- no comments.
- **Key ordering**: group related settings together (e.g., all `agent` settings,
  all `theme` settings). No strict alphabetical requirement.

### Zsh Shell

- **Section headers**: use boxed comment blocks to delimit sections:
  ```zsh
  ### --------------------------------------------------
  ### Section Name
  ### --------------------------------------------------
  ```
- **Quoting**: always double-quote variable expansions (`"$HOME/.config"`).
- **Aliases**: short, common replacements only (`ls="eza"`, `cd="z"`, `cat="bat"`).
- **Conditionals**: use `[[ ]]` (Zsh-style) over `[ ]`.
- **PATH modifications**: done in `.zprofile` or early in `.zshrc`.
- **Ordering in .zshrc**: (1) instant prompt, (2) env/PATH, (3) Oh My Zsh,
  (4) prompt theme, (5) plugins, (6) tools, (7) aliases.

### Python Style (Configured in Zed/Ruff)

Although this repo doesn't contain Python code, it configures Python tooling:

- **Line length**: 120 characters.
- **Target version**: Python 3.12.
- **Linting**: Ruff with `select = ["ALL"]` minus specific ignores:
  - Ignored: `ANN` (annotations), `D` (docstrings), `E501` (line length),
    `B905` (zip strict), `PLR0913` (too many args), `PD901` (df naming),
    `BLE001` (blind exception), `EM101`/`EM102` (exception messages),
    `TRY003`, `C408`, `NPY002`, `NPY201`, `EXE001`.
- **Formatter**: Ruff (via language server), with import organization on save.
- **Type checking**: `ty` language server (not basedpyright).
- **Virtual env detection**: looks for `.env`, `env`, `.venv`, `venv` directories.

### Naming Conventions

| Context              | Convention     | Example                          |
|----------------------|----------------|----------------------------------|
| Lua variables        | `snake_case`   | `config_builder`, `font_size`    |
| Lua plugin specs     | GitHub URL     | `"tpope/vim-sleuth"`             |
| Zsh aliases          | short lowercase| `ls`, `cd`, `cat`                |
| JSON keys            | `snake_case`   | `"buffer_font_size"`, `"vim_mode"` |
| Config directories   | lowercase      | `nvim/`, `zed/`, `opencode/`     |

### Error Handling

- **Zsh**: use conditional checks before sourcing files:
  ```zsh
  [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  ```
- **Lua (Neovim)**: kickstart.nvim uses `pcall` for safe requires and
  `vim.fn.executable()` checks before configuring external tools.
- **Stow**: use `.stow-local-ignore` files to exclude generated/transient files
  (see `zed/.stow-local-ignore`).

### File Organization

```
dotfiles/
  nvim/.config/nvim/         # Neovim: init.lua + lua/ modules
  wezterm/.wezterm.lua       # WezTerm: single config file
  zed/.config/zed/           # Zed: settings, keymap, themes, snippets, prompts
  zsh/.zshrc                 # Zsh: main shell config
  zsh/.zprofile              # Zsh: login shell profile
  opencode/.config/opencode/ # OpenCode: config + custom agents
```

### Git Conventions

- **Ignored files**: `.DS_Store`, `*.mdb`, Zed conversations/embeddings,
  OpenCode `node_modules`/`package.json`/`bun.lock` (per local `.gitignore`).
- Keep lockfiles (`lazy-lock.json`) committed for reproducible Neovim plugin versions.
- The `bun.lock` in opencode is gitignored -- only `opencode.json` and `agents/` are tracked.

### Adding New Tool Configurations

1. Create a directory named after the tool (e.g., `newtool/`).
2. Mirror the home directory structure inside it (e.g., `newtool/.config/newtool/`).
3. Add a `.stow-local-ignore` if the tool generates transient files.
4. Run `stow newtool` to symlink.
5. Update `README.md` with the new entry.
