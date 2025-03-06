#!/bin/bash
################################################################################
# Preprocessing
################################################################################
# working directory
export ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )"
# export paths
export BUILD_DIR=build
# MPI compiler
export CXX="mpic++"
# FFTW paths
export FFTW_OMP_DIR="$ROOT/fftw_scripts/$1/fftw_omp_mpi$FFTW_RISCV/install/lib"
export PKG_CONFIG_PATH="$FFTW_OMP_DIR/pkgconfig":$PKG_CONFIG_PATH

################################################################################
# Compilation
################################################################################
rm -rf $BUILD_DIR && mkdir $BUILD_DIR && cd $BUILD_DIR
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j $(grep -c ^processor /proc/cpuinfo)
