# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
# Custom path modifications
# PATH="/opt/oss-cad-suite/bin:$PATH"
# export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

eval "$(starship init bash)"

alias ll='ls -l'
alias la='ls -la'
alias rm='echo Do not use rm! instead, use trash'
alias neofetch='fastfetch'
alias nv='nvim'
alias vim='nvim'
alias vi='nvim'

alias todos='nvim ~/Documents/Notes/todos.md ~/Documents/Notes/todones.md'

