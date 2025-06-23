# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
plugins=(eza git z)
source $ZSH/oh-my-zsh.sh

# ZSH ASDF
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
autoload -Uz compinit && compinit

# Eza
