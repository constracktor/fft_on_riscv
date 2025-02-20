#!/usr/bin/env bash
# This script installs FFTW3 from github with MPI+OpenMP backend
#
# Requirements:
# ocaml, ocamlbuild, bubblewrap, 
# autoconf, automake, indent, and libtool
#
# We recommend installing opam with spack:
# source spack/share/spack/setup-env.sh
# spack install bubblewrap opam
# spack load bubblewrap opam
# export PYTHONPATH=/home/alex/.spack/bootstrap/store/linux-fedora38-riscv64/gcc-13.2.1/clingo-bootstrap-spack-ez2jhwt6vabttddr6xxpuq2px33pewbl/lib64/python3.11/site-packages
# opam init --compiler=4.11.0
# eval $(opam env --switch=4.11.0)
# opam install ocamlbuild
# opam install num
#
# The folling paths have to be exported:
# $OPAM_WORK_DIR: path to opam installation
# $MPI_DIR: path to MPI installation (or load MPI module)

module load gcc/13.2.1
# add MPI to path or load MPI module
module load openmpi/5.0.3
# add ocaml to path
export OPAM_WORK_DIR="$HOME/.opam/4.11.0/bin"
export PATH=$OPAM_WORK_DIR:$PATH
# setup opam print dependency versions for testing
ocaml --version
ocamlbuild --version
# configure folder structure
export ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )/fftw_threads_mpi_riscv"
export DIR_SRC="$ROOT/src"
export DIR_INSTALL="$ROOT/install"
# configure repo                                                                                            
export DOWNLOAD_URL="https://github.com/ct-clmsn/fftw3.git"
export BRANCH="hpx"
# get src data
mkdir -p $DIR_SRC
cd $DIR_SRC
git clone $DOWNLOAD_URL .
git checkout $BRANCH
./bootstrap.sh
./configure --enable-maintainer-mode --prefix=$DIR_INSTALL --enable-mpi --enable-threads
make -j $(grep -c ^processor /proc/cpuinfo)
# install
make install
