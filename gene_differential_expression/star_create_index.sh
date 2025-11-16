#!/bin/bash
module purge
module load anaconda/colsa
source activate star-2.7.10b
module purge

STAR \
    --runMode genomeGenerate \
    --genomeDir "/mnt/home/plachetzki/kcd1021/Genome_Annotation/M_glu/star/M_glu_index" \
    --genomeFastaFiles "/mnt/gpfs01/home/plachetzki/kcd1021/new_hag/M_glutinosa_genome/GCF_040869285.1_UKY_Mglu_1.0_genomic.fna" \
    --sjdbGTFfile "/mnt/gpfs01/home/plachetzki/kcd1021/new_hag/M_glutinosa_genome/genomic.gtf" \
    --sjdbOverhang 149
