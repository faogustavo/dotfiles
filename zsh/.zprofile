# ASDF
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
. ~/.asdf/plugins/java/set-java-home.zsh

# Added by Toolbox App
export PATH="$PATH:/Users/faogustavo/Library/Application Support/JetBrains/Toolbox/scripts"

# Android SDK
export ANDROID_HOME="/Users/faogustavo/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/latest/bin"

# Homebrew at the end to keep it as the final source of truth
eval "$(/opt/homebrew/bin/brew shellenv)"