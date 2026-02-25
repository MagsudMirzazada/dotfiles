# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_dups
setopt hist_ignore_space

# Tab completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Directory navigation
setopt autocd
setopt autopushd
setopt pushdignoredups

# Key bindings (emacs mode)
bindkey -e

# Load aliases
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Zsh plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Initialize Starship prompt
eval "$(starship init zsh)"

# fzf integration is appended below by ~/.fzf/install --all
