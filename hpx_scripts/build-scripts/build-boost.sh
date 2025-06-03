#!/usr/bin/env bash

set -ex

: ${SOURCE_ROOT:?} ${INSTALL_ROOT:?} ${GCC_VERSION:?} ${CXX:?} \
    ${BOOST_VERSION:?} ${BOOST_BUILD_TYPE:?} ${POWERTIGER_ROOT:?}

if [[ -d "/etc/opt/cray/release/" ]]; then 
	flag1="cxxflags=$CXXFLAGS"
        flag2="threading=multi link=shared"
else
	flag1=""
	flag2=""
fi

DIR_SRC=${SOURCE_ROOT}/boost
#DIR_BUILD=${INSTALL_ROOT}/boost/build
DIR_INSTALL=${INSTALL_ROOT}/boost
FILE_MODULE=${INSTALL_ROOT}/modules/boost/${BOOST_VERSION}-${BOOST_BUILD_TYPE}

if [[ ! -d ${DIR_SRC} ]]; then
    (
	# Get super repository variant 2 (get only the correct commit)
	cd ${SOURCE_ROOT}
	git clone --depth 1 --branch boost-${BOOST_VERSION} https://github.com/boostorg/boost boost

	cd boost
	# Just checkout everything
	git submodule update --init --recursive --depth=1 -j 8

        echo "using gcc : : $CXX ; " >tools/build/src/user-config.jam
    )
fi

(
    cd ${DIR_SRC}
    if [[ "${OCT_WITH_CLANG}" == "ON" ]]; then
        ./bootstrap.sh --prefix=${DIR_INSTALL} --with-toolset=clang
    else
        ./bootstrap.sh --prefix=${DIR_INSTALL} --with-toolset=gcc
    fi
    ./b2 -j${PARALLEL_BUILD} "${flag1}" ${flag2} --with-context --with-log --with-atomic --with-filesystem --with-program_options --with-regex --with-system --with-chrono --with-date_time --with-thread --with-iostreams ${BOOST_BUILD_TYPE} install
)
