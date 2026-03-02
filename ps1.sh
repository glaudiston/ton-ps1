#!/bin/bash
#
# My bash PS1
#
# assets 𝘟 ✗ ✔ ✓ ▲ ➜ ⚠ ♚ ♙
# Git status
# Ref: https://misc.flogisoft.com/bash/tip_colors_and_formatting
#

# BUG: when prompt use more than 1 line, the backspace/retype genereates buggy rendering
# BUG: when try to use "$_" to get the last argument, it returns timer_start

# bash powerline
# 00000000: 5c5b 1b5b 303b 3338 3b35 3b32 3331 3b34  \[.[0;38;5;231;4
# 00000010: 383b 353b 3331 3b31 6d5c 5dc2 a067 6c61  8;5;31;1m\]..gla
# 00000020: 7564 6973 746f 6ec2 a05c 5b1b 5b30 3b33  udiston..\[.[0;3
# 00000030: 383b 353b 3331 3b34 383b 353b 3234 303b  8;5;31;48;5;240;
# 00000040: 3232 6d5c 5dee 82b0 c2a0 5c5b 1b5b 303b  22m\].....\[.[0;
# 00000050: 3338 3b35 3b32 3530 3b34 383b 353b 3234  38;5;250;48;5;24
# 00000060: 306d 5c5d 7ec2 a05c 5b1b 5b30 3b33 383b  0m\]~..\[.[0;38;
# 00000070: 353b 3234 353b 3438 3b35 3b32 3430 3b32  5;245;48;5;240;2
# 00000080: 326d 5c5d ee82 b1c2 a05c 5b1b 5b30 3b33  2m\].....\[.[0;3
# 00000090: 383b 353b 3235 303b 3438 3b35 3b32 3430  8;5;250;48;5;240
# 000000a0: 6d5c 5d73 7263 c2a0 5c5b 1b5b 303b 3338  m\]src..\[.[0;38
# 000000b0: 3b35 3b32 3435 3b34 383b 353b 3234 303b  ;5;245;48;5;240;
# 000000c0: 3232 6d5c 5dee 82b1 c2a0 5c5b 1b5b 303b  22m\].....\[.[0;
# 000000d0: 3338 3b35 3b32 3532 3b34 383b 353b 3234  38;5;252;48;5;24
# 000000e0: 303b 316d 5c5d 746f 6e2d 7073 31c2 a05c  0;1m\]ton-ps1..\
# 000000f0: 5b1b 5b30 3b33 383b 353b 3234 303b 3439  [.[0;38;5;240;49
# 00000100: 3b32 326d 5c5d ee82 b0c2 a05c 5b1b 5b30  ;22m\].....\[.[0
# 00000110: 6d5c 5d5c 5b1b 5b73 1b5b 3238 3443 1b5b  m\]\[.[s.[284C.[
# 00000120: 3131 441b 5b30 3b33 383b 353b 3233 363b  11D.[0;38;5;236;
# 00000130: 3439 3b32 326d c2a0 ee82 b21b 5b30 3b33  49;22m......[0;3
# 00000140: 383b 353b 3235 303b 3438 3b35 3b32 3336  8;5;250;48;5;236
# 00000150: 6dc2 a0ee 82a0 c2a0 6d61 7374 6572 c2a0  m.......master..
# 00000160: 1b5b 306d 1b5b 755c 5d0a                 .[0m.[u\].

yellow="$bold$(tput setaf 3)"
red="$bold$(tput setaf 1)"
green=$(tput setaf 2)
PS_LOGO=$(cat /home/ggs/Pictures/synchro-icon.sixel)
UP1L=$(tput cuu1)
UP2L=$(echo -en "$UP1L$UP1L")
DOWN1L=$(tput cud1)
Reset='\[\e[00m\]'
Blue='\[\e[01;34m\]'
White='\[\e[01;37m\]'
Red='\[\e[01;31m\]'
Green='\[\e[01;32m\]'
FancyX='\342\234\227'
Checkmark='\342\234\223'
Gray='\[\033[01;38;5;235m\]'
Turkey='\[\e[02;38;5;36m\]'
Blink="\e[5m";
ResetBlink="\e[25m"
ResetDim="\e[22m"

check_status() {
	BG_Gray='\033[01;48;5;233m'
	boshka= git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' > /dev/null 2>&1

	# Checks if something to commit or not
	if git rev-parse --git-dir > /dev/null 2>&1; then
	    if ! git status | grep "nothing to commit" > /dev/null 2>&1; then
	      echo -n "${yellow}⚠"
	      return 0
	    elif $boshka; then
		echo -n "${green}✓"
	    fi
	fi
}

# Git branch

check_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

function timer_now {
    date +%s%N
}

function timer_start {
	echo -en "\e[00m"
	timer_start=${timer_start:-$(timer_now)}
}

function timer_stop {
    local delta_us=$((($(timer_now) - $timer_start) / 1000))
    local us=$((delta_us % 1000))
    local ms=$(((delta_us / 1000) % 1000))
    local s=$(((delta_us / 1000000) % 60))
    local m=$(((delta_us / 60000000) % 60))
    local h=$((delta_us / 3600000000))
    # Goal: always show around 3 digits of accuracy
    if ((h > 0)); then timer_show=${h}h${m}m
    elif ((m > 0)); then timer_show=${m}m${s}s
    elif ((s >= 10)); then timer_show=${s}.$((ms / 100))s
    elif ((s > 0)); then timer_show=${s}.$(printf %03d $ms)s
    elif ((ms >= 100)); then timer_show=${ms}ms
    elif ((ms > 0)); then timer_show=${ms}.$((us / 100))ms
    else timer_show=${us}us
    fi
    unset timer_start
}

getCPos () {
    local v=() t=$(stty -g)
    stty -echo
	if [ "$TERM" != "screen" ]; then
	{
	    tput u7
	    IFS='[;' read -rd R -a v
	}
	else
	{
	    echo -en "\033[6n" > /dev/tty
	    IFS='[;' read -rd R -a v
	}
	fi
    stty $t
    CPos=(${v[@]:1})
}

EOL(){
	if [ "$TERM" != "screen" ]; then
		tput sc;
		tput cup $currow $(( $(tput cols) -3 ));
		tput cub 2;
		tput cuu1;
		echo -n "$PS_LOGO";
		tput rc;
		echo -ne "$rcurrow";
	fi;
}

set_prompt() {
    Last_Command=$? # Must come first!
    # in xterm avoid cursor misposition in last 3 lines
    if [ "$TERM" != "screen" ]; then
	    getCPos;
	    currow="${CPos[0]}";
	    rcurrow=""
	#    if [ "$currow" -ge "$(( $(tput lines) -1 ))" ]; then
	#	rcurrow="$UP1L";
	#    fi;
    fi;

    # Add a bright white exit status for the last command
    nPS1="\e[48;5;233m$(printf "% $(tput cols)s\r" " ")$Gray\t "
    # If it was successful, print a green check mark. Otherwise, print
    # a red X.
    if [[ $Last_Command == 0 ]]; then
        nPS1+="$Green$Checkmark "
    else
        nPS1+="$Red$FancyX=$Last_Command "
    fi

    # Add the ellapsed time and current date
    timer_stop
    nPS1+="$Gray($timer_show)$(echo -en "\t")"

    # If root, just print the host in red. Otherwise, print the current user
    # and host in green.
    if [[ $EUID == 0 ]]; then
        nPS1+="$Red\\u$Green@\\h"
	L="♚$red"
	P="\n# "
    else
        nPS1+="$Blue\\u$Gray@$Green\\h"
	L="♙$White${ResetDim}"
	P="\n$ "
    fi
    # Print the working directory and prompt marker in blue, and reset
    # the text color to the default.
    nPS1+="$Gray:$Blue\\w"

	# PS1 is similar to html tags but with color the tag starts like:
	# \[\e[0;32m] bla bla \[\e[0m\] 0;32 is color green, space is \[$(tput sgr0)\], \W current dir
	PS1="\[$BG_Gray$nPS1$Green $Turkey$BG_Gray$(check_status;check_branch)$BG_Gray$BG_Gray$L\$(EOL)\]$P"
}

# timer_start replaces the $_ variable, so echo is a hack to bypass this issue
trap '__="${_}";timer_start;echo "${__}" >/dev/null' DEBUG
PROMPT_COMMAND='set_prompt'

# hack to avoid color bug on xterm
read -a REPLY -s -t 0.25 -d "S" -p $'\e[?1;3;256S' >&2;

export CLICOLOR=1
export LSCOLORS=fxfxBxDxgxegedabagacad
