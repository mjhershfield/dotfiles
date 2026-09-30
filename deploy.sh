#!/bin/bash
# Only run this script from the root of the git repo!
# load machine-specific configuration

hostname=$(hostname -f)

case "$hostname" in
	ip*.compute.internal) machine_cfg="work"     ;;
	matthew-ultrabook)    machine_cfg="personal" ;;
esac

stow -D -v common $machine_cfg
stow -v common $machine_cfg

