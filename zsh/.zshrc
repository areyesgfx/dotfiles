# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

########################################
# Homebrew (must come first)
########################################
eval "$(/opt/homebrew/bin/brew shellenv)"

# Add Homebrew Tcl/Tk support so Python can build with Tkinter
export LDFLAGS="-L/opt/homebrew/opt/tcl-tk/lib"
export CPPFLAGS="-I/opt/homebrew/opt/tcl-tk/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/tcl-tk/lib/pkgconfig"
export PATH="/opt/homebrew/opt/tcl-tk/bin:$PATH"

########################################
# User PATH overrides
########################################
# /usr/local/bin (Intel brew or Python.org installer if you use it)
export PATH="/usr/local/bin:$PATH"

# Go
export PATH="$HOME/sdk/go1.25.1/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

########################################
# Google Cloud SDK
########################################
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

########################################
# Oh My Zsh
########################################
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git aws)

source $ZSH/oh-my-zsh.sh

########################################
# Zoxide (correct init for zsh)
########################################
eval "$(zoxide init zsh)"

########################################
# Devbox completions
########################################
autoload -U compinit; compinit

########################################
# User configuration / aliases
########################################
# Example aliases
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias gr='cd "$(git rev-parse --show-toplevel)"'

alias tfi="terraform init"
alias tfp="terraform plan"
alias tfa="terraform apply"

alias tfws="terraform workspace select"
alias tfwn="terraform workspace new"
alias tfwd="terraform workspace delete"
alias tfwl="terraform workspace list"
alias tfwc="terraform workspace show"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
