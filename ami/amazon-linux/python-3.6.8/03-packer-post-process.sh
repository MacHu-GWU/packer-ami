#!/bin/bash

# deregister AMI if the current branch is not master or dev

dir_here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dir_project_root="$( dirname $( dirname  $( dirname ${dir_here} ) ) )"

last_built_ami_id="$(python "${dir_project_root}/bin/get_ami_id.py" "${dir_here}/manifest.json")"
branch_name="$(git branch | grep \* | cut -d ' ' -f2)"

if [ "$branch_name" == "master" -o "$branch_name" == "dev" ]; then
    echo "successfully created ${last_built_ami_id}"
else
    echo "not master or dev branch, deregister AMI ${last_built_ami_id} ..."
    aws ec2 deregister-image --image-id "${last_built_ami_id}"
fi
