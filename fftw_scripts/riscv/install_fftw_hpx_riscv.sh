#!/usr/bin/env bash
## This script installs FFTW3 from github with experimental HPX backend
#
# Requirements:
# HPX, ocaml, ocamlbuild, bubblewrap, 
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
# $HPX_DIR: path to HPX installation
# $OPAM_WORK_DIR: path to opam installation

# add HPX to PkgConfig path
export HPX_DIR="/home/alex/hpxsc_installations/hpx_1.9.1_gcc_13.2.1_sven/build/hpx/lib64"
export PKG_CONFIG_PATH="$HPX_DIR/pkgconfig":$PKG_CONFIG_PATH
# add ocaml to path
export OPAM_WORK_DIR="$HOME/.opam/4.11.0/bin"
export PATH=$OPAM_WORK_DIR:$PATH
# setup opam print dependency versions for testing
ocaml --version
ocamlbuild --version
# configure folder structure
export ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )/fftw_hpx_riscv"
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
./configure --enable-maintainer-mode --enable-hpx --enable-threads --enable-shared --prefix=$DIR_INSTALL
make -j $(grep -c ^processor /proc/cpuinfo)
# install
make install
