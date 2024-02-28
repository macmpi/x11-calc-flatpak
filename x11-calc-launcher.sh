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

ENOENT=2
EBFONT=59
ENODATA=61

: "${XDG_CONFIG_HOME:="$HOME/.config"}"
: "${XDG_DATA_HOME:="$HOME/.local/share"}"

MODEL=""
DEFAULT_MODEL=25c
OPTS=""
CMD_OPTS=""


_launch() {
local fonts err

[ -z "$MODEL" ] && exit 1

case $MODEL in
	10c|11c|12c|15c|16c)
		# if OPTS does not point to a rom file, set expected option to default location
		# no need to check file existence: app will error-out with proper message if missing
		[ -n "${OPTS##*.rom*}" ] || [ -z "${OPTS}" ] && OPTS="-r ${XDG_DATA_HOME}/x11-calc/${MODEL}.rom"
	;;
esac
# eventual command-line options take precedence
[ -n "$CMD_OPTS" ] && OPTS="$CMD_OPTS"

# shellcheck disable=SC2086  # intended for parameter passsing
"$(dirname "${0}")"/x11-calc-${MODEL} ${OPTS}
err=$?
case $err in
	$EBFONT)
		fonts="<i>xfonts-base</i> or equivalent for this distribution."
		grep -qE "ubuntu|debian" /run/host/os-release && fonts="<i>xfonts-base</i>"
		grep -qE "fedora" /run/host/os-release && fonts="<i>xorg-x11-fonts-base</i> or <i>xorg-x11-fonts-misc</i>"
		grep -qE "gentoo" /run/host/os-release && fonts="<i>font-misc-misc</i>"
		zenity --height=100 --width=300 --info --text="Please install the following font package:\n${fonts}"
		;;
	$ENOENT)
		zenity --height=100 --width=450 --info --text="Missing .rom file !\nCorrect OPTS path, or copy file in defined location:\n${OPTS}"
		;;
	$ENODATA)
		zenity --height=100 --width=200 --info --text="Empty .rom file !"
		;;
esac
}

_gui_conf (){
local model opts
local models="35 80 45 70 21 22 25 25c 27 29c \
	31e 32e 33e 33c 34c 37e 38e 38c 67 \
	10c 11c 12c 15c 16c"

# shellcheck disable=SC2086  # intended for listing models in dialog
model=$(zenity --list --title="Calculator selection" \
	--text="Choose preferred calculator model:" --column="HP model" $models \
	--ok-label="OK" --height=300 --width=225 2>/dev/null)

opts=$(zenity --entry --title="Expert settings: optional arguments" \
	--text="OPTS line:" --entry-text="$OPTS" \
	--ok-label="Set" --height=100 --width=300 2>/dev/null)

[ -z "$model" ] && model=$DEFAULT_MODEL
sed -i 's/^MODEL=.*/MODEL='"$model"'/' "${XDG_CONFIG_HOME}"/x11-calc/x11-calc.conf
sed -i 's/^OPTS=.*/OPTS=\"'"$opts"'\"/' "${XDG_CONFIG_HOME}"/x11-calc/x11-calc.conf
}

_setup() {
if command -v zenity >/dev/null 2>&1; then
	_gui_conf
else
	nano "${XDG_CONFIG_HOME}"/x11-calc/x11-calc.conf
fi
# reload modified settings to prep upcoming launch
# shellcheck disable=SC1090  # intended include
. "${XDG_CONFIG_HOME}"/x11-calc/x11-calc.conf
CMD_OPTS=""
}

## Main

if ! [ -f "${XDG_CONFIG_HOME}"/x11-calc/x11-calc.conf ]; then
	mkdir -p "${XDG_CONFIG_HOME}"/x11-calc
	cat <<-EOF >"${XDG_CONFIG_HOME}"/x11-calc/x11-calc.conf
		# Select which emulator to run by setting the MODEL to one
		# of the following:
		# 35, 80, 45, 70, 21, 22, 25, 25c, 27, 29c,
		# 31e, 32e, 33e, 33c, 34c, 37e, 38e, 38c, 67,
		# 10c, 11c, 12c, 15c, or 16c
		MODEL=$DEFAULT_MODEL

		# OPTS may contain options as one-liner string to specify:
		# # preferred non-default save-state file path to be loaded
		#  (like sample prg presets from /app/share/x11-calc/prg/)
		# # non-default .rom file path (-r prefix)
		# # other debug options...
		# For more complete list of options, run from command-line
		# with --help option
		# To test OPTS line and diagnose errors, run from command-line
		# with OPTS line
		OPTS=""

		# To call this setup again, run from command-line
		# with --setup option
		EOF
fi
# shellcheck disable=SC1090  # intended include
. "${XDG_CONFIG_HOME}"/x11-calc/x11-calc.conf
CMD_OPTS="$*"

[ "$CMD_OPTS" = "--setup" ] && _setup
_launch

