#!/bin/sh

setup_color() {
    # Only use colors if connected to a terminal
    if [ -t 1 ]; then
        RED=$(printf '\033[31m')
        GREEN=$(printf '\033[32m')
        YELLOW=$(printf '\033[33m')
        BLUE=$(printf '\033[34m')
        BOLD=$(printf '\033[1m')
        RESET=$(printf '\033[m')
    else
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        BOLD=""
        RESET=""
    fi
}

setup_color

echo
echo "${GREEN}Setting up your Mac...${RESET}"
echo         "**********************"

# Hide "last login" line when starting a new terminal session
touch $HOME/.hushlogin

# Install zsh
echo
echo "${YELLOW}Installing oh-my-zsh${RESET}"
echo          "--------------------"
if test -f "$HOME/.oh-my-zsh"; then
    rm -rf $HOME/.oh-my-zsh
fi
curl -L https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Symlink zsh prefs
echo
echo "${YELLOW}Setting up .zshrc${RESET}"
echo          "-----------------"
if test -f "$HOME/.oh-my-zsh"; then
    rm $HOME/.zshrc
fi
ln -s $HOME/.dotfiles/shell/.zshrc $HOME/.zshrc

# Add global gitignore
echo
echo "${YELLOW}Setting up .gitignore-global${RESET}"
echo          "----------------------------"
if test -f "$HOME/.gitignore-global"; then
    rm $HOME/.gitignore-global
fi
ln -s $HOME/.dotfiles/shell/.gitignore-global $HOME/.gitignore-global
git config --global core.excludesfile $HOME/.gitignore-global

# Symlink the Mackup config
#echo
#echo "${YELLOW}Setting up .mackup.cfg${RESET}"
#echo          "----------------------"
#rm $HOME/.mackup.cfg
#ln -s $HOME/.dotfiles/macos/.mackup.cfg $HOME/.mackup.cfg

# Activate z
echo
echo "${YELLOW}Setting up z.sh${RESET}"
echo          "----------------------"
cd ~/.dotfiles/shell
chmod +x z.sh
cd $DOTFILES

echo
echo "${YELLOW}Installing composer${RESET}"
echo          "-------------------"
EXPECTED_COMPOSER_CHECKSUM="$(curl https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_COMPOSER_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
if [ "$EXPECTED_COMPOSER_CHECKSUM" != "$ACTUAL_COMPOSER_CHECKSUM" ]; then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi
php composer-setup.php
rm composer-setup.php
if [ ! -d "/usr/local" ]; then
	mkdir -p -m 775 /usr/local
fi
if [ ! -d "/usr/local/bin" ]; then
    mkdir -p -m 775 /usr/local/bin
fi
mv $HOME/composer.phar /usr/local/bin/composer

echo
echo "${YELLOW}Installing homebrew${RESET}"
echo          "-------------------"
if test ! $(which brew); then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    echo "${RED}homebrew already installed${RESET}"
fi

# Update Homebrew recipes
echo
echo "${YELLOW}Updating homebrew${RESET}"
echo          "-----------------"
brew update

echo
echo "${YELLOW}Installing homebrew bundle${RESET}"
echo          "--------------------------"
brew tap homebrew/bundle

echo
echo "${YELLOW}Processing Brewfile${RESET}"
echo          "-------------------"
brew bundle

# Create a directory for global packages and tell npm where to store globally installed packages
echo
echo "${YELLOW}Setting up npm${RESET}"
echo          "--------------"
if [ ! -d "${HOME}/.npm-packages" ]; then
    mkdir "${HOME}/.npm-packages"
fi
npm config set prefix "${HOME}/.npm-packages"

# Set default MySQL root password and auth type.
echo
echo "${YELLOW}Configuring MySQL${RESET}"
echo          "-----------------"
mysql -u root -e "ALTER USER root@localhost IDENTIFIED WITH mysql_native_password BY 'password'; FLUSH PRIVILEGES;"

echo
echo "${YELLOW}Installing PECL imagick${RESET}"
echo          "-----------------------"
pecl install imagick

echo
echo "${YELLOW}Installing PECL xdebug${RESET}"
echo          "----------------------"
pecl install xdebug

echo
echo "${YELLOW}Installing Laravel${RESET}"
echo          "------------------------"
composer global require "laravel/installer"

echo
echo "${YELLOW}Installing Laravel Envoy${RESET}"
echo          "------------------------"
composer global require "laravel/envoy"

echo
echo "${YELLOW}Installing phpunit-watcher${RESET}"
echo          "--------------------------"
composer global require spatie/phpunit-watcher

echo
echo "${YELLOW}Installing mixed-content-scanner-cli${RESET}"
echo          "------------------------------------"
composer global require spatie/mixed-content-scanner-cli

echo
echo "${YELLOW}Installing Laravel Valet${RESET}"
echo          "------------------------"
composer global require laravel/valet
valet install

# Set macOS preferences
# We will run this last because this will reload the shell
echo
echo "${YELLOW}Setting macOS preferences${RESET}"
echo          "-------------------------"
cd $HOME/.dotfiles/macos
source ./macos.sh

echo
echo '++++++++++++++++++++++++++++++'
echo '++++++++++++++++++++++++++++++'
echo 'All done!'
echo 'Things to do to make the agnoster terminal theme work:'
echo '1. Install menlo patched font included in ~/.dotfiles/misc https://gist.github.com/qrush/1595572/raw/Menlo-Powerline.otf'
echo '2. Install patched solarized theme included in ~/.dotfiles/misc'

echo '++++++++++++++++++++++++++++++'
echo 'Some optional tidbits'

echo '1. Make sure dropbox is running first. If you have not backed up via Mackup yet, then run `mackup backup` to symlink preferences for a wide collection of apps to your dropbox. If you already had a backup via mackup run `mackup restore` You'\''ll find more info on Mackup here: https://github.com/lra/mackup.'
echo '2. Set some sensible os x defaults by running: $DOTFILES/macos/set-defaults.sh'
echo '3. Make a .dotfiles-custom/shell/.aliases for your personal commands'

echo '++++++++++++++++++++++++++++++'
echo '++++++++++++++++++++++++++++++'
