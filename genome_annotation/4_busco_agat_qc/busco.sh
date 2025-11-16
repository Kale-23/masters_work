#!/bin/bash

#SBATCH --job-name="aug"
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=128G
#SBATCH --output=augustus-%J.log
#SBATCH --exclude=node117,node118

module purge
module load anaconda/colsa
#source activate busco-5.4.7
#source activate busco-5.6.1
source activate busco-5.8.3
module purge

#which busco
#which python
#which python3


lineage=metazoa_odb12 # closest busco lineage
protein="/mnt/home/plachetzki/kcd1021/Genome_Annotation/braker/braker/braker.aa"
##genome="/mnt/home/plachetzki/kcd1021/Genome_Annotation/Hagatha_EST_ONT_HiC_quad_addl.hic.p_ctg.fa"
output="E_stoutii_braker_r1"

busco -l $lineage \
    -m protein\
    -c 48 \
    -i $protein \
    -o $output \
    --offline 


