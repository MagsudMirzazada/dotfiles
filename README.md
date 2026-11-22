# dotfiles

Personal configs, managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level folder is a stow package whose contents mirror `$HOME`.

| Package | Installs | Used on |
| --- | --- | --- |
| `zsh` | `~/.zshrc`, `~/.zsh_aliases` | Linux (Debian, Arch) |
| `zsh-macos` | `~/.zshrc`, `~/.zsh_aliases` (Homebrew paths, `bat`, BSD `ls`, `pbcopy`) | macOS |
| `starship` | `~/.config/starship.toml` | all |
| `tmux` | `~/.config/tmux/tmux.conf` | all |
| `ghostty` | `~/.config/ghostty/config` | all |
| `backgrounds` | `~/.config/backgrounds/` | Linux desktop |

Stow only one of `zsh` or `zsh-macos` on a machine. They write the same files.

## macOS

Requires [Homebrew](https://brew.sh). Install Ghostty separately (`brew install --cask ghostty`).

```sh
git clone https://github.com/MagsudMirzazada/dotfiles ~/dotfiles
~/dotfiles/bootstrap-macos.sh
```

The script installs the packages in `Brewfile`, installs TPM and the tmux plugins, moves any existing config files to `~/.dotfiles_backup_<timestamp>/`, then stows `starship tmux zsh-macos ghostty`. It is safe to re-run.

Manual equivalent:

```sh
brew bundle --file=~/dotfiles/Brewfile
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cd ~/dotfiles && stow --no-folding -t ~ starship tmux zsh-macos ghostty
```

## Linux

Use the installers in [debian-supplement](https://github.com/MagsudMirzazada/debian-supplement) or [omarchy-supplement](https://github.com/MagsudMirzazada/omarchy-supplement). They clone this repo and stow `zsh`, `starship` and `tmux`.

## Notes

- Always stow with `--no-folding` so Stow links individual files, not whole directories.
- Preview with `stow -nv ...` before applying.
- Do not use `stow --adopt`. It overwrites repo files with whatever is in `$HOME`.
