#!/usr/bin/env bash
# This script installs FFTW3 from the recommended tarball with MPI+OpenMP backend
#
# The folling paths have to be exported:
# $MPI_DIR: path to MPI installation (or load MPI module)

module load gcc/13.2.1
# add MPI to path or load MPI module
module load openmpi/5.0.3
#export PATH="$MPI_DIR/bin":$PATH
# structure
export ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )/fftw_omp_mpi"
export DIR_SRC="$ROOT/src"
export DIR_BUILD="$ROOT/build"
export DIR_INSTALL="$ROOT/install"
# get files
mkdir -p $DIR_SRC
cd $DIR_SRC
export DOWNLOAD_URL="http://www.fftw.org/fftw-3.3.10.tar.gz"
wget -O- ${DOWNLOAD_URL} | tar xz --strip-components=1
# build
mkdir -p $DIR_BUILD
cd $DIR_BUILD
$DIR_SRC/configure --prefix=$DIR_INSTALL --enable-mpi --enable-openmp
make -j $(grep -c ^processor /proc/cpuinfo)
# install
make install
