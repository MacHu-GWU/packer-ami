Run Codebuild Locally before you do ``git push``
==============================================================================

1. Create a ``env-var.sh`` file under this folder. Because your local code build environment doesn't have IAM role assigned. So you have to manually assign environment variable to grant the container correct AWS API Permission. Example ``env-var.sh`` file:

.. code-block:: bash

    #!/bin/bash

    CODEBUILD_BUILD_ID=JUST_A_DUMMY_VALUE_TO_MOCK_CODEBUILD_RUNTIME
    AWS_ACCESS_KEY_ID=AAAAAAAAAAAAAAAAAAAA
    AWS_SECRET_ACCESS_KEY=BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
    AWS_DEFAULT_REGION=us-east-1
    AWS_DEFAULT_OUTPUT=json

2. Run this command in your terminal before you do ``git push``. It simulates the codebuild run.

.. code-block:: bash

    $ bash path/to/aws-ls/devops/cicd/debug/run.sh


Reference
------------------------------------------------------------------------------

- AWS CLI Environment Variables: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
- Announcing Local Build Support for AWS CodeBuild: https://aws.amazon.com/blogs/devops/announcing-local-build-support-for-aws-codebuild/
- ``codebuild_build.sh`` README: https://github.com/aws/aws-codebuild-docker-images/tree/master/local_builds
- Test and Debug Locally with the CodeBuild Agent: https://docs.aws.amazon.com/codebuild/latest/userguide/use-codebuild-agent.html
