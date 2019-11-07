使用 packer 和 CI/CD 持续集成自动化大量的 AWS AMI 管理
==============================================================================

此 repo 实现了一个批量管理 AWS AMI 的构建的框架, 能够大量编排, 以及自动化虚拟机的构建. **下面是自动化构建流程**:

1. 将代码 Push 到 Git, 触发 CI/CD pipeline.
2. CI/CD 启动一个容器, 并将整个代码 pull 到容器内. 该容器预先安装了 Python, AWS CLI, packer, git.
3. 在 CI/CD 容器内执行在 ``buildspec.yml`` 中定义的 shell scripts. 其中包括了 执行 ``./ami`` 目录下的各个子目录中的 ``packer-build.sh`` 脚本的命令. ``./ami`` 目录下每一个子目录都代表着一个 AMI.
4. 运行各个 ``packer-build.sh`` 脚本, 运行 ``packer build`` 命令.
5. ``packer build`` 会自动启动一个 EC2, 然后移除 ``packer.json`` 中的注释, 最后执行 ``packer-final.json``.
6. ``packer.json`` 中的逻辑框架是这样的, 首先将关键的 ``./bin`` 和 ``./ami`` 目录拷贝到 EC2 上的 ``/tmp/repo/bin`` 和 ``/tmp/repo/ami``. 相当于把代码仓库从 CI/CD 的环境中拷贝了一份到 EC2 上.
7. 然后会依次执行一系列安装脚本. 如果有些命令需要修改 ``~/.bashrc`` 和 ``~/.bash_profile`` 文件, 那么就无法仅使用一个 shell provisioner 命令, 而是要使用多个, 每个 shell provisioner 都是新的 shell 进程.
8. 完成安装之后, 会执行一个叫做 ``xx-provisioner-test.sh`` 的脚本, 验证是否安装成功. 如果检查到没有安装成功, 则会返回非 0 的 exit code. 那么 packer 就会认为构建失败.
9. 在测试通过后, 会执行一个叫做 ``xx-provisioner-clean-up.sh`` 的脚本, 移除临时的 artifacts, 例如我们上传的 代码.
10. 完成了所有需要 EC2 的工作后, packer 会 stop EC2, 然后创建一个 AMI, 期间会自动加上合适的 Tag.
11. AMI 创建成功后, 一般还需要等待一段时间才能使用, 但是 packer 已经可以立即返回 metadata, 并将构建的 ami 信息写入 ``manifest.json`` 文件中.
12. 最后在容器中执行 ``xx-post-process.sh`` 脚本, 进行一些处理. 比如根据当前的 git branch 以及 stage 决定是否要保留 AMI Image.
