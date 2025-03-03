#!/usr/bin/env bash
# This script installs HPX with MPI parcelport

# MODIFY: Adjust required modules
#module load gcc/13.2.0 
#module load mpi/openmpi/5.0.0-gcc-13.2.0
module load cmake
module load gcc/13.2.0
spack load boost hwloc
spack load openmpi@5.0.3

# structure
export ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )/hpx_1.10_mpi"
export DIR_SRC="$ROOT/src"
export DIR_BUILD="$ROOT/build"
export DIR_INSTALL="$ROOT/install"
# get files
mkdir -p $DIR_SRC
cd $DIR_SRC
export DOWNLOAD_URL="https://github.com/STEllAR-GROUP/hpx"
git clone ${DOWNLOAD_URL} .
git checkout release-1.10.X
# build
mkdir -p $DIR_BUILD
cd $DIR_BUILD
# MODIFY: Adjust CMAKE_CXX_COMPILER
cmake -DCMAKE_CXX_COMPILER=g++ \
      -DCMAKE_INSTALL_PREFIX=$DIR_INSTALL \
      -DHPX_WITH_MALLOC=system \
      -DHPX_WITH_PARCELPORT_TCP=OFF \
      -DHPX_WITH_PARCELPORT_MPI=ON \
      -DHPX_WITH_PARCELPORT_LCI=OFF \
      -DHPX_WITH_NETWORKING=ON \
      -DHPX_WITH_CXX_STANDARD=20 \
      -DHPX_WITH_FETCH_ASIO=ON \
      -DHPX_WITH_EXAMPLES=OFF \
      -DHPX_WITH_TESTS=OFF \
      -DHPX_WITH_MORE_THAN_64_THREADS=ON \
      -DHPX_WITH_MAX_CPU_COUNT=256 ../src
make -j $(grep -c ^processor /proc/cpuinfo)
# install
make install
