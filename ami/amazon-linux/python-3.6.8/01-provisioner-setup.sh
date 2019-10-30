#!/bin/bash

dir_here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dir_project_root="$( dirname $( dirname $( dirname $dir_here)) )"

cat /tmp/repo/bin/awscli-mfa-auth.sh
cp /tmp/repo/bin/awscli-mfa-auth.sh ~/awscli-mfa-auth.sh
