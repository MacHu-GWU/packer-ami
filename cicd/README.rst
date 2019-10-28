CICD Pipeline Manual
==============================================================================

.. contents::
    :depth: 1
    :local:

I use AWS Code Build for CI/CD.


FAQ
------------------------------------------------------------------------------

- Q: how's the code build been triggered?
- A: every time you do ``git push`` to any branch.

- Q: where is the code build running?
- A: when the GitHub webook triggers an event, AWS Code Build will pull a docker image, and run the code build in the container.

- Q: what's been done in the code build?
- A: first it check out code from github. then it detects the ``buildspec.yml`` file and run the command in sequence.


CICD Process
------------------------------------------------------------------------------

.. contents::
    :local:


1. trigger a packer build command to build AMI image
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See ``cicd/phase1-install.sh``.



Docker image for AWS Code Builder
------------------------------------------------------------------------------

We use docker image with following software preinstalled:

- awscli=latest
- python=3.6.8
- pip
- virtualenv
- packer=1.4.4
- git
- jq
- wget
- curl
- zip
- unzip
- docker

Docker hub repo:

- docker image: ``sanhe/cicd:awscli-python3.6.8-packer-slim``
- docker hub: https://hub.docker.com/r/sanhe/cicd/tags?page=1&name=awscli-python3.6.8-packer-slim
- Dockerfile: https://github.com/MacHu-GWU/docker-cicd/blob/master/awscli-python3.6.8-packer-slim/Dockerfile
