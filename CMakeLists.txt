cmake_minimum_required(VERSION 3.18)
project(hpx_fft CXX)

find_package(HPX REQUIRED)
find_package(PkgConfig REQUIRED)
pkg_search_module(FFTW REQUIRED fftw3 IMPORTED_TARGET)

###########################################################
# HPX code 
add_executable(fft_hpx_task_sync_shared src/fft_hpx_task_sync_shared.cpp)
target_link_libraries(fft_hpx_task_sync_shared
                        HPX::hpx
                        HPX::iostreams_component
                        PkgConfig::FFTW)

add_executable(fft_hpx_task_naive_shared src/fft_hpx_task_naive_shared.cpp)
target_link_libraries(fft_hpx_task_naive_shared
                        HPX::hpx
                        HPX::iostreams_component
                        PkgConfig::FFTW)

add_executable(fft_hpx_task_shared src/fft_hpx_task_shared.cpp)
target_link_libraries(fft_hpx_task_shared
                        HPX::hpx
                        HPX::iostreams_component
                        PkgConfig::FFTW)

add_executable(fft_hpx_loop_shared src/fft_hpx_loop_shared.cpp)
target_link_libraries(fft_hpx_loop_shared
                        HPX::hpx
                        HPX::iostreams_component
                        PkgConfig::FFTW)

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

# OpenMP
add_executable(fftw_omp src/fftw_omp.cpp)
target_link_libraries(fftw_omp
                        PkgConfig::FFTW
                        ${FFTW_OMP_LIB}
                        OpenMP::OpenMP_CXX)
