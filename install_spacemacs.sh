brew uninstall emacs-plus
brew tap d12frosted/emacs-plus
brew install emacs-plus
brew linkapps emacs-plus
brew tap caskroom/fonts
brew cask install font-source-code-pro
rm -rf ~/.emacs.d
rm ~/.spacemacs
rm ~/.private
git clone -b develop https://github.com/syl20bnr/spacemacs ~/.emacs.d
ln -s ./dotspacemacs ~/.spacemacs
ln -s ./spacemacs_private  ~/.emacs.d/private
