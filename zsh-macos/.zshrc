# macOS version of ../zsh/.zshrc (Homebrew paths, no ~/.zsh plugin clones)

# Homebrew (Intel: /usr/local, Apple Silicon: /opt/homebrew)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_dups
setopt hist_ignore_space

# Tab completion (include Homebrew completions)
[[ -n "$HOMEBREW_PREFIX" ]] && fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Directory navigation
setopt autocd
setopt autopushd
setopt pushdignoredups

# Key bindings (emacs mode)
bindkey -e
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[5D" backward-word
bindkey "^[[5C" forward-word

# Load aliases
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Zsh plugins (installed with brew)
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Initialize Starship prompt
eval "$(starship init zsh)"

# fzf
source <(fzf --zsh)
