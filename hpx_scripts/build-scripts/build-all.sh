#!/usr/bin/env bash

################################################################################
# Command-line help
################################################################################
print_usage_abort ()
{
    cat <<EOF >&2
SYNOPSIS
    ${0} {Release|RelWithDebInfo|Debug} {with-gcc|with-clang|with-CC|with-CC-clang} {with-mpi|without-mpi}
    [cmake|gcc|boost|hwloc|jemalloc|hpx|openmpi ...]
DESCRIPTION
    Download, configure, build, and install HPX and its dependencies or
    just the specified target.
EOF
    exit 1
}

################################################################################
# Command-line options
################################################################################
if [[ "$1" == "Release" || "$1" == "RelWithDebInfo" || "$1" == "Debug" ]]; then
    export BUILD_TYPE=$1
    echo "Build Type: ${BUILD_TYPE}"
else
    echo 'Build type must be provided and has to be "Release", "RelWithDebInfo", or "Debug"' >&2
    print_usage_abort
fi

if [[ "$2" == "with-gcc" ]]; then
    echo "Using self-built gcc "
elif [[ "$2" == "with-CC" ]]; then
    echo "Using CC / CXX compiler (whatever it may be)"
    export OCT_USE_CC_COMPILER=ON
elif [[ "$2" == "with-CC-clang" ]]; then
    echo "Using CC / CXX compiler (but expecting it to be some kind of clang)"
    export OCT_WITH_CLANG=ON
    export OCT_USE_CC_COMPILER=ON
elif [[ "$2" == "with-clang" ]]; then
    echo "Using self-built clang "
    export OCT_WITH_CLANG=ON
else
    echo 'Compiler must be specified with "with-gcc" or "with-clang" or "with-CC" or "with-CC-clang' >&2
    print_usage_abort
fi
export OCT_COMPILER_OPTION="$2"

if [[ "$3" == "without-mpi" ]]; then
    export OCT_WITH_MPI=OFF
    export OCT_WITH_PARCEL=OFF
    echo "Parcelport disabled"
elif [[ "$3" == "with-mpi" ]]; then
    export OCT_WITH_MPI=ON
    export OCT_WITH_PARCEL=ON
    echo "Parcelport enabled"
else
    echo 'Parcelport support must be provided and has to be "with-mpi" or "without-mpi""' >&2
    print_usage_abort
fi

while [[ -n ${13} ]]; do
    echo " Currently handling build ${13}"
    case ${13} in
        cmake)
            echo 'Target cmake will build.'
            export BUILD_TARGET_CMAKE=
            shift
        ;;
        gcc)
            if [[ "$2" == "with-gcc" ]]; then
              echo 'Target gcc will build.'
              export BUILD_TARGET_GCC=
              shift
            else  
              echo 'Error: Trying to build gcc target without using the with-gcc parameter' >&2
              print_usage_abort
            fi
        ;;
        clang)
            if [[ "$2" == "with-clang" ]]; then
              echo 'Target clang will build.'
              export BUILD_TARGET_CLANG=
              shift
            else  
              echo 'Error: Trying to build clang target without using the with-clang parameter' >&2
              print_usage_abort
            fi
        ;;
        openmpi)
            echo 'Target openmpi will build.'
            export BUILD_TARGET_OPENMPI=
            shift
        ;;

        boost)
            echo 'Target boost will build.'
            export BUILD_TARGET_BOOST=
            shift
        ;;
        hwloc)
            echo 'Target hwloc will build.'
            export BUILD_TARGET_HWLOC=
            shift
        ;;
        jemalloc)
            echo 'Target jemalloc will build.'
            export BUILD_TARGET_JEMALLOC=
            shift
        ;;
        hpx)
            echo 'Target hpx will build.'
            export BUILD_TARGET_HPX=
            shift
        ;;
        *)
            echo 'Unrecognizable argument passesd.' >&2
            echo "Argument was: ${12}" >&2
            print_usage_abort
        ;;
    esac
done

# Build all if no target(s) specified
if [[ -z ${!BUILD_TARGET_@} ]]; then
    echo 'No targets specified. All targets will build.'
    export BUILD_TARGET_CMAKE=
    if [[ "$2" == "with-gcc" ]]; then
      export BUILD_TARGET_GCC=
    elif [[ "$2" == "with-clang" ]]; then
        export BUILD_TARGET_CLANG=
    fi
    if [[ "$4" == "with-mpi" ]]; then
        export BUILD_TARGET_OPENMPI=
    fi
    export BUILD_TARGET_BOOST=
    export BUILD_TARGET_HWLOC=
    export BUILD_TARGET_JEMALLOC=
    export BUILD_TARGET_HPX=
fi

if [[ -d "/etc/opt/cray/release/" ]]; then
    unset BUILD_TARGET_GCC
    unset BUILD_TARGET_CLANG
    unset BUILD_TARGET_OPENMPI
fi
################################################################################
# Diagnostics
################################################################################
set -e
set -x

################################################################################
# Configuration
################################################################################
# Script directory
export POWERTIGER_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )"

# Set Build Configuration Parameters
source config.sh

################################################################################
# Create source and installation directories
################################################################################
mkdir -p ${SOURCE_ROOT} ${INSTALL_ROOT}

################################################################################
# Build tools
################################################################################
[[ -n ${BUILD_TARGET_GCC+x} ]] && \
(
    echo "Building GCC"
    ./build-gcc.sh
)
[[ -n ${BUILD_TARGET_CLANG+x} ]] && \
(
    echo "Building clang"
    ./build-clang.sh
)

# Set Compiler Environment Variables
if [[ "${OCT_COMPILER_OPTION}" == "with-gcc" ]]; then
    echo "Using gcc"
    source gcc-config.sh
elif [[ "${OCT_COMPILER_OPTION}" == "with-clang" ]]; then
    echo "Using clang"
    source clang-config.sh
elif [[ "${OCT_COMPILER_OPTION}" == "with-CC" ]]; then
    echo "Using gcc"
    export OCT_USE_CC_COMPILER=ON
    source gcc-config.sh
elif [[ "${OCT_COMPILER_OPTION}" == "with-CC-clang" ]]; then
    echo "Using clang"
    export OCT_USE_CC_COMPILER=ON
    source clang-config.sh
else
    echo "Unknown compiler option: $2"
    exit 1
fi

[[ -n ${BUILD_TARGET_CMAKE+x} ]] && \
(
    echo "Building CMake"
    #./build-cmake.sh
)
#export CMAKE_COMMAND=${INSTALL_ROOT}/cmake/bin/cmake
export CMAKE_COMMAND=cmake

################################################################################
# Dependencies
################################################################################

[[ -n ${BUILD_TARGET_OPENMPI+x} ]] && \
(
    echo "Building Openmpi"
    ./build-openmpi.sh
)

if [[ ${OCT_WITH_PARCEL} == ON  ]]; then
   if [[ -d ${INSTALL_ROOT}/openmpi  ]]; then
	source openmpi-config.sh
   fi
fi

[[ -n ${BUILD_TARGET_BOOST+x} ]] && \
(
    echo "Building Boost"
    #./build-boost.sh
)
[[ -n ${BUILD_TARGET_HWLOC+x} ]] && \
(
    echo "Building hwloc"
    #./build-hwloc.sh
)
[[ -n ${BUILD_TARGET_JEMALLOC+x} ]] && \
(
    echo "Building jemalloc"
    #./build-jemalloc.sh
)
[[ -n ${BUILD_TARGET_HPX+x} ]] && \
(
    echo "Building HPX"
    ./build-hpx.sh
)
