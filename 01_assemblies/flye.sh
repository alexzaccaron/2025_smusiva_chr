#!/bin/bash
#SBATCH -D /nfs7/BPP/Weisberg_Lab/projects/zaccaroa/septoria_assembly/rebasecall_SUP_5_0/output/05flye
#SBATCH --partition=bpp
#SBATCH --nodelist=selway
#SBATCH --job-name=flye
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --mem=48G
#SBATCH --time=32:00:00
#SBATCH --output=flye.out
#SBATCH --error=flye.err


# firt, activate my conda environment
eval "$(/nfs7/BPP/Weisberg_Lab/lab_members/zaccaron/miniforge3/condabin/conda shell.bash hook)"
conda activate flye



sed -n '22,22p' samples.txt | tr '\t' '\n' | while read SAMPLE; do
   read GENOSIZE
   read FASTQ
   
   time flye \
      --genome-size ${GENOSIZE}m \
      --threads 24 \
      --iterations 3 \
      --nano-hq  ${FASTQ} \
      --scaffold \
      --out-dir default/${SAMPLE}  > logs/${SAMPLE}_default.log 2>&1

done 




