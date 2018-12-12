#!/bin/bash
OJDK_MILESTONE=ojdkbuild
OJDK_WITH_DEBUG_LEVEL=release
OJDK_ENABLE_DEBUG_SYMBOLS=no
OJDK_SUFFIX=daopin
OJDK_UPDATE=191
OJDK_BUILD=b12
OJDK_IMAGE=jdk-8u${OJDK_UPDATE}-${OJDK_BUILD}-linux-x64
base=openJDK8u/build/linux-x86_64-normal-server-release

yum groupinstall -y 'Development Tools'
yum install -y java-1.7.0-openjdk-devel.x86_64 mercurial which libXtst-devel libXt-devel libXrender-devel cups-devel freetype-devel alsa-lib-devel elfutils libstdc++-static file

cd
rsync -avP /mnt/app/*.sh .
hg clone http://hg.openjdk.java.net/jdk8u/jdk8u/ -r jdk8u${OJDK_UPDATE}-${OJDK_BUILD} openJDK8u
cd openJDK8u
bash ./get_source.sh
sed -i "s/SUPPORTED_OS_VERSION =.*/SUPPORTED_OS_VERSION = 2.4% 2.5% 2.6% 3% 4%/g" hotspot/make/linux/Makefile
bash ./configure --with-stdc++lib=static --with-boot-jdk=/usr/lib/jvm/java-openjdk \
        --with-num-cores=4 --with-target-bits=64 --with-milestone=${OJDK_MILESTONE} \
        --with-build-number=${OJDK_BUILD} --with-update-version=${OJDK_UPDATE} \
        --enable-debug-symbols=${OJDK_ENABLE_DEBUG_SYMBOLS} --with-debug-level=${OJDK_WITH_DEBUG_LEVEL} \
        --with-user-release-suffix=${OJDK_SUFFIX}
make images LOG=info
cd ..

mkdir ${OJDK_IMAGE}
rsync -avP ${base}/images/j2sdk-image/* ${OJDK_IMAGE}/.
rm -rf ./${OJDK_IMAGE}/demo
rm -rf ./${OJDK_IMAGE}/sample
#cp -a /usr/share/fonts/dejavu/ ./${OJDK_IMAGE}/jre/lib/fonts
zip -qyr9 ${OJDK_IMAGE}.zip ${OJDK_IMAGE}
sha256sum ${OJDK_IMAGE}.zip > ${OJDK_IMAGE}.zip.sha256

chown $BUILD_USER:$BUILD_USER ${OJDK_IMAGE}.zip
chown $BUILD_USER:$BUILD_USER ${OJDK_IMAGE}.zip.sha256
rsync -avP ${OJDK_IMAGE}.zip ${OJDK_IMAGE}.zip.sha256 /mnt/app/.
