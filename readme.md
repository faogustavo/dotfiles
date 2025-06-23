# Basic Tools

## Terminal

- ~~[Fish Shell](https://fishshell.com/)~~
- [NeoVim](https://neovim.io/)
- ~~[tmux](https://github.com/tmux/tmux)~~
- [Z](https://github.com/jethrokuan/z)
- [ASDF](https://asdf-vm.com/#/core-manage-asdf)
- [GHQ](https://github.com/x-motemen/ghq)
- [EXA](https://the.exa.website/#installation)
- [Github CLI](https://github.com/cli/cli)
- [NerdFonts](https://github.com/ryanoasis/nerd-fonts)
- [Warp](https://www.warp.dev/)

## MacOS Only

- ~~[iterm2](https://iterm2.com/)~~
- [HomeBrew](https://brew.sh/index_pt-br)

## Customizations/Configurations/Additional Tools

- Themes
  - [Catppuccin Latte](https://github.com/catppuccin/catppuccin)
    - [Fish](https://github.com/catppuccin/fish)
    - [tmux](https://github.com/catppuccin/tmux)
    - [nvim](https://github.com/catppuccin/nvim)
    - [iterm](https://github.com/catppuccin/iterm)


- ~~Fish Shell~~
  - [OhMyFish](https://github.com/oh-my-fish/oh-my-fish)
  - [Fisher](https://github.com/jorgebucaran/fisher)

- nvim
  - [Lazy nvim](https://github.com/folke/lazy.nvim) - Plugin Management
  - [Harpoon](https://github.com/ThePrimeagen/harpoon) - Buffer navigation
  - [Undotree](https://github.com/mbbill/undotree) - Change history
  - [nvim Tree](https://github.com/nvim-tree/nvim-tree.lua) - File explorer
  - [Tree Sitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlight

- ~~tmux~~
  - [TPM](https://github.com/tmux-plugins/tpm) - Pluggin Management
  - [Continuum](https://github.com/tmux-plugins/tmux-continuum) - Store sessions
  - [Ressurect](https://github.com/tmux-plugins/tmux-resurrect) - Both to keep sessions

- ASDF
  - [ASDF Java](https://github.com/halcyon/asdf-java)
  - [ASDF Node](https://github.com/asdf-vm/asdf-nodejs)
  - [ASDF Ruby](https://github.com/asdf-vm/asdf-ruby)

- ZShell
  - 

# Additional Tools

- [Boop](https://github.com/IvanMathy/Boop)
- [Kap](https://getkap.co/)
- [Jetbrains Toolbox](https://www.jetbrains.com/pt-pt/lp/toolbox/)
- [Raycast](https://www.raycast.com/)
- [Stats](https://github.com/exelban/stats)
- [Notion](https://www.notion.so)
- [Vysor](https://www.vysor.io/)
- [NordVPN](https://nordvpn.com/pt-br)
- [Grammarly](https://app.grammarly.com/)
- [One Password](https://1password.com/)

# Installation

### Initial requirements

Dependencies:

- Git
- GHQ
- Homebrew
- cURL + wget
  - Can get from brew
- Nerdfonts

Steps: 

1. Create a new SSH key and link it to the github account
1. Update your github configuration
  - `git config --global user.name "Gustavo Fao Valvassori"`
  - `git config --global user.email "faogustavo@gmail.com"`
  - `git config --global ghq.root "~/dev"`
1. Clone this repo using GHQ
  - `ghq get git@github.com:faogustavo/dotfiles.git`
1. Follow next steps to install dependencies

### ZSH

> First of all, install oh-my-zsh (https://ohmyz.sh/#install) before starting

```zsh
$ rm -rf ~/.zprofile ~/.zshenv ~/.zshrc
$ ln -s ~/dev/github.com/faogustavo/dotfiles/zsh/.zprofile ~/.zprofile
$ ln -s ~/dev/github.com/faogustavo/dotfiles/zsh/.zshenv ~/.zshenv
$ ln -s ~/dev/github.com/faogustavo/dotfiles/zsh/.zshrc ~/.zshrc
```

### ASDF

```bash
$ brew install asdf 
$ ln -s ~/dev/github.com/faogustavo/dotfiles/.asdfrc ~/.asdfrc
```

After installed, you need install the plugins, the tools, some dependencies, and set them as the global version:

```bash
$ # Java
$ asdf plugin add java https://github.com/halcyon/asdf-java.git
$ asdf install java openjdk-17.0.2
$ asdf set -u java openjdk-17.0.2
$ which java # Check that it's getting version from ASDF
$ java -version # Check if ruby version matches

# Node
$ asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
$ asdf install nodejs 16.20.1
$ asdf set -u nodejs 16.20.1
$ which node # Check that it's getting version from ASDF
$ node -v # Check if ruby version matches
$ npm i -g serve yarn

# Ruby
$ asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
$ asdf install ruby 3.2.2
$ asdf set -u ruby 3.2.2
$ which ruby # Check that it's getting version from ASDF
$ ruby -v # Check if ruby version matches
$ gem install bundler

# Check everything is installed
$ asdf current
```

### NVIM

```bash
$ brew install nvim
$ ln -s ~/dev/github.com/faogustavo/dotfiles/.vimrc ~/.vimrc
$ ln -s ~/dev/github.com/faogustavo/dotfiles/nvim ~/.config/nvim
$ nvim # Open NVIM to install libraries
```

### SSH

To manage multiple git accounts (Personal and Enterprise), we can use SSH config:

```bash
$ ssh-keygen -t rsa # Create poiting to ~/.ssh/id_rsa, not required if previously created
$ ssh-keygen -t rsa # Create pointing to ~/.ssh/id_enterprise
$ ln -s ~/dev/github.com/faogustavo/dotfiles/ssh/config ~/.ssh/config
```

### ~~Fish~~ (Deprecated?/Replaced with ZSH)

```bash
$ brew install fish
$ curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
$ touch ~/.config/fish/secrets.fish
$ ln -s ~/dev/github.com/faogustavo/dotfiles/fish/config.fish ~/.config/fish/config.fish # Fish can fail to load config file after this if you don't have ASDF installed. Worst case, just comment the first two lines
$ ln -s ~/dev/github.com/faogustavo/dotfiles/fish/theme ~/.local/share/omf/themes/catppuccin-fish
$ wget https://raw.githubusercontent.com/catppuccin/fish/main/themes/Catppuccin%20Latte.theme -O ~/.config/fish/themes/Catppuccin\ Latte.theme
$ fish_config theme save "Catppuccin Latte" # Set color scheme 
$ omf theme catppuccin-fish # Set terminal layout
```

Some utilities to use along with fish:

```bash
$ fisher install jethrokuan/z # easy file navigation
$ brew install exa # enable lla/llt
```

### ~~TMUX~~ (Deprecated?/Replaced With Warp)

```bash
$ brew install tmux
$ git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
$ ln -s ~/dev/github.com/faogustavo/dotfiles/.tmux.conf ~/.tmux.conf
$ tmux # On TMUX press "ctrl+b" and then "shift + i" to install dependencies
```

# Cheat-sheet

### TMUX

```md
* Leader key = C-b
* Navigate between sessions = <leader>s
* Split window horizontal = <leader>h
* Split window vertical = <leader>v
* Maximize/Minimize = <leader>m
* Close split window = <leader>x
* Navigate between split windows = <leader><arrow-key>
* Resize panel size
  * Left = <leader>n
  * Down = <leader>e
  * Up = <leader>i
  * Right = <leader>o
```

### NVIM

```md
* Leader key = " " # Space
* Git = <leader>gs
* Open tree navigation = <leader>e
* Navigate open buffers = <leader>C-e
* Navigate windows = C-w C-w
* File Finder = <leader>pf
* Fuzzy Finder = <leader>pf
* List file updates = <leader>u
```

# Other Changes

1. Create a hotkey window on iTerm to access on all places
1. Update iterm to Natural text editting
  > Profiles > Keys > Key Mapping > Presets
1. Install Iterm cappuccin theme
1. On iTerm, use Jetbrains Mono font
