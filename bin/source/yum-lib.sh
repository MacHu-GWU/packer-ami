#!/bin/bash

dir_here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${dir_here}/unix-lib.sh


is_yum_installed() {
    if yum list installed "$@" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

try_yum_install_this() {
    if this_command_exists "$1"; then
        print_colored_line $color_green "$1 is already installed."
    else
        print_colored_line $color_red "$1 is NOT installed!"
        print_colored_line $color_cyan "start install $1 ..."
        yum install -y "$1"
        display_command_install_status "$1"
    fi
}
