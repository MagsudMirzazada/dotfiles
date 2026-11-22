#!/usr/bin/env bash
# Set up these dotfiles on macOS. Safe to re-run.
#   1. brew bundle (Brewfile)
#   2. Install TPM (tmux plugin manager), the tmux plugins and the LazyVim starter
#   3. Move existing real config files to ~/.dotfiles_backup_<timestamp>/
#   4. stow starship tmux zsh-macos ghostty

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is for macOS only." >&2
  exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(starship tmux zsh-macos ghostty)
TARGETS=(
  .zshrc
  .zsh_aliases
  .config/starship.toml
  .config/tmux/tmux.conf
  .config/ghostty/config
)
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

info() { printf '\033[0;32m[INFO]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }

# 1. Homebrew packages
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Install it from https://brew.sh and re-run." >&2
  exit 1
fi
info "Installing Homebrew packages..."
brew bundle --no-upgrade --file="$DOTFILES_DIR/Brewfile"

# 2. TPM and tmux plugins
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  info "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  warn "TPM already installed, skipping"
fi

# LazyVim starter (same as debian-supplement). Never overwrite an existing config.
NVIM_DIR="$HOME/.config/nvim"
if [[ ! -e "$NVIM_DIR" ]]; then
  info "Installing LazyVim starter..."
  git clone --depth 1 https://github.com/LazyVim/starter "$NVIM_DIR"
  rm -rf "$NVIM_DIR/.git"
else
  warn "$NVIM_DIR already exists, skipping LazyVim"
fi

# 3. Back up real (non-symlink) files that would block stow
for rel in "${TARGETS[@]}"; do
  path="$HOME/$rel"
  if [[ -e "$path" && ! -L "$path" ]]; then
    mkdir -p "$(dirname "$BACKUP_DIR/$rel")"
    mv "$path" "$BACKUP_DIR/$rel"
    info "Backed up $path -> $BACKUP_DIR/$rel"
  fi
done

# 4. Stow (--no-folding links files, never whole directories)
info "Stowing: ${PACKAGES[*]}"
stow --no-folding -d "$DOTFILES_DIR" -t "$HOME" "${PACKAGES[@]}"

# tmux plugins need a tmux server with the config loaded.
# Never touch a server that is already running (it may hold your sessions).
if tmux list-sessions >/dev/null 2>&1; then
  warn "tmux is running; skipping plugin install. Press prefix + I inside tmux."
elif [[ -x "$TPM_DIR/bin/install_plugins" ]]; then
  info "Installing tmux plugins..."
  tmux start-server \; source-file "$HOME/.config/tmux/tmux.conf" 2>/dev/null || true
  "$TPM_DIR/bin/install_plugins" || warn "tmux plugin install failed; press prefix + I inside tmux"
  tmux kill-server 2>/dev/null || true
fi

info "Done. Open a new terminal or run: exec zsh"
