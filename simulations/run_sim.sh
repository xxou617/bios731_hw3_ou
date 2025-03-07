#!/bin/bash
#SBATCH --array=1-4
#SBATCH --job-name=run_sim_job
#SBATCH --partition=short-cpu
#SBATCH --output=run_sim.out
#SBATCH --error=run_sim.err
#SBATCH --mail-type "ALL"
#SBATCH --mail-user=xou4@emory.edu

module purge
module load R

# Rscript to run an r script
# This stores which job is running (1, 2, 3, etc)
JOBID=$SLURM_ARRAY_TASK_ID
Rscript run_sim.R $JOBID


