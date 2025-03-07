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
# opam init --compiler=4.11.0
# eval $(opam env --switch=4.11.0)
# opam install ocamlbuild
# opam install num
#
# The folling paths have to be exported:
# $HPX_DIR: path to HPX installation
# $OPAM_WORK_DIR: path to opam installation

# add HPX to PkgConfig path
export ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )/fftw_hpx"
#export HPX_DIR="../../../hpx_scripts/hpx_1.10_riscv/lib"
export HPX_DIR="${ROOT}/../../hpx_scripts/hpx_1.10_riscv/install"
export PKG_CONFIG_PATH="$HPX_DIR/lib/pkgconfig":$PKG_CONFIG_PATH
# add ocaml to path
export OPAM_WORK_DIR="$HOME/.opam/4.11.0/bin"
export PATH=$OPAM_WORK_DIR:$PATH
# setup opam print dependency versions for testing
ocaml --version
ocamlbuild --version
# configure folder structure
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
./configure --prefix=$DIR_INSTALL --enable-maintainer-mode --enable-hpx
make -j $(grep -c ^processor /proc/cpuinfo)
# install
#make install
