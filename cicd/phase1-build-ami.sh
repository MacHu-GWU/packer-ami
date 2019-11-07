#!/bin/bash

dir_here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dir_project_root="$( dirname ${dir_here} )"

bash "${dir_project_root}/ami/amazon-linux/python-3.6.8/packer-build.sh"

echo "--- ENV VAR test---"
echo ${CODEBUILD_BUILD_ID}
echo ${CODEBUILD_SOURCE_REPO_URL}
echo ${CODEBUILD_SOURCE_VERSION}
echo ${CODEBUILD_RESOLVED_SOURCE_VERSION}
