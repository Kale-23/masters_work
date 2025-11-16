#!/bin/bash
#SBATCH --job-name=hisat
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=200G
#SBATCH --array=1-29%10
#SBATCH --output=./logs/hisat_%j.out
#SBATCH --exclude=node\[117-118\]

# globals
threads=24
genome_location=~/Genome_Annotation/inputs/E_stoutii_genome.fasta

# load for hisat
# need to purge after incase old hisat version in module over conda
module purge
module load anaconda/colsa
source activate HISAT2-2.2.1
module purge
date

# slurm setup
batch_list=hisat_numbered_input.txt
dir=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $batch_list)

# hisat setup
forward_reads=$(find $dir* -type f -name "*1.P*" | paste -sd "," -)
reverse_reads=$(find $dir* -type f -name "*2.P*" | paste -sd "," -)

output_dir="./sams"
mkdir -p $output_dir

# this is stupid but I am lazy
for item in $forward_reads; do
    #name=$(basename $(dirname $item))
    name=$(basename $item) 
done
output_sam=$output_dir/${name%_*}.sam


echo ##############################
echo working on $output_sam
echo ##############################

hisat2 \
    -x ./hisat_database/E_stoutii \
    -1 $forward_reads \
    -2 $reverse_reads \
    -p $threads \
    -S $output_sam 

# for samtools
module load linuxbrew/colsa

 convert to bam
samtools view --threads $threads -b -o ${output_sam%.*}.bam $output_sam &&
    rm $output_sam

 sort bam
samtools sort -m 5G -o ${output_sam%.*}_sorted.bam  --threads $threads ${output_sam%.*}.bam &&
    rm ${output_sam%.*}.bam

samtools index ${output_sam%.*}_sorted.bam ${output_sam%.*}_sorted.bam.bai


# this never worked
#module purge
#module load anaconda/colsa
#source activate openjdk-23.0.2
#module purge
#
#java -jar \
#    ./picard.jar \
#        CollectAlignmentSummaryMetrics \
#        REFERENCE_SEQUENCE=$genome_location \
#        INPUT=${output_sam%.*}_sorted.bam \
#        OUTPUT=${output_sam%.*}.bam_alignment.stats
#date
