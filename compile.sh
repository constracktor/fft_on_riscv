#!/bin/bash
################################################################################
# Preprocessing
################################################################################
# working directory
export ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )"
# export paths
export BUILD_DIR=build_$1
if [[ "$1" == "epyc" ]]
then
    # epyc
    module load cmake
    module load gcc/13.2.0
    #spack load boost hwloc
    #spack load hpx
    spack load openmpi@5.0.3
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
    export HPX_DIR="${ROOT}/hpx_scripts/hpx_1.10_riscv/install/lib"
    # MPI compiler
    export CXX=mpic++
    #export CXX=/opt/apps/openmpi/5.0.3/bin/mpic++
    # FFTW paths
    FFTW_RISCV="_riscv"
else
  echo 'Please specify system: "epyc" or "riscv"'
  exit 1
fi

# FFTW paths
export FFTW_TH_DIR="$ROOT/fftw_scripts/$1/fftw_threads_mpi$FFTW_RISCV/install/lib"
export FFTW_OMP_DIR="$ROOT/fftw_scripts/$1/fftw_omp_mpi$FFTW_RISCV/install/lib"
export FFTW_HPX_DIR="$ROOT/fftw_scripts/$1/fftw_hpx/install/lib"
export PKG_CONFIG_PATH="$FFTW_TH_DIR/pkgconfig":$PKG_CONFIG_PATH
# for riscv with measure planning: export FFTW_HPX_DIR="$HOME/fft_installations/$FFTW_DIR/fftw_hpx_riscv/install/lib"

################################################################################
# Compilation
################################################################################
rm -rf $BUILD_DIR && mkdir $BUILD_DIR && cd $BUILD_DIR
cmake .. -DCMAKE_BUILD_TYPE=Release -DHPX_DIR="${HPX_DIR}/cmake/HPX"
make -j $(grep -c ^processor /proc/cpuinfo)
