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

ami_name="$(cat "${dir_here}/ami-name")"
version="$(cat "${dir_here}/version")"
path_packer_json="${dir_here}/packer.json"
path_final_packer_json="${dir_here}/packer-final.json"
path_remove_json_comment_script="${dir_project_root}/bin/rm_json_comment.py"

python ${path_remove_json_comment_script} ${path_packer_json} ${path_final_packer_json} -o

packer validate \
    -var path_to_provisioner_setup_script="${dir_here}/01-provisioner-setup.sh" \
    -var path_to_provisioner_test_script="${dir_here}/02-provisioner-test.sh" \
    -var path_to_post_process_script="${dir_here}/03-packer-post-process.sh" \
    ${path_final_packer_json}

print_colored_line $color_green "INFO: Template validated successfully."


# is in code build runtime
if [ -n "$CODEBUILD_BUILD_ID" ]; then
    var_file_arg=""
else
    var_file_arg="-var-file ${dir_here}/packer-var-file.json"
fi

packer build \
    -var ami_name="${ami_name}" \
    -var version="${version}" \
    -var path_to_provisioner_setup_script="${dir_here}/01-provisioner-setup.sh" \
    -var path_to_provisioner_test_script="${dir_here}/02-provisioner-test.sh" \
    -var path_to_manifest_file="${dir_here}/manifest.json" \
    -var path_to_post_process_script="${dir_here}/03-packer-post-process.sh" \
    ${var_file_arg} \
    ${path_final_packer_json}
