# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
done

# Alias hub to git for GitHub CLI magic
eval "$(hub alias -s)"

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

# If possible, add tab completion for many more commands
[ -f /etc/bash_completion ] && source /etc/bash_completion

# Source SCM Breeze
[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"

BREW_PREFIX=`brew --prefix`

# Bash completion for brew-installed packages
if [ -f ${BREW_PREFIX}/etc/bash_completion ]; then
  . ${BREW_PREFIX}/etc/bash_completion
fi

# Brew completion
if [ -f ${BREW_PREFIX}/Library/Contributions/brew_bash_completion.sh ]; then
    . ${BREW_PREFIX}/Library/Contributions/brew_bash_completion.sh
fi

# Generic Colouriser
if [ -f ${BREW_PREFIX}/etc/grc.bashrc ]; then
    . ${BREW_PREFIX}/etc/grc.bashrc
fi

# Set options for Git bash completion
if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	# Enable git command  autocompletion for 'g' as well
	complete -o default -o nospace -F _git g

	# Set EnvVar so prompt displays Git status
	GIT_PS1_SHOWDIRTYSTATE=true
fi

# Enable aws-cli completion
if [ -f /usr/local/bin/aws_completer ]; then
	complete -C aws_completer aws
fi

# Enable rbenv shims and autocompletion
# github.com/sstephenson/rbenv/
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Enable Bower autocompletion
if which bower > /dev/null; then eval "$(bower completion)"; fi

# Source the Twig bash completion file
[[ -s ~/.twig/twig-completion.bash ]] && source ~/.twig/twig-completion.bash

# Source `z` for jumping around
# github.com/rupa/z
[[ -s ${BREW_PREFIX}/etc/profile.d/z.sh ]] && source ${BREW_PREFIX}/etc/profile.d/z.sh
