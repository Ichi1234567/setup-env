#!/usr/bin/env bash

# install command line tools without xcode
if test ! $(xcode-select -v); then
  echo "install command line tools..."
  xcode-select --install
fi

# install oh-my-zsh
# https://github.com/robbyrussell/oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install n
# https://github.com/mklement0/n-install
if test ! $(which n); then
  echo "install n..."
	curl -L https://git.io/n-install | N_PREFIX=~/util/n bash -s -- -y
	# Added by n-install (see http://git.io/n-install-repo).
	echo '# n' >> ~/.zshrc
	echo "$(export N_PREFIX="$HOME/util/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin")" >> ~/.zshrc
  n stable
else
  echo "update n..."
  n-update -y
fi

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Updating Homebrew"
  brew update
fi

# require others
. ./utils/checkInstall.sh

# install brew packages

INSTALLED_PKGS=( $(brew list) )

PACKAGES=(
  git
  git-extras
  haskell-stack
  httpie
  mas
  peco
  rbenv
  ruby-build
  the_silver_searcher
  tig
  vim
  watchman
)
IGNORE_DEPENDENCIES_PACKAGES=(
  yarn
)

echo "install brew packages..."

optTest \
  -i "${PACKAGES[@]}" \
  -e "${INSTALLED_PKGS[@]}" \
  -u false

exit 0

checkInstall \
  "${#PACKAGES[@]}" "${PACKAGES[@]}" \
  "${#INSTALLED_PKGS[@]}" "${INSTALLED_PKGS[@]}" \


checkInstall \
  "${#IGNORE_DEPENDENCIES_PACKAGES[@]}" "${IGNORE_DEPENDENCIES_PACKAGES[@]}" \
  "${#INSTALLED_PKGS[@]}" "${INSTALLED_PKGS[@]}"

echo "Clean up ..."
brew cleanup

# rbenv settings
if [[ ! " ${INSTALLED_PKGS[@]} " =~ " rbenv " ]]; then
	echo '# rbenv' >> ~/.zshrc
	echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.zshrc
fi
# install cask apps
brew tap caskroom/cask

INSTALLED_CASK=( $(brew cask list) )

CASKS=(
  alfred
  andriod-studio
  charles
  dash
  discord
  dropbox
  firefox
  free-ruler
  genymotion
  gitter
  google-chrome
  hosts
  java
  licecap
  ngrok
  openemu
  reactotron
  sketch
  skitch
  slack
  spotify
  telegram-desktop
  visual-studio-code
  zeplin
)

echo "upgrade installed cask apps..."
brew cask upgrade

echo "install cask apps..."

checkInstall \
  "${#CASKS[@]}" "${CASKS[@]}" \
  "${#INSTALLED_CASK[@]}" "${INSTALLED_CASK[@]}" \
  --without-upgrade
# for cask in "${CASKS[@]}"
# do
# 	if [[ ! " ${INSTALLED_CASK[@]} " =~ " ${cask} " ]]; then
#     # whatever you want to do when arr doesn't contain value
#     echo "install ${cask}..."
#     brew cask install ${cask}
# 	fi
# done

# install font
brew tap caskroom/fonts

FONTS=(
  font-lato
)

echo "install fonts..."
for font in "${FONTS[@]}"
do
	if [[ ! " ${INSTALLED_CASK[@]} " =~ " ${font} " ]]; then
    # whatever you want to do when arr doesn't contain value
    echo "install ${font}..."
    brew cask install ${font}
	fi
done

echo "cask cleans up cached downloads..."
brew cask cleanup

# install from app store
APPS=(
  1091189122 # https://itunes.apple.com/tw/app/bear/id1091189122?mt=12
)

echo "install app..."
for app in "${APPS[@]}"
do
  echo "install ${app}..."
  mas install ${app}
done