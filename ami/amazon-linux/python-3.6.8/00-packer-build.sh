#!/bin/bash

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
