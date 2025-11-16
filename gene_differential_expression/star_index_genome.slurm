#!/bin/bash
#SBATCH --job-name=star
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=100G
#SBATCH --array=1-29%29
#SBATCH --output=./logs/star_%j.out
#SBATCH --exclude=node\[117-118\]

module purge
module load anaconda/colsa
source activate star-2.7.10b
module purge

common="/mnt/home/plachetzki/kcd1021/Genome_Annotation/M_glu/star"
#slurm setup
batch_list="$common"/star_slurm_input.txt
dir=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $batch_list)

# used in star
star_index="$common"/E_stoutii_index
threads=12

# reads setup
forward_reads=$(find $dir* -type f -name "*1.P*" | paste -sd "," -)
reverse_reads=$(find $dir* -type f -name "*2.P*" | paste -sd "," -)

for item in $forward_reads; do
    name=$(basename $item) 
done
output_name=${name%_*}

output_dir="$common"/star_output
mkdir -p $output_dir

STAR \
    --genomeDir "$star_index" \
    --readFilesIn "$forward_reads" "$reverse_reads" \
    --readFilesCommand gunzip -c \
    --outFileNamePrefix "$output_dir"/"$output_name" \
    --outSAMtype BAM SortedByCoordinate \
    --quantMode TranscriptomeSAM GeneCounts

