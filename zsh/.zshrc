# Load direnv
eval "$(direnv hook zsh)"

# Load mise
eval "$(mise activate zsh)"

source $HOME/.localrc

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(eza git git-prompt z zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# Envs
export IDEA_HOME="$HOME/dev/github.com/faogustavo/intellij-community"
export MAVEN_REPOSITORY="$HOME/.m2/repository"

# Editor
export EDITOR="nvim"
export VISUAL="$EDITOR"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Custom functionns
function mov2mp4() {
  local files
  if [ $# -gt 0 ]; then
    files=("$@")
  else
    files=(*.mov(N)) 
  fi

  if [ ${#files[@]} -eq 0 ]; then
    echo "No files found to process."
    return
  fi

  for f in "${files[@]}"; do
    if [ -f "$f" ]; then
      echo "Processing: $f"
      ffmpeg -i "$f" -vcodec libx264 -crf 28 "${f%.*}.mp4"
    else
      echo "Skipping: '$f' (File not found)"
    fi
  done
  echo "All tasks finished."
}
