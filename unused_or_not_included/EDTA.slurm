#!/bin/bash
#SBATCH --job-name="EDTA"
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task=24 
#SBATCH --output=/mnt/home/plachetzki/kcd1021/new_hag/logs/edta/edta-%J.log
#SBATCH --exclude=node117,node118

genome=$1
cds=$2

EDTA.pl \
  --genome $genome \
  --cds $cds \
  --anno 1 \
  --threads 24
