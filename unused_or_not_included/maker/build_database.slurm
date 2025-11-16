#!/bin/bash
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task=24 
#SBATCH --job-name="RM BuildData"
#SBATCH --output=build_databas-%J.log
#SBATCH --exclude=node117,node118
#SBATCH --mem=128G

module purge
module load anaconda/colsa
source activate repeatmodeler-2.0.5

name="E_stoutii"
genome="/mnt/gpfs01/home/plachetzki/kcd1021/Genome_Annotation/Hag_test.fasta"

BuildDatabase \
    -name "$name" \
    "$genome"
