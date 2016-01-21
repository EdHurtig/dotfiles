#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

read -e "Enter Email"
EMAIL=$_email
function install() {
	_setup_network;

	_install_bash_it;

	_install_brew;

	_install_brew_packages;

	_install_dev_tools;

	# rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
	# 	--exclude "README.md" --exclude "LICENSE-MIT.txt" -avh --no-perms . ~;
	source ~/.bash_profile;
}

function  _setup_network() {
	echo $PASS | sudo -S hostname $HOSTNAME
	echo $PASS | sudo -S scutil –-set HostName "$HOSTNAME"
}

function _install_brew() {
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function _install_brew_packages() {
	brew install wget
	brew install npm
}

function _install_dev_tools() {
	_install_atom;
	_setup_dev_path;
}

function _install_python() {
	echo $PASS | sudo -S easy_install pip
	pip install flask
}

function _install_bash_it() {
	if [[ ! -d "~/.bash_it" ]]; then
		echo "Installing Bash It"
		mv .bash_it ..
		~/.bash_it/install.sh
	else:
		echo "Bash It is already installed... skipping"
	fi
}

function _install_atom() {
	wget https://atom.io/download/mac -O /tmp/atom.zip
	unzip /tmp/atom.zip -d /Applications
}

function _install_dev_path() {
	mkdir ~/dev
}

function _install_iterm() {
	wget https://iterm2.com/downloads/stable/iTerm2-2_1_4.zip -O /tmp/iterm.zip
	unzip /tmp/iterm.zip -d /Applications
	open "solarized/iterm2-colors-solarized/Solarized Dark.itermcolors"
	open "solarized/iterm2-colors-solarized/Solarized Light.itermcolors"
}

function _configure_terminal() {
	open "solarized/osx-terminal.app-colors-solarized/Solarized Dark ansi.terminal"
	open "solarized/osx-terminal.app-colors-solarized/Solarized Light ansi.terminal"
}

function _gen_keys() {
	echo "Generating RSA Key"
	ssh-keygen -t rsa -P "$PASS" -C "$EMAIL $(hostname)"
	cat ~/.ssh/id_rsa.pub | pbcopy
	echo "Public SSH Key has been copied to your clipboard"
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	# install;
	echo "Force Install Not Implemented"
else
	read -p "Enter Email " -n 1;
	echo "";
	EMAIL=$REPLY

	if [ ! -f "~/.ssh/password.txt" ]; then
		echo "Please store your base64 encoded password in ~/.ssh/password.txt"
		exit 1
	else
		PASS=$(cat "~/.ssh/password.txt" | base64 -D)
	fi

	read -p "Enter Hostname $(hostname) " -n 1;
	echo "";
	HOSTNAME=$REPLY

	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		install;
	fi;
fi;
