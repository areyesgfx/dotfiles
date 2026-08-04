#!/usr/bin/env bash
#
# Sets up a new macOS machine from this dotfiles repo: installs the
# required Homebrew packages, oh-my-zsh + Powerlevel10k, symlinks every
# config file into place, and syncs nvim plugins. Safe to re-run.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d%H%M%S)"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This dotfiles repo targets macOS only." >&2
  exit 1
fi

link() {
  local src="$1" dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    return
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    mkdir -p "$BACKUP_DIR/$(dirname "${dst#"$HOME"/}")"
    mv "$dst" "$BACKUP_DIR/${dst#"$HOME"/}"
    echo "Backed up $dst -> $BACKUP_DIR/${dst#"$HOME"/}"
  fi

  ln -s "$src" "$dst"
  echo "Linked $dst -> $src"
}

########################################
# Homebrew + packages
########################################
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

########################################
# oh-my-zsh + Powerlevel10k
########################################
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "Installing oh-my-zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

P10K_DIR="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
  echo "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

########################################
# Symlink dotfiles
########################################
link "$DOTFILES_DIR/zsh/.zshrc"            "$HOME/.zshrc"
link "$DOTFILES_DIR/zsh/.zprofile"         "$HOME/.zprofile"
link "$DOTFILES_DIR/git/.gitconfig"        "$HOME/.gitconfig"
link "$DOTFILES_DIR/p10k/.p10k.zsh"        "$HOME/.p10k.zsh"
link "$DOTFILES_DIR/oh-my-zsh/aliases.zsh" "$HOME/.oh-my-zsh/custom/aliases.zsh"
link "$DOTFILES_DIR/nvim"                  "$HOME/.config/nvim"
link "$DOTFILES_DIR/claude/settings.json"  "$HOME/.claude/settings.json"

# Agent instructions (Claude Code reads ~/.claude/CLAUDE.md, which points at ~/AGENTS.md).
link "$DOTFILES_DIR/agent/AGENTS.md"    "$HOME/AGENTS.md"
link "$DOTFILES_DIR/agent/OPINIONS.md"  "$HOME/OPINIONS.md"
link "$DOTFILES_DIR/agent/VOICE.md"     "$HOME/VOICE.md"
link "$HOME/AGENTS.md"                  "$HOME/.claude/CLAUDE.md"

########################################
# Sync nvim plugins (lazy.nvim bootstraps itself on first launch)
########################################
echo "Syncing nvim plugins..."
nvim --headless "+Lazy! sync" +qa

echo "Done. Backups of any replaced files are in $BACKUP_DIR (if created)."
echo "Restart your shell, or run: exec zsh"
