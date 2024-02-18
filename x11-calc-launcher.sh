#!/bin/sh

MODEL=""
OPTS=""

_launch() {
# shellcheck disable=SC1090  # intended include
. "${XDG_CONFIG_HOME}"/x11-calc/x11-calc.conf
[ -z "$MODEL" ] && exit 1

case $MODEL in
	10c|11c|12c|15c|16c)
		# if OPTS does not point to a rom file, set expected option to default location
		# no need to check file existence: app will error-out with proper message if missing
		[ -n "${OPTS##*.rom*}" ] || [ -z "${OPTS}" ] && OPTS="-r ${XDG_DATA_HOME}/x11-calc/${MODEL}.rom"
	;;
esac

# shellcheck disable=SC2086  # intended for parameter passsing
exec /app/bin/x11-calc-${MODEL} ${OPTS}
}

_setup() {
nano "${XDG_CONFIG_HOME}"/x11-calc/x11-calc.conf
}


if ! [ -f "${XDG_CONFIG_HOME}"/x11-calc/x11-calc.conf ]; then
	mkdir -p "${XDG_CONFIG_HOME}"/x11-calc
	cat <<-EOF >"${XDG_CONFIG_HOME}"/x11-calc/x11-calc.conf
		# Define emulator model to be run:
  		# Model number may be one of the following:
                # 35, 80, 45, 70, 21, 22, 25, 25c, 27, 29c, 
		# 31e, 32e, 33e, 33c, 34c, 37e, 38e, 38c, 67, 
                # 10c, 11c, 12c, 15c, or 16c
		MODEL=25c

		# OPTS may contain options as one-liner string to specify:
		# * preferred non-default save-state file path to be loaded
		# (like sample prg presets from /app/share/x11-calc/prg/)
		# * non-default .rom file path (-r prefix)
		# * other debug options...
		# more info at https://github.com/mike632t/x11-calc
		OPTS=""
		
		# To diagnose errors, run from command-line:
		# flatpak run io.github.mike632t.x11_calc
		# To call this setup again:
		# flatpak run io.github.mike632t.x11_calc --setup
		EOF
fi

case $1 in
	--setup)
		_setup
	;;
	*)
		_launch
	;;
esac

