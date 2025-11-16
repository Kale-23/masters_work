#!/bin/bash
#SBATCH --job-name=stringy
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --array=1-29%29
#SBATCH --output=./logs/compare_%j.out
#SBATCH --exclude=node\[117-118\]

batch_list=stringtie_numbered_slurm_input.txt
bam=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $batch_list)
gff_genome=/mnt/gpfs01/home/plachetzki/kcd1021/Genome_Annotation/braker/braker_egg_sorted.gff

# globals
file=$(basename $bam)
output_prefix=${file%_*}
threads=5

output_dir="./gtfs"
mkdir -p $output_dir

module purge
module load anaconda/colsa
source activate stringtie-3.0.0
module purge
date

echo ##############################
echo working on $bam
echo ##############################

#stringtie \
#    $bam \
#    -l $output_prefix \
#    -p $threads \
#    -G $gff_genome \
#    -o $output_dir/${output_prefix}.gtf

genome_masked="/mnt/gpfs01/home/plachetzki/kcd1021/Genome_Annotation/braker/E_stoutii_masked.fa"
out_prefix="compared_${output_prefix}"
in_file="$output_dir/${output_prefix}.gtf"

gffcompare \
    -r $gff_genome \
    -s $genome_masked \
    -o $out_prefix \
    $in_file
