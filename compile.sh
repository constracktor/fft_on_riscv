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
    module load ipvs-epyc/openmpi/4.0.4-gcc-10.2
    spack load hpx
    # HPX lib directory
    export HPX_DIR="$ROOT/hpx_scripts/hpx_1.9_mpi/install/lib"
    # MPI compiler
    export CXX="/usr/local.nfs/sgs/software/ipvs-epyc/openmpi/4.0.4-gcc10.2/bin/mpic++"

elif [[ "$1" == "riscv" ]]
then
    # sven
    module load openmpi/5.0.3
    # HPX lib directory
    export HPX_DIR="${ROOT}/hpx_scripts/hpx_1.9_riscv/install/lib"
    # MPI compiler
    export CXX=/opt/apps/openmpi/5.0.3/bin/mpic++
else
  echo 'Please specify system: "epyc" or "sven"'
  exit 1
fi

# FFTW paths
export FFTW_TH_DIR="$ROOT/fftw_scripts/$1/fftw_threads_mpi/install/lib"
export FFTW_OMP_DIR="$ROOT/fftw_scripts/$1/fftw_omp_mpi/install/lib"
export FFTW_HPX_DIR="$ROOT/fftw_scripts/$1/fftw_hpx/install/lib"
export PKG_CONFIG_PATH="$FFTW_TH_DIR/pkgconfig":$PKG_CONFIG_PATH
# for sven with measure planning: export FFTW_HPX_DIR="$HOME/fft_installations/$FFTW_DIR/fftw_hpx_riscv/install/lib"

################################################################################
# Compilation
################################################################################
rm -rf $BUILD_DIR && mkdir $BUILD_DIR && cd $BUILD_DIR
cmake .. -DCMAKE_BUILD_TYPE=Release -DHPX_DIR="${HPX_DIR}/cmake/HPX"
make -j $(grep -c ^processor /proc/cpuinfo)
