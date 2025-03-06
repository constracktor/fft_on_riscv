#!/bin/bash
################################################################################
# Benchmark script for shared memory 
PARTITION=epyc
THREAD_POW=6
BUILD_DIR=build_epyc
LOOP=1
#0
FFTW_PLAN=estimate
THREADS=$((2**$THREAD_POW))
cd benchmark
if [[ "$1" == "slurm" ]]
then
    # MPI
    sbatch -p $PARTITION -N 1 -n $THREADS -c 1 ./run_fftw_mpi.sh $BUILD_DIR/fftw_mpi_omp $FFTW_PLAN $THREAD_POW $LOOP
elif [[ "$1" == "node" ]]
then
    ./run_fftw_mpi_local.sh $BUILD_DIR/fftw_mpi_omp $FFTW_PLAN $THREAD_POW $LOOP
else
    echo 'Please specify node or slurm'
  exit 1
fi
