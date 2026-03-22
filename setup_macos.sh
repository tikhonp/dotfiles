# 1. Install Apple's Command Line Tools, which are prerequisites for Git and Homebrew.

xcode-select --install


# 2. Install Homebrew, followed by the software listed in the Brewfile.

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

curl -s https://raw.githubusercontent.com/tikhonp/dotfiles/refs/heads/main/Brewfile | brew bundle --file=- -v


# 3. Create `~/projects` folder

mkdir -p ~/projects



# Bitwarden
#
# Configure OpenSSH: Edit your SSH configuration file (~/.ssh/config) to tell the macOS SSH client to use the Bitwarden agent's socket. Add the following configuration:

```bash
Host *
    IdentitiesOnly yes
    # Bitwarden SSH agent
    IdentityAgent ~/.bitwarden-ssh-agent.sock
```
