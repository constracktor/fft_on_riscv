# Parallel FFTW on RISC-V

This code is provided along with "Parallel FFTW on RISC-V: A Comparative Study including OpenMP, MPI, and HPX" by Alexander Strack, Christopher Taylor, and Dirk Pflueger.

## Required software

To compile, recent versions of CMake, and PkgConfig are required.
Additionally, OpenMP compiler support as well as FFTW and HPX installations are required.
We provide scripts to install parallel FFTW and HPX in the respective directories.

## How to compile

The code can be compiled with `./compile.sh $SYSTEM` on the computation node directly.
The variable `export SYSTEM=x86/riscv` refers to the hardware architecture.
If necessary, adjust the paths in `compile.sh`.

## How to run

The shared-memory benchmark script can be launched via `./shared_benchmark $SYSTEM`.

## Software and compiler versions

Here we list hardware information and software versions used for our benchmarks.

### Software vesions on x86 CPU

The x86 results were obtained on a [AMD EPYC 7742](https://www.amd.com/en/support/downloads/drivers.html/processors/epyc/epyc-7002-series/amd-epyc-7742.html) CPU.
It has 64 cores and a combined L3 cache of 256 MB.

Software versions:

- GCC: 13.3.0

- CMake: 3.28.3

- PkgConfig: 1.8.1

- OpenMP: 4.5

- OpenMPI: 4.1.6

- Boost: 1.84.0

- hwloc: 2.10.0

- jemalloc: 5.3.0

- HPX: 1.10.0

- FFTW: 3.3.10

### Software vesions on RISC-V CPU

The RISC-V results were obtained on a [SOPHON SG2042](https://en.sophgo.com/sophon-u/product/introduce/sg2042.html) CPU.
It has 64 cores and a combined L3 cache of 64 MB.

Software versions:

- GCC: 13.2.1

- CMake: 3.27.4

- PkgConfig: 1.8.0

- OpenMP: 4.5

- OpenMPI: 5.0.3

- Boost: 1.84.0

- hwloc: 2.10.0

- jemalloc: 5.3.0

- HPX: 1.10.0

- FFTW: 3.3.10


For additional information please write to alexander.strack@ipvs.uni-stuttgart.de or sc@ipvs.uni-stuttgart.de.
