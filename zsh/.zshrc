### --------------------------------------------------
### Powerlevel10k instant prompt (MUST BE FIRST)
### --------------------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### --------------------------------------------------
### Environment & PATH (silent only)
### --------------------------------------------------
export PATH="/opt/homebrew/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"

### --------------------------------------------------
### Oh My Zsh config
### --------------------------------------------------
ZSH_THEME=""               # Disable OMZ themes (Powerlevel10k only)
plugins=(git)

source "$ZSH/oh-my-zsh.sh"

### --------------------------------------------------
### Prompt (Powerlevel10k)
### --------------------------------------------------
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

### --------------------------------------------------
### Plugins (after prompt)
### --------------------------------------------------
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

### --------------------------------------------------
### Tools (may produce output — safe here)
### --------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

eval "$(zoxide init zsh)"

### --------------------------------------------------
### Aliases & UX
### --------------------------------------------------
alias ls="eza"
alias cd="z"
alias cat="bat"

### --------------------------------------------------
### Default programs
### --------------------------------------------------
export EDITOR=nvim
