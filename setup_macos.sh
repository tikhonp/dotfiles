# 1. Install Apple's Command Line Tools, which are prerequisites for Git and Homebrew.
xcode-select --install

# 2. Install Homebrew, followed by the software listed in the Brewfile.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Install shadowrocket and enable vpn, then:
curl -s https://raw.githubusercontent.com/tikhonp/dotfiles/refs/heads/main/Brewfile | brew bundle --file=- -v

# 4. Setup Bitwarden SSH Agent, enable it in settings
#
# After Use this to fetch dotfiles by ssh for this session:
export SSH_AUTH_SOCK=/Users/tikhon/.bitwarden-ssh-agent.sock

# 5. Create `~/projects` folder
mkdir -p ~/projects

# 6. Clone repo into newly created
cd ~/projects
git clone git@github.com:TikhonP/dotfiles.git

7. Create symlinks in the Home directory to the real files in the repo.

```zsh
mkdir ~/.config # so not all dot-config will not symlinked

stow --target=$HOME . --dotfiles
```

