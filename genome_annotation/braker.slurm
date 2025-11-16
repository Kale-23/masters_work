#!/bin/bash
#SBATCH --job-name="braker"
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=256G
#SBATCH --output=braker-%J.log
#SBATCH --exclude=node117,node118

module purge
module load anaconda/colsa
source activate braker3-3.0.8
module purge

## this is kinda stupid 
home="/mnt/home/plachetzki/kcd1021"
genemark="$home"/.conda/envs/braker3-3.0.8/bin/GeneMark-ETP/
export PATH="$genemark"tools:$PATH
export PATH="$genemark"bin:$PATH
export PATH="$genemark"bin/gmas:$PATH
export PATH="$genemark"bin/gmst:$PATH
export PATH="$home"/.conda.envs/braker3-3.0.8/bin/prothint/bin:$PATH

export AUGUSTUS_CONFIG_PATH="$home"/.conda/envs/braker3-3.0.8/config
export PROTHINT_PATH="$home"/.conda/envs/braker3-3.0.8/bin/prothint/bin/

genome="E_stoutii_masked.fa"
bams=$(find ./hisat/sams -type f -name "*.bam" | paste -sd "," -)
proteins="Hag_proteins.faa"

which python3

braker.pl \
    --species=E_stoutii \
    --genome=$genome \
    --bam=$bams \
    --prot_seq=$proteins \
    --gff3 \
    --threads=48 

