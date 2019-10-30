#!/bin/bash

is_yum_installed() {
    if yum list installed "$@" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

if is_yum_installed "git"; then
    echo "installed"
else
    echo "not installed"
fi