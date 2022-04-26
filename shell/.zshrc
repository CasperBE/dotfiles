# Path to your dotfiles.
export DOTFILES=$HOME/.dotfiles

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.dotfiles/misc/oh-my-zsh-custom

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Hide username in prompt
DEFAULT_USER=`whoami`

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git composer macos)

source $ZSH/oh-my-zsh.sh

# Set numeric keys
# https://superuser.com/questions/742171/zsh-z-shell-numpad-numlock-doesnt-work

# 0 . Enter
#bindkey -s "^[Op" "0"
#bindkey -s "^[Ol" "."
#bindkey -s "^[OM" "^M"
# 1 2 3
#bindkey -s "^[Oq" "1"
#bindkey -s "^[Or" "2"
#bindkey -s "^[Os" "3"
# 4 5 6
#bindkey -s "^[Ot" "4"
#bindkey -s "^[Ou" "5"
#bindkey -s "^[Ov" "6"
# 7 8 9
#bindkey -s "^[Ow" "7"
#bindkey -s "^[Ox" "8"
#bindkey -s "^[Oy" "9"
# + -  * /
#bindkey -s "^[Ok" "+"
#bindkey -s "^[Om" "-"
#bindkey -s "^[Oj" "*"
#bindkey -s "^[Oo" "/"

# Load the shell dotfiles, and then some:
# * ~/.dotfiles-custom can be used for other settings you don’t want to commit.
for file in ~/.dotfiles/shell/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done

for file in ~/.dotfiles-custom/shell/.{exports,aliases,functions,zshrc}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

. $HOME/.dotfiles/shell/z.sh

# Alias hub to git
eval "$(hub alias -s)"

# Sudoless npm https://github.com/sindresorhus/guides/blob/master/npm-global-without-sudo.md
NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

# Import ssh keys in keychain
ssh-add -A 2>/dev/null;

# Enable autosuggestions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Load local bin
export PATH=/usr/local/bin:$PATH

# Load Composer tools
export PATH="$HOME/.composer/vendor/bin:$PATH"
