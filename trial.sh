#!/bin/sh
#SBATCH --job-name=Fig3c
#SBATCH --account=naughton
#SBATCH --partition=normal_q
#SBATCH --qos=tc_normal_short
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16 #<SINCE THE SCRIPT ONLY NEEDS 8>
#SBATCH --time=06:00:00
#SBATCH --output=./out/DataOutput_%A.out # Print statements and STDOUT stuff goes into this file
#SBATCH --error=./out/Failure_%A.err # Progress bars and other errors go into this file
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=alyssalm@vt.edu
 
module reset
#module load python3
module load FFmpeg/6.0-GCCcore-12.3.0
module load Miniforge3
 
#conda init
source activate topology-dynamics-control
which python
 
cd "${SLURM_SUBMIT_DIR}" #<THIS ENSURES THAT THE JOB IS RUNNING FROM YOUR REPO AND THE OUT FOLDER WILL BE MADE THERE>
mkdir -p out
 
cd Cases/Figure3c/Inject
 
# One thread per env worker; 100 processes each opening a BLAS pool would thrash.
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export NUMEXPR_NUM_THREADS=1
# Elastica's njit kernels are cached; keep it node-local and per-job.
export NUMBA_CACHE_DIR="${TMPDIR:-/tmp}/numba_cache_${SLURM_JOBID}"
mkdir -p "${NUMBA_CACHE_DIR}"
 
echo "job ${SLURM_JOBID} started"
 
python run_script.py
 
echo "finished $(date)"