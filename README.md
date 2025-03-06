# FFTW MWE
## Required software

To compile, a recent version of OpenMPI is required.
Additionally, OpenMP compiler support and a FFTW installations is required.
Install FFTW via the script in `fftw_scripts\epyc`

## How to compile

The code can be compiled with `./compile.sh` on the computation node directly.

## How to run

Run `./shared_benchmark.sh ${TARGET}` where TARGET can be `node` to run on the node
directly with mpirun or `slurm` to run over srun.
Results are saved in `benchmark/result`.

For additional information please write to `alexander.strack@ipvs.uni-stuttgart.de`.
