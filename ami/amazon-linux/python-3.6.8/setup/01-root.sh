#!/bin/bash

dir_here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dir_project_root="$( dirname $( dirname $( dirname $( dirname $dir_here) ) ) )"

source ${dir_project_root}/bin/source/lib.sh

try_yum_install_this "git"
try_yum_install_this "curl"
try_yum_install_this "wget"
try_yum_install_this "jq"

# for pyenv to install python
yum -y install gcc
yum -y install @development zlib-devel bzip2 bzip2-devel tar \
    readline-devel sqlite sqlite-devel openssl-devel xz xz-devel libffi-devel \
    findutils
