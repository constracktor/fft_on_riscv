#!/usr/bin/env bash

set -ex

: ${SOURCE_ROOT:?} ${INSTALL_ROOT:?} ${GCC_VERSION:?} ${JEMALLOC_VERSION:?}

DIR_SRC=${SOURCE_ROOT}/jemalloc
#DIR_BUILD=${INSTALL_ROOT}/jemalloc/build
DIR_INSTALL=${INSTALL_ROOT}/jemalloc
FILE_MODULE=${INSTALL_ROOT}/modules/jemalloc/${JEMALLOC_VERSION}

#DOWNLOAD_URL="https://github.com/jemalloc/jemalloc/releases/download/${JEMALLOC_VERSION}/jemalloc-${JEMALLOC_VERSION}.tar.bz2"
DOWNLOAD_URL="https://github.com/jemalloc/jemalloc"
if [[ ! -d ${DIR_INSTALL} ]]; then
    (
        mkdir -p ${DIR_SRC}
        cd ${DIR_SRC}
        #wget -O- ${DOWNLOAD_URL} | tar xj --strip-components=1
        cd ..
        git clone ${DOWNLOAD_URL}
	cd jemalloc
	git checkout ${JEMALLOC_VERSION}
        ./autogen.sh
        ./configure --prefix=${DIR_INSTALL}
        make -j${PARALLEL_BUILD}
        make install
    )
fi
