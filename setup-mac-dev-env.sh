#!/bin/bash

# Create a folder which will contain the setup downloads
INSTALL_FOLDER=~/.macsetup
mkdir -p $INSTALL_FOLDER
MAC_SETUP_PROFILE=$INSTALL_FOLDER/macsetup_profile

# install brew
if ! hash brew
then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
else
  printf "\e[93m%s\e[m\n" "Brew is already installed."
fi

# CURL / WGET
brew install curl
brew install wget

{
  # shellcheck disable=SC2016
  echo 'export PATH="/usr/local/opt/curl/bin:$PATH"'
  # shellcheck disable=SC2016
  echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"'
  # shellcheck disable=SC2016
  echo 'export PATH="/usr/local/opt/sqlite/bin:$PATH"'
}>>$MAC_SETUP_PROFILE

# git
brew install git

# TODO: point this code to local files
# # Adding git aliases (https://github.com/thomaspoignant/gitalias)
# git clone https://github.com/thomaspoignant/gitalias.git $INSTALL_FOLDER/gitalias && echo -e "[include]\n    path = $INSTALL_FOLDER/gitalias/.gitalias\n$(cat ~/.gitconfig)" > ~/.gitconfig

# git hook to check if you are pushing aws secret (https://github.com/awslabs/git-secrets)
git secrets --register-aws --global
brew install git-secrets
git secrets --install ~/.git-templates/git-secrets
git config --global init.templateDir ~/.git-templates/git-secrets

# zsh and zsh completions
brew install zsh zsh-completions
sudo chmod -R 755 /usr/local/share/zsh
sudo chown -R root:staff /usr/local/share/zsh
{
  echo "if type brew &>/dev/null; then"
  echo "  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH"
  echo "  autoload -Uz compinit"
  echo "  compinit"
  echo "fi"
} >>$MAC_SETUP_PROFILE

# Install oh-my-zsh on top of zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install iterm https://www.iterm2.com
brew install --cask iterm2

brew install lsd                                                                                      # replacement for ls
{
  echo "alias ls='lsd'"
  echo "alias l='ls -l'"
  echo "alias la='ls -a'"
  echo "alias lla='ls -la'"
  echo "alias lt='ls --tree'"
} >>$MAC_SETUP_PROFILE


# Other CLI tools
brew install tree
brew install ack
brew install bash-completion
brew install jq
brew install htop
brew install tldr
brew install coreutils
brew install watch

brew install z
touch ~/.z
echo '. /usr/local/etc/profile.d/z.sh' >> $MAC_SETUP_PROFILE

brew install ctop

# Fonts (https://github.com/tonsky/FiraCode/wiki/Intellij-products-instructions)
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono

# Browser
brew install --cask google-chrome
brew install --cask firefox
brew install --cask microsoft-edge
brew install --cask brave-browswer

# Music / Video
brew install --cask vlc

# Productivity
brew install --cask kap
brew install --cask rectangle
brew install --cask clipy

# Communication
brew install --cask slack
brew install --cask discord


# Dev tools
brew install --cask ngrok
brew install --cask postman
brew install --cask jetbrains-toolbox
brew install --cask visual-studio-code

# Language
## Node / Javascript
mkdir ~/.nvm
brew install nvm
nvm install node
brew install yarn
brew tap oven-sh/bun
brew install bun

## Java
curl -s "https://get.sdkman.io" | bash                                                               # sdkman is a tool to manage multiple version of java
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java
brew install maven
brew install gradle

## golang
{
  echo "# Go development"
  echo "export GOPATH=\"\${HOME}/.go\""
  echo "export GOROOT=\"\$(brew --prefix golang)/libexec\""
  echo "export PATH=\"\$PATH:\${GOPATH}/bin:\${GOROOT}/bin\""
}>>$MAC_SETUP_PROFILE
brew install go

## python
echo "export PATH=\"/usr/local/opt/python/libexec/bin:\$PATH\"" >> $MAC_SETUP_PROFILE
brew install python
pip install --user pipenv
pip install --upgrade setuptools
pip install --upgrade pip
brew install pyenv
# shellcheck disable=SC2016
echo 'eval "$(pyenv init -)"' >> $MAC_SETUP_PROFILE


## terraform
brew install terraform
terraform -v

# Databases
brew install --cask dbeaver-community

# # Postgres command line
# brew install libpq
# brew link --force libpq
# shellcheck disable=SC2016
# echo 'export PATH="/usr/local/opt/libpq/bin:$PATH"' >> $MAC_SETUP_PROFILE

# SFTP
# Remote File Storage Interface (like s3)
brew install --cask cyberduck

# Docker
brew install --cask docker
brew install bash-completion
brew install docker-completion
brew install docker-compose-completion
brew install docker-machine-completion

# AWS command line
brew install awscli
# Supercharged AWS command line interface (CLI).
pip3 install saws
brew install aws-sso-util


# K8S command line
brew install kubectx
brew install asdf
asdf install kubectl latest
brew install k9s

# reload profile files.
{
  echo "source $MAC_SETUP_PROFILE # These alias and things were added by a mac setup script"
}>>"$HOME/.zsh_profile"
# shellcheck disable=SC1090
source "$HOME/.zsh_profile"

{
  echo "source $MAC_SETUP_PROFILE # These alias and things were added by a mac setup script"
}>>~/.bash_profile
# shellcheck disable=SC1090
source ~/.bash_profile