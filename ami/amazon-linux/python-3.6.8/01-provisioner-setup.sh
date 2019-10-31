#!/bin/bash

dir_here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dir_project_root="$( dirname $( dirname $( dirname $dir_here)) )"

source ${dir_project_root}/bin/source/lib.sh

try_yum_install_this "git"
try_yum_install_this "curl"
try_yum_install_this "wget"
try_yum_install_this "jq"


install_pyenv() {
    # install pyenv
    if this_command_exists "pyenv"; then
        print_colored_line $color_cyan "pyenv is already installed."
    else
        print_colored_line $color_cyan "pyenv is NOT installed! start install pyenv ..."
        curl -s https://pyenv.run | bash

        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$HOME/.pyenv/bin:$PATH"
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"

        add_line_to 'export PYENV_ROOT="$HOME/.pyenv"' ~/.bashrc
        add_line_to 'export PATH="$PYENV_ROOT/bin:$PATH"' ~/.bashrc
        add_line_to 'eval "$(pyenv init -)"' ~/.bashrc
        add_line_to 'eval "$(pyenv virtualenv-init -)"' ~/.bashrc

        add_line_to 'export PYENV_ROOT="$HOME/.pyenv"' ~/.bash_profile
        add_line_to 'export PATH="$PYENV_ROOT/bin:$PATH"' ~/.bash_profile
        add_line_to 'eval "$(pyenv init -)"' ~/.bash_profile
        add_line_to 'eval "$(pyenv virtualenv-init -)"' ~/.bash_profile
    fi
    # install c compile so we can install Python from source
    yum -y install gcc
    yum -y install @development zlib-devel bzip2 bzip2-devel tar \
        readline-devel sqlite sqlite-devel openssl-devel xz xz-devel libffi-devel \
        findutils

    print_colored_line $color_green 'Successfully installed pyenv, enter "$ bash" to reload your shell...'
    print_colored_line $color_green 'type pyenv to test if it is successfully installed'
}

install_pyenv

pyenv install 3.6.8 -s
pyenv global 3.6.8

# install aws cli
pip install pip --upgrade
pip install virtualenv --upgrade

#cat /tmp/repo/bin/awscli-mfa-auth.sh
#cp /tmp/repo/bin/awscli-mfa-auth.sh ~/awscli-mfa-auth.sh
