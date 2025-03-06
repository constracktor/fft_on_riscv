#!/bin/bash
################################################################################
# Preprocessing
################################################################################
# working directory
export ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )"
# export paths
export BUILD_DIR=build_$1
    # epyc
    module load cmake
    module load gcc/13.3.0
    spack load openmpi@5.0.3%gcc@13.3.0
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
