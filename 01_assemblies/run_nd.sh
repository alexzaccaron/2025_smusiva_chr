#!/bin/bash
#SBATCH -D /nfs7/BPP/Weisberg_Lab/projects/zaccaroa/septoria_assembly/rebasecall_SUP_5_0/output/06nextdenovo
#SBATCH --partition=bpp
#SBATCH --job-name=nd_17-22p
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --mem=48G
#SBATCH --time=99:00:00
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err


eval "$(/nfs7/BPP/Weisberg_Lab/lab_members/zaccaron/miniforge3/condabin/conda shell.bash hook)"
conda activate nextdenovo
nextDenovo --version

sed -n '17,22p' samples.txt | tr '\t' '\n' | while read SAMPLE; do
   read GENOSIZE

   cp fof/${SAMPLE}.fof ./input.fof
   sed "s/SAMPLE/${SAMPLE}/g; s/SIZE/${GENOSIZE}/g" template.cfg > run.cfg
   time nextDenovo run.cfg > logs/${SAMPLE}.log 2>&1

   rm -f input.fof run.cfg
done
