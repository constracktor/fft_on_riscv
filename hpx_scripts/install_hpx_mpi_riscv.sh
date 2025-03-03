#!/usr/bin/env bash
# This script installs HPX with MPI parcelport

# MODIFY: Adjust required modules
module load gcc/13.2.1
module load hwloc/2.10.0
module load openmpi/5.0.3

PARALLEL_BUILD=$(grep -c ^processor /proc/cpuinfo)
# structure
export ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )/hpx_1.9_riscv"
export DIR_SRC="$ROOT/src"
export DIR_BUILD="$ROOT/build"
export DIR_INSTALL="$ROOT/install"

#install Boost dependency
BOOST_DOWNLOAD_URL="https://github.com/boostorg/boost/releases/download/boost-1.83.0/boost-1.83.0.tar.gz"
# Get from sourceforge
mkdir -p ${DIR_SRC}/_deps/boost
cd ${DIR_SRC}/_deps/boost
# When using the sourceforge link
wget -O- ${BOOST_DOWNLOAD_URL} | tar -xvz --strip-components=1
./bootstrap.sh --prefix=${DIR_INSTALL} --with-toolset=gcc
./b2 -j${PARALLEL_BUILD} --with-atomic --with-filesystem --with-program_options --with-regex --with-system --with-chrono --with-date_time --with-thread --with-iostreams release install
#install HPX
# get files
mkdir -p $DIR_SRC/hpx
cd $DIR_SRC/hpx
export DOWNLOAD_URL="https://github.com/STEllAR-GROUP/hpx"
git clone ${DOWNLOAD_URL} .
git checkout release-1.9.X
# build
mkdir -p $DIR_BUILD
cd $DIR_BUILD
# MODIFY: Adjust CMAKE_CXX_COMPILER
cmake -DCMAKE_CXX_COMPILER=g++ \
      -DCMAKE_INSTALL_PREFIX=$DIR_INSTALL \
      -DHPX_WITH_MALLOC=system \
      -DBOOST_ROOT=$DIR_INSTALL \
      -DHPX_INGNORE_BOOST_COMPATIBILITY=ON \
      -DHPX_WITH_PARCELPORT_TCP=OFF \
      -DHPX_WITH_PARCELPORT_MPI=ON \
      -DHPX_WITH_PARCELPORT_LCI=OFF \
      -DHPX_WITH_NETWORKING=ON \
      -DHPX_WITH_CXX_STANDARD=20 \
      -DHPX_WITH_FETCH_ASIO=ON \
      -DHPX_WITH_EXAMPLES=OFF \
      -DHPX_WITH_TESTS=OFF \
      -DHPX_WITH_MORE_THAN_64_THREADS=OFF ../src/hpx
make -j ${PARALLEL_BUILD}
# install
make install
