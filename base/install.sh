mv ~/.zshrc $DOTFILES_OLD_CONFS_PATH/zshrc
mv ~/.zsh_profile $DOTFILES_OLD_CONFS_PATH/zsh_profile

rm ~/.zshrc
rm ~/.zsh_profile

cp ./zshrc $HOME/.zshrc
cp ./zsh_profile $HOME/.zsh_profile
