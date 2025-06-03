#!/bin/bash
################################################################################
# Benchmark script for shared memory 
# $1: FFTW planning flag (estimate/measure)
# $2: platform (x86/riscv)
if [[ "$2" == "x86" ]]
then
    PARTITION=epyc
    THREAD_POW=6
    BUILD_DIR=build_x86
elif [[ "$2" == "riscv" ]]
then
    PARTITION="risc5 -w sven0"
    THREAD_POW=6
    BUILD_DIR=build_riscv
else
  echo 'Please specify platform'
  exit 1
fi
LOOP=10
FFTW_PLAN=$1
THREADS=$((2**$THREAD_POW))
cd benchmark
# HPX implementations
# shared only
sbatch -p $PARTITION -N 1 -n 1 -c $THREADS run_hpx_shared.sh $BUILD_DIR/fft_hpx_loop_shared $FFTW_PLAN $THREAD_POW $LOOP
sbatch -p $PARTITION -N 1 -n 1 -c $THREADS run_hpx_shared.sh $BUILD_DIR/fft_hpx_task_sync_shared $FFTW_PLAN $THREAD_POW $LOOP
sbatch -p $PARTITION -N 1 -n 1 -c $THREADS run_hpx_shared.sh $BUILD_DIR/fft_hpx_task_shared $FFTW_PLAN $THREAD_POW $LOOP
sbatch -p $PARTITION -N 1 -n 1 -c $THREADS run_hpx_shared.sh $BUILD_DIR/fft_hpx_task_naive_shared $FFTW_PLAN $THREAD_POW $LOOP
# FFTW backends
# shared only
sbatch -p $PARTITION -N 1 -n 1 -c $THREADS run_fftw_omp.sh $BUILD_DIR/fftw_omp $FFTW_PLAN $THREAD_POW $LOOP
# distributed possible
sbatch -p $PARTITION -N 1 -n 1 -c $THREADS run_fftw_mpi_omp.sh $BUILD_DIR/fftw_mpi_omp $FFTW_PLAN $THREAD_POW $LOOP
# MPI
sbatch -p $PARTITION -N 1 -n $THREADS -c 1 run_fftw_mpi.sh $BUILD_DIR/fftw_mpi_omp $FFTW_PLAN $THREAD_POW $LOOP
