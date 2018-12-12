# OpenJDK 8 Linux builds
OpenJDK 8 buils for general propose on Travis CI.
This build is done in CentOS 7.5 containers which can be used with command line, for example

```bash
docker run --rm -ti -v $PWD:/mnt/app -e BUILD_USER=$(id -u) \
        -w /mnt/app centos:7.5.1804 /bin/bash /mnt/app/build.sh
```

Then the result file will under the working directory.

```bash
jdk-8u191-b12-linux-x64.zip
jdk-8u191-b12-linux-x64.zip.sha256
```

This script is modified based on the [contrib_jdk8u-ci](https://github.com/ojdkbuild/contrib_jdk8u-ci). If you have any question or suggestion, please don't hesitate to contact me.
