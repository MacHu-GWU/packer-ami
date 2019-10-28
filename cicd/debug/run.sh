#!/bin/bash
#
# Run CodeBuild on your local environment.
#
# 1. use the same docker image used in AWS CodeBuild console
# 2. put the equivalent AWS Profile credentials as the CodeBuild IAM service role into env-var.sh.
# 3. DON't rename env-var.sh and check-in this file to git. ``.gitignore`` file will exclude that.

dir_here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dir_project_root="$( dirname "$( dirname  "$( dirname "${dir_here}")")")"

docker_image="$( cat "${dir_project_root}/devops/cicd/docker-image" )"

bash "${dir_here}/codebuild_build.sh" \
    -i "${docker_image}" \
    -s "${dir_project_root}" \
    -e "${dir_here}/env-var.sh" \
    -a "${dir_here}/tmp"
