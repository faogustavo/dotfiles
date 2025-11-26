# Added by Toolbox App
export PATH="$PATH:/Users/faogustavo/Library/Application Support/JetBrains/Toolbox/scripts"

# Android SDK
export ANDROID_HOME="/Users/faogustavo/Library/Android/sdk"
export USER_HOME_BIN="/Users/faogustavo/.local/bin"
export PATH="$ANDROID_HOME:$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/latest/bin"

# Added by Antigravity
export PATH="/Users/faogustavo/.antigravity/antigravity/bin:$PATH"

# Homebrew at the end to keep it as the final source of truth
eval "$(/opt/homebrew/bin/brew shellenv)"