# dotfiles

Personal macOS dotfiles.
Symlinked into place by `install.sh`, so edits to files in `~` after setup are edits to this repo.

## Setup

```
git clone <this-repo> ~/code/personal/dotfiles
cd ~/code/personal/dotfiles
./install.sh
```

This installs Homebrew (if missing), the packages in `Brewfile`, oh-my-zsh, Powerlevel10k, symlinks every config file below into `~`, and syncs nvim plugins via lazy.nvim.
The script is idempotent - re-run it any time.
Anything it would overwrite gets moved to `~/.dotfiles_backup/<timestamp>/` first.

## What's here

| Path | Symlinked to | Purpose |
| --- | --- | --- |
| `zsh/.zshrc`, `zsh/.zprofile` | `~/.zshrc`, `~/.zprofile` | zsh config, oh-my-zsh, PATH setup |
| `git/.gitconfig` | `~/.gitconfig` | Git identity, LFS, credential helper |
| `p10k/.p10k.zsh` | `~/.p10k.zsh` | Powerlevel10k prompt config |
| `oh-my-zsh/aliases.zsh` | `~/.oh-my-zsh/custom/aliases.zsh` | Custom shell aliases |
| `nvim/` | `~/.config/nvim` | Neovim config (lazy.nvim, Harpoon, Telescope, treesitter) |
| `claude/settings.json` | `~/.claude/settings.json` | Claude Code settings (default model, enabled plugins) |
| `agent/AGENTS.md`, `agent/OPINIONS.md`, `agent/VOICE.md` | `~/AGENTS.md`, `~/OPINIONS.md`, `~/VOICE.md` | Agent harness instructions - not Claude-specific (`~/.claude/CLAUDE.md` links to `~/AGENTS.md`) |

`.claude/settings.local.json` in this repo is unrelated to any of the above - it's harness-managed session state (Bash permission approvals) auto-written by Claude Code while working in this project, not a dotfile. It's gitignored globally and shouldn't be committed.

Neovim plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim), which bootstraps itself on first launch and locks versions in `nvim/lazy-lock.json`.

## Manual steps not covered here

A few things weren't included because they're either machine-specific, need auth, or contain no reusable config beyond framework defaults:

- **Git Credential Manager**: `~/.gitconfig` points at `/usr/local/share/gcm-core/git-credential-manager`. Install it separately if you need HTTPS Git auth.
- **GitHub CLI auth**: run `gh auth login` after setup; the OAuth token isn't stored in dotfiles.
- **Go, pnpm, Google Cloud SDK**: `.zshrc` references these paths but installation is left to their own installers (Go SDK, `pnpm`, `gcloud`); the relevant lines are no-ops if those paths don't exist yet.
