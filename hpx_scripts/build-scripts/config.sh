: ${POWERTIGER_ROOT:?} ${BUILD_TYPE:?}

export INSTALL_ROOT=${POWERTIGER_ROOT}/build
export SOURCE_ROOT=${POWERTIGER_ROOT}/src

################################################################################
# Package Configuration
################################################################################
# CMake
export CMAKE_VERSION=3.27.4

# GCC
export GCC_VERSION=13.2.1

export CLANG_VERSION=release/18.x

export OPENMPI_VERSION=5.0.3

# Boost
export BOOST_VERSION=1.84.0
export BOOST_ROOT=${INSTALL_ROOT}/boost
export BOOST_BUILD_TYPE=$(echo ${BUILD_TYPE/%WithDebInfo/ease} | tr '[:upper:]' '[:lower:]')

# jemalloc
export JEMALLOC_VERSION=5.3.0

# hwloc
export HWLOC_VERSION=2.9.1

# HPX
export HPX_VERSION=v1.10.0

# Max number of parallel jobs
export PARALLEL_BUILD=$(grep -c ^processor /proc/cpuinfo)

export LIB_DIR_NAME=lib
