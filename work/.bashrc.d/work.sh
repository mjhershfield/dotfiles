PATH="/shared/home/mjhershfield/.local/opt/clang/bin:$PATH"
# export PATH

# From Ben's new hire doc
. /apps/env/bashrc

# Definitely don't want to check in my API key lol
source ~/.bashrc.d/claude.sh

# Environment variables
export CC=clang
export CXX=clang++

# Helper functions
function get_jira_from_ws() {
	if [[ -n "$ASIC_HOME" ]]; then
		local str="$(git -C $ASIC_HOME rev-parse --abbrev-ref HEAD)"
		result="${str#*-}"   # Remove everything up to and including the first dash
		result="${result%%-*}" # Remove everything from the first dash onward
		echo "$result"
	fi
}

function get_dv_dir_from_ws() {
	if [[ -n "$ASIC_HOME" ]]; then
		local dv_dir="/nfs/sim/sco3/$USER/jira/$(get_jira_from_ws)"	
		mkdir -p "$dv_dir"
		echo "$dv_dir"
	else
		echo "/nfs/sim/sco3/$USER/jira/"
	fi
}

# Aliases and functions
alias srun_='srun --partition=interactive-amd --x11 --cpus-per-task=1 --mem=25G --export=ALL'
alias verdi='srun --partition=interactive-amd --x11 --cpus-per-task=1 --mem=25G --export=ALL /apps/synopsys/verdi/X-2025.06/bin/verdi -base'
alias dve='srun --partition=interactive-amd --x11 --cpus-per-task=1 --mem=25G --export=ALL /apps/synopsys/vcs/X-2025.06/bin/dve -full64'
alias cddd="cd /prj/sco3/data/$USER/"
alias pdd="pushd /prj/sco3/data/$USER/"
alias cddv='cd $(get_dv_dir_from_ws)'
alias pdv='pushd $(get_dv_dir_from_ws)'
alias cdah='cd $ASIC_HOME'
alias pah='pushd $ASIC_HOME'
alias sws='pgr > /dev/null && setupws && popd > /dev/null'
alias swsf='pgr > /dev/null && setupws skippy && popd > /dev/null'
alias va="nvim /prj/sco3/data/$USER/allocation.md"
alias ca="cat /prj/sco3/data/$USER/allocation.md"

function rbdev() {
    local branch="$(git -C $ASIC_HOME rev-parse --abbrev-ref HEAD)"
    git checkout dev && git pull && git checkout $branch && git rebase dev -i
}

# -------- RUNNING FLOWS --------
alias grtl="make -B gen_rtl"

function mod() {
	export TOP="$1"
	export BTOP="$1"
}

function gfs() {
	make gen_filelist_sim BTOP=${1:-$BTOP}
}

function elab() {
	# top = arg1 (default = $TOP if not provided
	local top="${1:-$TOP}"
	# btop = arg2 (default = arg1, then $BTOP if not provided)
	local btop="${2:-${1:-$BTOP}}"
	make elab TOP=$top BTOP=$btop
}

function lint() {
	# top = arg1 (default = $TOP if not provided
	local top="${1:-$TOP}"
	# btop = arg2 (default = arg1, then $BTOP if not provided)
	local btop="${2:-${1:-$BTOP}}"
	make lint TOP=$top BTOP=$btop
}

# TODO: make second argument that contains directory to search for test params?
# TODO: copy seed from previous run? maybe spin this out into mkrerundir or something
function mkregdir() {
    local new_dir="$(git -C $ASIC_HOME rev-parse --short HEAD).${1:-regr}"

    # Find the newest existing directory (before creating the new one)
    local prev_newest_dir
    prev_newest_dir=$(find . -maxdepth 1 -mindepth 1 -type d -printf "%T@ %p\n" \
        | sort -n \
        | tail -1 \
        | awk '{print $2}')

    # Create the new directory
    mkdir -p "$new_dir" || { echo "Error: Failed to create directory '$new_dir'"; return 1; }

    # Warn if no previous directory was found
    if [[ -z "$prev_newest_dir" ]]; then
        echo "Warning: No existing regressions found. Created '$new_dir' without run.cmd."
        return 0
    fi

    # Warn if run.cmd doesn't exist in the previous newest directory
    if [[ ! -f "$prev_newest_dir/run.cmd" ]]; then
        echo "Warning: run.cmd not found in '$prev_newest_dir'. Created '$new_dir' without run.cmd."
        return 0
    fi

    # Copy run.cmd from the previous newest directory into the new one
    cp "$prev_newest_dir/run.cmd" "$new_dir/run.cmd"
    echo "Created '$new_dir' and copied run.cmd from '$prev_newest_dir'."
}
