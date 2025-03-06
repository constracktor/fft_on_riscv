cmake_minimum_required(VERSION 3.18)
project(hpx_fft CXX)

find_package(PkgConfig REQUIRED)
pkg_search_module(FFTW REQUIRED fftw3 IMPORTED_TARGET)


###########################################################
# FFTW
# MPI+OpenMP
find_package(OpenMP REQUIRED)
find_library(
    FFTW_OMP_MPI_LIB
    NAMES "fftw3_mpi"
    PATHS $ENV{FFTW_OMP_DIR}
)
find_library(
    FFTW_OMP_LIB
    NAMES "fftw3_omp"
    PATHS $ENV{FFTW_OMP_DIR}
)
add_executable(fftw_mpi_omp src/fftw_mpi_omp.cpp)
target_link_libraries(fftw_mpi_omp
                        PkgConfig::FFTW
                        ${FFTW_OMP_MPI_LIB}
                        ${FFTW_OMP_LIB}
                        OpenMP::OpenMP_CXX)
