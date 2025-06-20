eval "$(/opt/homebrew/bin/brew shellenv)"

source ~/.asdf/asdf.fish
source ~/.asdf/plugins/java/set-java-home.fish
source ~/.config/fish/secrets.fish

set -gx ANDROID_HOME "/Users/faogustavo/Library/Android/sdk"
set -gx FLUTTER_HOME "/Users/faogustavo/.bin/flutter"
set -gx WABT_HOME "/Users/faogustavo/.bin/wabt/1.0.34"
set -gx MAESTRO_HOME "/Users/faogustavo/.maestro"
set -gx IDEA_HOME "/Users/faogustavo/dev/github.com/faogustavo/intellij-community"
set -gx MAVEN_REPOSITORY "/Users/faogustavo/.m2/repository"
set -gx PATH $ANDROID_HOME/platform-tools $ANDROID_HOME/emulator $ANDROID_HOME/cmdline-tools/latest/bin $FLUTTER_HOME/bin $WABT_HOME/bin $MAESTRO_HOME/bin /Users/faogustavo/.bin/prince/bin /Users/faogustavo/.bin /opt/homebrew/opt/libressl/bin $PATH

# git aliases
abbr -a gd "git diff -M"
abbr -a ga "git add"
abbr -a gaa "git add --all ."
abbr -a gbd "git branch -D"
abbr -a gst "git status"
abbr -a gca "git commit -am"
abbr -a gm "git merge --no-ff"
abbr -a gpt "git push --tags"
abbr -a gp "git push"
abbr -a grh "git reset --hard"
abbr -a gb "git branch"
abbr -a gcob "git checkout -b"
abbr -a gco "git checkout"
abbr -a gba "git branch -a"
abbr -a gcp "git cherry-pick"
abbr -a gl "git log --pretty=format:\"%Cgreen%h%Creset - %Cblue%an%Creset @ %ar : %s\""
abbr -a gl2 "git log --pretty='format:%Cgreen%h%Creset %an - %s' --graph"
abbr -a glv "git log --stat"
abbr -a gpom "git pull origin master"
abbr -a gcd 'cd "`git rev-parse --show-toplevel`"'
abbr -a gcf "git clean -fd"
abbr -a gcod "git checkout -- ."
abbr -a gpum "git pull upstream master"
abbr -a gpod "git push origin --delete"
abbr -a gsu "git status -uno"
abbr -a gcm "git commit -m"
abbr -a gcv "git commit --verbose"
abbr -a gc "git commit --verbose"
abbr -a gds "git diff | sublime"
abbr -a grm "git reset HEAD"
abbr -a gacm "git add . --all; git commit --verbose"
abbr -a gtd "git log --tags --simplify-by-decoration --pretty=\"format:%ai %d\""
abbr -a grs "git shortlog -s -n --all --no-merges"

alias branch_name="git branch | grep \* | cut -d ' ' -f2"
alias ggpush="git push -u origin (branch_name)"
alias gwip='git add --all; git commit -m "wip" --no-verify'
alias gunwip='git log -n 1 | grep -q -c wip; and git reset HEAD~1'
alias vim='nvim'

if type -q eza
  alias ll "eza -l -g --icons"
  alias lla "ll -a"
  alias llt "ll --tree --level 2 -a"
end

