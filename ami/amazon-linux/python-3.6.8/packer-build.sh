#!/bin/bash

# This script execute the ``packer build`` command, but allow developer to run it
# easily in either local laptop or in AWS Code Build environment (or any other
# CI/CD system like CircleCI)
#
# It does the following steps:
#
# 1. It removes all comments from packer template. In other word, you can put
#     comments in your packer template for better maintainability.
# 2. Then it uses ``01-provisioner-setup.sh`` script to build the image.
# 3. Then it uses ``02-provisioner-test.sh`` script to validate the image.
# 4. Then it built the AMI image and export the information of the artifacts
#     it been created into ``manifest.json``.
# 5. Finally it use ``03-packer-post-process.sh`` script to post process after
#     the image successfully been created. For example, it decide whether if
#     we want to keep the AMI or grant access to someone.
#
# Note:
#
# for local development, it use ``packer-var-file.json`` to store
# sensitive AWS credential. It use IAM role in Code Build.

set -e

dir_here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dir_project_root="$( dirname $( dirname  $( dirname ${dir_here} ) ) )"

source ${dir_project_root}/bin/source/lib.sh
dir_here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

dir_project_root_on_ec2="/tmp/repo"
dir_here_on_ec2="$(python -c "print('${dir_here}'.replace('${dir_project_root}', '${dir_project_root_on_ec2}', 1))")"
echo $dir_here_on_ec2
ami_name="$(cat "${dir_here}/ami-name")"
version="$(cat "${dir_here}/version")"
path_packer_json="${dir_here}/packer.json"
path_final_packer_json="${dir_here}/packer-final.json"
path_remove_json_comment_script="${dir_project_root}/bin/rm_json_comment.py"

python ${path_remove_json_comment_script} ${path_packer_json} ${path_final_packer_json} -o

echo "---$CODEBUILD_SOURCE_VERSION---"

# if in CodeBuild environment
if [ -n "$CODEBUILD_SOURCE_VERSION" ]; then
    echo "detected code build runtime"
    branch_name="$(git branch -a --contains "${CODEBUILD_SOURCE_VERSION}" | sed -n 2p )"
    branch_name="$(python -c "print('$branch_name'.strip())")"
    var_file_arg=""
# if in CircleCI environment
elif [ -n "$CIRCLECI" ]; then
    echo "detected circleci runtime"
    branch_name="$CIRCLE_BRANCH"
    var_file_arg=""
# if in local laptop
else
    echo "detected local laptop runtime"
    branch_name="$(git branch | grep \* | cut -d ' ' -f2)"
    var_file_arg="-var-file ${dir_here}/packer-var-file.json"
fi

if [ "$branch_name" == "master" ]; then
    stage="prod"
elif [ "$branch_name" == "dev" ]; then
    stage="$branch_name"
elif [ "$branch_name" == "test" ]; then
    stage="$branch_name"
else
    stage="temp"
fi


print_colored_line $color_green "INFO: Working on ---${branch_name}--- branch."
print_colored_line $color_green "INFO: Working on ---${stage}--- stage."

packer validate \
    -var ami_name="${ami_name}" \
    -var version="${version}" \
    -var stage="${stage}" \
    -var path_local_project_root="${dir_project_root}" \
    -var path_local_ami_dir="${dir_here}" \
    -var path_remote_project_root="${dir_project_root}" \
    -var path_remote_ami_dir="${dir_here}" \
    ${path_final_packer_json}

print_colored_line $color_green "INFO: Template validated successfully."

packer build \
    -var ami_name="${ami_name}" \
    -var version="${version}" \
    -var stage="${stage}" \
    -var path_local_project_root="${dir_project_root}" \
    -var path_local_ami_dir="${dir_here}" \
    -var path_remote_project_root="${dir_project_root_on_ec2}" \
    -var path_remote_ami_dir="${dir_here_on_ec2}" \
    ${var_file_arg} \
    ${path_final_packer_json}
