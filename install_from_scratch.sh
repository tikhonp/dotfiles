# 0. Install theme (or from dotfiles)
curl https://raw.githubusercontent.com/sidnvy/gruvbox-terminal/master/gruvbox-dark.terminal -o gruvbox-dark.terminal

# 1. xcode-select --install

# 2. Install Homebrew

# 3. create ~/projects folder

# 4. install omzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# generate ssh key
ssh-keygen -t ed25519 -C ""
pbcopy < ~/.ssh/id_ed25519.pub
# add it to github account: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global user.name "TikhonP"
git config --global user.email ""

# 5. clone dotfiles
git clone git@github.com:TikhonP/dotfiles.git

brew install tmux
brew install ripgrep # nvim telescope
brew install fd # nvim rest
brew install neovim
brew install fzf
brew install go
brew install tree
brew install pkl
brew install pgcli

# 6. install dotfiles

# install apps:

brew install --cask appcleaner
brew install --cask google-chrome
brew install --cask outline-manager
brew install --cask outline
brew install --cask transmission
brew install --cask numi
brew install --cask discord
