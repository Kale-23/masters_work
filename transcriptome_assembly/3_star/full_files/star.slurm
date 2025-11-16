#!/bin/bash
#SBATCH --job-name="star"
#SBATCH --ntasks=1 
#SBATCH --array=1-181%10
#SBATCH --cpus-per-task=24 
#SBATCH --output=/mnt/home/plachetzki/kcd1021/new_hag/logs/star/star-%J.log
#SBATCH --exclude=node117,node118

# slurm batch script input
batch_list=/mnt/home/plachetzki/kcd1021/new_hag/commands/3_star/star_in_slurm
read_dir=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $batch_list)

output=$(basename $read_dir)
forward_reads=$(find $read_dir -name "*_1.P.cor.trim.fq.gz" -exec realpath {} \;)
reverse_reads=$(find $read_dir -name "*_2.P.cor.trim.fq.gz" -exec realpath {} \;)
echo $read_dir
echo title $output
echo forward $forward_reads
echo reverse $reverse_reads
    
STAR --runThreadN 20 \
     --readFilesCommand zcat \
     --genomeDir ~/new_hag/M_glutinosa_genome/star_index \
     --readFilesIn $forward_reads $reverse_reads \
     --outFileNamePrefix ~/new_hag/star_output/${output} \
     --outSAMtype BAM SortedByCoordinate
