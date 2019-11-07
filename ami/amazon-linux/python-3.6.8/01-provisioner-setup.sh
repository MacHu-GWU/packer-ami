#!/bin/bash

# This script supposed to be run on REMOTE vm

dir_here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dir_project_root="$( dirname $( dirname $( dirname $dir_here)) )"

source ${dir_project_root}/bin/source/lib.sh

dir_here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#sudo bash ${dir_here}/setup/01-yum-install.sh
#bash ${dir_here}/setup/02-user.sh

rm -r /tmp/repo
