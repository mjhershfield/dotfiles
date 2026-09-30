# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

export PATH
alias swapd='pushd +1'
alias nv='nvim'
alias vim='nvim'
alias ll='ls -l'
alias la='ls -la'
alias cdgr='cd $(git rev-parse --show-superproject-working-tree --show-toplevel | head -1)'
alias pgr='pushd $(git rev-parse --show-superproject-working-tree --show-toplevel | head -1)'

# Starship Prompt
eval "$(starship init bash)"
