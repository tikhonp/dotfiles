# 1. Install Apple's Command Line Tools, which are prerequisites for Git and Homebrew.

xcode-select --install

# 2. Install Homebrew, followed by the software listed in the Brewfile.

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew bundle --file ~/.dotfiles/Brewfile

curl -s https://raw.githubusercontent.com/tikhonp/dotfiles/refs/heads/main/Brewfile | brew bundle --file=-
