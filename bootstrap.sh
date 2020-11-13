#!/bin/sh

# bootstrap my new macOS computer

function bootstrapTerminal() {
	echo
	echo 'Please provide your sudo password:'
	sudo -v #ask password beforehand

	# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

	source ~/.dotfiles/shell/installscript.sh
}

clear
echo 'Bootstrap terminal'
echo '------------------'
echo 'This will reset your terminal. Are you sure you want to to this?'
read -p '(y/n) '  reply

if [[ $reply =~ ^[Yy]$ ]]
then
   bootstrapTerminal
fi