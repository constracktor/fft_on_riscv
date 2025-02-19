#!/bin/bash
################################################################################
# Preprocessing
################################################################################
# working directory
export ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )"
# export paths
if [[ "$1" == "epyc" ]]
then
    # epyc
    module load cmake
    module load ipvs-epyc/openmpi/4.0.4-gcc-10.2
    spack load hpx
    export HPX_DIR="$ROOT/installation_scripts/hpx_1.9_mpi/install/lib"
    # MPI compiler
    export CXX="/usr/local.nfs/sgs/software/ipvs-epyc/openmpi/4.0.4-gcc10.2/bin/mpic++"
elif [[ "$1" == "buran_mpi" ]]
then
    # buran with HPX using MPI parcelport
    module load gcc/11.2.1
    module load openmpi
    export HPX_DIR="${ROOT}/../hpxsc_installations/hpx_1.9.1_mpi_gcc_11.2.1/build/hpx/build/lib"
    # MPI compiler
    export CXX="${ROOT}/../hpxsc_installations/hpx_1.9.1_mpi_gcc_11.2.1/build/openmpi/bin/mpic++"
elif [[ "$1" == "buran_lci" ]]
then
    # buran with HPX using LCI parcelport
    module load gcc/11.2.1
    module load openmpi
    export HPX_DIR="${ROOT}/../hpxsc_installations/hpx_1.9.1_lci_gcc_11.2.1/build/hpx/build/lib"
    # MPI compiler
    export CXX="${ROOT}/../hpxsc_installations/hpx_1.9.1_mpi_gcc_11.2.1/build/openmpi/bin/mpic++"
else
  echo 'Please specify system: "epyc" or "buran_mpi" or "buran_lci"'
  exit 1
fi
export CMAKE_COMMAND=cmake
# FFTW paths
export FFTW_SEQ_DIR="$ROOT/fftw_scripts/fftw_seq/install/lib"
export FFTW_TH_DIR="$ROOT/fftw_scripts/fftw_threads_mpi/install/lib"
export FFTW_OMP_DIR="$ROOT/fftw_scripts/fftw_omp_mpi/install/lib"
export FFTW_HPX_DIR="$ROOT/fftw_scripts/fftw_hpx/install/lib"
export PKG_CONFIG_PATH="$FFTW_SEQ_DIR/pkgconfig":$PKG_CONFIG_PATH

################################################################################
# Compilation
################################################################################
rm -rf build && mkdir build && cd build
$CMAKE_COMMAND .. -DCMAKE_BUILD_TYPE=Release -DHPX_DIR="${HPX_DIR}/cmake/HPX"
make -j $(grep -c ^processor /proc/cpuinfo)
