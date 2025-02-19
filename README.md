# Experiences Porting Shared and Distributed Applications to Asynchronous Tasks: A Multidimensional FFT Case-study

This code is provided along with "Experiences Porting Shared and Distributed Applications to Asynchronous Tasks: A Multidimensional FFT Case-study"
by Alexander Strack, Christopher Taylor, Patrick Diehl, and Dirk Pflueger. 

## Required software

To compile, recent versions of OpenMPI, HPX, CMake, and PkgConfig are required.
Additionally, OpenMP compiler support and several FFTW installations are required.
We provide scripts to install separate FFTW instances with the backends used in this work.  

## How to compile

The code can be compiled with `./compile.sh $SYSTEM` on the computation node directly.
The variable `export SYSTEM=epyc/buran_mpi/buran_lci` refers to the benchmark system and HPX parcelport.
If necessary, adjust the paths in `compile.sh`.

## How to run

Two benchmark scripts are provided. The shared-memory benchmark script can be launched via `./shared_benchmark $PARTITION`.
The variable `export LAUNCH=<partition_name>/node` refers to whether the script is launched via slurm on a partition or 
directly on a computation node. The distributed benchmark script can be launched via `./distributed_benchmark.sh $PARTITION`. 
The variable `export PARTITION=buran` refers to the server partition.

## Software and compiler versions

Here we list hardware information and software versions used for our benchmarks.

### Shared-memory

The shared-memory results were obtained on a dual-socket [AMD EPYC 7742](https://www.amd.com/de/products/cpu/amd-epyc-7742) system.
It has 128 cores and a combined L3 cache of 512 MB.

Software versions:

- GCC: 9.4.0

- CMake: 3.19.5

- PkgConfig: 0.29.1

- OpenMP: 4.5

- OpenMPI: 4.1.5

- Boost: 1.75.0

- hwloc: 2.9.1

- jemalloc: 5.2.1

- HPX: 1.9.1

- FFTW: 3.3.10

### Distributed

The distributed results were obtained on a 16-node cluster with homogeneous nodes. 
Each node contains a dual-socket [AMD EPYC 7352](https://www.amd.com/de/products/cpu/amd-epyc-7352) with 48 cores and a total of 256 MB of L3 cache.

Software versions:

- GCC: 11.2.1

- CMake: 3.27.0

- PkgConfig: 1.4.2

- OpenMP: 4.5

- OpenMPI: 4.1.6

- Boost: 1.83.0

- hwloc: 2.9.3

- jemalloc: 5.3.0

- HPX: 1.9.1

- FFTW: 3.3.10

## Contact

For additional information please write to `alexander.strack@ipvs.uni-stuttgart.de`.
