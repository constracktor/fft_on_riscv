#!/bin/bash
################################################################################
# Preprocessing
################################################################################
# working directory
export ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )"
# export paths
export BUILD_DIR=build_$1
if [[ "$1" == "x86" ]]
then
    # x86
    module load cmake
    module load gcc/13.3.0
    #spack load boost hwloc
    #spack load hpx
    spack load openmpi@5.0.3%gcc@13.3.0
    # HPX lib directory
    export HPX_DIR="$ROOT/hpx_scripts/hpx_1.10_mpi/install/lib"
    #export LD_LIBRARY_PATH=$HPX_DIR:$LD_LIBRARY_PATH
    # MPI compiler
    export CXX="mpic++"
elif [[ "$1" == "riscv" ]]
then
    # riscv
    module laoad gcc/13.2.1
    module load openmpi/5.0.3
    # HPX lib directory
    export HPX_DIR="/home/alex/git_workspace/fft_on_riscv/hpx_scripts/build-scripts/build/hpx/lib64"
    # MPI compiler
    export CXX=mpic++
    # FFTW paths
    FFTW_RISCV="_riscv"
else
  echo 'Please specify system: "x86" or "riscv"'
  exit 1
fi

# FFTW paths
export FFTW_OMP_DIR="$ROOT/fftw_scripts/$1/fftw_omp_mpi$FFTW_RISCV/install/lib"
export PKG_CONFIG_PATH="$FFTW_OMP_DIR/pkgconfig":$PKG_CONFIG_PATH

################################################################################
# Compilation
################################################################################
rm -rf $BUILD_DIR && mkdir $BUILD_DIR && cd $BUILD_DIR
cmake .. -DCMAKE_BUILD_TYPE=Release -DHPX_DIR="${HPX_DIR}/cmake/HPX"
make -j $(grep -c ^processor /proc/cpuinfo)
