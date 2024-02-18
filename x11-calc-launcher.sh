#!/bin/sh

# Simple launcher program to set default emulator model and
# eventual run options.
# Copyright(C) 2024 macmpi
#
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation, either version 3 of the License, or (at your
# option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
# Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.


MODEL=""
OPTS=""
CMD_OPTS=""

_launch() {
# shellcheck disable=SC1090  # intended include
. "${XDG_CONFIG_HOME}"/x11-calc/x11-calc.conf
[ -z "$MODEL" ] && exit 1
[ -n "$CMD_OPTS" ] && OPTS="$CMD_OPTS"

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

CMD_OPTS="$@"
if ! [ -f "${XDG_CONFIG_HOME}"/x11-calc/x11-calc.conf ]; then
	mkdir -p "${XDG_CONFIG_HOME}"/x11-calc
	cat <<-EOF >"${XDG_CONFIG_HOME}"/x11-calc/x11-calc.conf
		# define emulator model to be run:
		MODEL=35

		# OPTS may contain options as one-liner string to specify:
		# # preferred non-default save-state file path to be loaded
		#  (like sample prg presets from /app/share/x11-calc/prg/)
		# # non-default .rom file path (-r prefix)
		# # other debug options...
		# For more list of options, run from command-line:
		# flatpak run io.github.mike632t.x11_calc --help
		# To test OPTS line and diagnose errors, run from command-line:
		# flatpak run io.github.mike632t.x11_calc OPTS
		OPTS=""
		
		# To call this setup again:
		# flatpak run io.github.mike632t.x11_calc --setup
		EOF
fi

case $CMD_OPTS in
	--setup)
		_setup
	;;
	*)
		_launch
	;;
esac

