if [ $(uname) = Darwin ];then
brew uninstall emacs-plus
brew tap d12frosted/emacs-plus
brew install emacs-plus
##brew linkapps emacs-plus ##this thing has been deprecated
brew tap caskroom/fonts
brew cask install font-source-code-pro
fi
rm -rf ~/.emacs.d
git clone -b develop https://github.com/syl20bnr/spacemacs ~/.emacs.d
rm ~/.spacemacs
rm -rf ~/.emacs.d/private
curDir=$(pwd)
ln -s ${curDir}/dotspacemacs ~/.spacemacs
ln -s ${curDir}/spacemacs_private  ~/.emacs.d/private
