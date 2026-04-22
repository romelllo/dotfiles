# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles managed with **GNU Stow**. Each top-level directory mirrors `$HOME` (e.g., `nvim/.config/nvim/` → `~/.config/nvim/`). Platform: macOS (Homebrew, OrbStack).

There is no build system, test suite, or CI/CD. See `AGENTS.md` for full style guidelines.

## Deployment

```bash
stow nvim          # symlink a package to $HOME
stow -D nvim       # remove symlinks
stow -R nvim       # re-stow (remove + re-link)
stow -n -v nvim    # dry-run to verify before applying
```

OpenCode plugin dependencies (in `opencode/.config/opencode/`):
```bash
bun install
```

## Neovim Plugin & LSP Management (inside Neovim)

```
:Lazy sync    # update plugins (lazy.nvim)
:Mason        # manage LSP servers / formatters / linters
```

`lazy-lock.json` is committed — keep it updated after `:Lazy sync`.

## Validation

```bash
luacheck nvim/.config/nvim/init.lua          # Lua syntax (if luacheck installed)
python3 -m json.tool zed/.config/zed/settings.json > /dev/null  # JSON validity
```

## Architecture

### Neovim (`nvim/.config/nvim/`)
Kickstart.nvim base. `init.lua` (~1086 lines) bootstraps lazy.nvim and declares most plugin specs inline. Modular overrides live in:
- `lua/kickstart/plugins/` — individual plugin configs (debug, gitsigns, lint, neo-tree, etc.)
- `lua/custom/plugins/init.lua` — user extension point (currently empty)

Key plugins: `blink.cmp` (completion), `conform.nvim` (formatting via stylua), `nvim-lspconfig` + Mason (LSP), `telescope.nvim` (fuzzy find), `nvim-dap` + `nvim-dap-ui` (debugging Go + Python).

### Zed (`zed/.config/zed/`)
Single `settings.json` (JSONC). AI default model: Claude Sonnet 4.6. Python toolchain: `ty` (type checking) + `ruff` (linting/formatting, 120-char lines, Python 3.12). Custom themes in `themes/`, snippets in `snippets/`, AI system prompts in `system_prompts/`.

### OpenCode (`opencode/.config/opencode/`)
`opencode.json` configures provider (GitHub Copilot), models (claude-opus-4-6 default, claude-haiku-4-5 small), 200k input / 8k output limits, auto-compaction. Custom agents in `agents/` (docs-writer, review).

### WezTerm (`wezterm/.wezterm.lua`)
Single-file config. WebGpu/Metal renderer, JetBrainsMono Nerd Font 12pt, Catppuccin Mocha theme.

### Zsh (`zsh/`)
`.zprofile` — Homebrew init, OrbStack integration. `.zshrc` — Powerlevel10k prompt, zsh-syntax-highlighting, zsh-autosuggestions, NVM, zoxide. Aliases: `ls=eza`, `cd=z`, `cat=bat`. Default editor: nvim.

## Code Style

### Lua (Neovim, WezTerm)
- 2-space indent, double-quoted strings, always `local`
- Formatter: `stylua` (via conform.nvim)

### JSON / JSONC (Zed settings, OpenCode)
- 2-space indent; Zed uses JSONC (trailing commas + `//` comments allowed); `opencode.json` is strict JSON

### Zsh
- Section headers: boxed `### ---` blocks
- Always double-quote variable expansions; use `[[ ]]` over `[ ]`
- Guard sourced files: `[[ -f file ]] && source file`

### Adding a New Tool
1. Create `<tool>/` directory mirroring `$HOME` structure.
2. Add `.stow-local-ignore` if the tool generates transient files (see `zed/.stow-local-ignore`).
3. Run `stow <tool>`.
4. Update `README.md`.
