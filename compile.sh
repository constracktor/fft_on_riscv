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
    export HPX_DIR="$ROOT/hpx_scripts/hpx_1.9_mpi/install/lib"
    # MPI compiler
    export CXX="/usr/local.nfs/sgs/software/ipvs-epyc/openmpi/4.0.4-gcc10.2/bin/mpic++"
elif [[ "$1" == "sven" ]]
then
    # sven
    export FFTW_DIR=sven
    # HPX lib directory
    export HPX_DIR="${HOME}/hpxsc_installations/hpx_1.9.1_gcc_13.2.1_sven/build/hpx/lib64"
    # MPI compiler
    module load mpi/openmpi-riscv64
    export CXX=mpic++
else
  echo 'Please specify system: "epyc" or "buran_mpi" or "buran_lci"'
  exit 1
fi
export CMAKE_COMMAND=cmake
# FFTW paths
export FFTW_TH_DIR="$ROOT/fftw_scripts/fftw_threads_mpi/install/lib"
export FFTW_OMP_DIR="$ROOT/fftw_scripts/fftw_omp_mpi/install/lib"
export FFTW_HPX_DIR="$ROOT/fftw_scripts/fftw_hpx/install/lib"
export PKG_CONFIG_PATH="$FFTW_TH_DIR/pkgconfig":$PKG_CONFIG_PATH

################################################################################
# Compilation
################################################################################
rm -rf $BUILD_DIR && mkdir $BUILD_DIR && cd $BUILD_DIR
$CMAKE_COMMAND .. -DCMAKE_BUILD_TYPE=Release -DHPX_DIR="${HPX_DIR}/cmake/HPX"
make -j $(grep -c ^processor /proc/cpuinfo)
