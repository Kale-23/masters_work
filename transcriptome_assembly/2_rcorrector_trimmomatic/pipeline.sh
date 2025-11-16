#!/bin/bash

#SBATCH --job-name=rcorr_trim
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
##SBATCH --mem=256G
#SBATCH --array=1-2%2
#SBATCH --output=/mnt/home/plachetzki/kcd1021/new_hag/logs/trimming/rcorr_trimmomatic_%j.out
#SBATCH --exclude=node\[117-118\]

# slurm batch script input
batch_list="/mnt/home/plachetzki/kcd1021/new_hag/commands/2_rcorrector_trimmomatic/pipeline_in_slurm_redo"
dir_in=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $batch_list)
echo $dir_in

#setup
echo setup for files in $(basename $dir_in): $(date)
tmpdir=${dir_in}/tmp
mkdir -p $tmpdir
in_forward=$(find "$dir_in" -name "*1.fq.gz" -maxdepth 1 -type f)
in_reverse=$(find "$dir_in" -name "*2.fq.gz" -maxdepth 1 -type f)
echo running rcorrector: $(date)

run_rcorrector.pl \
    -1 $in_forward \
    -2 $in_reverse \
    -od $dir_in \
    -t 24 &&
rm $in_forward &&
rm $in_reverse
rmdir --ignore-fail-on-non-empty $tmpdir

echo running trimmomatic: $(date)
#setup inputs and outputs
trim_in_f=${in_forward%%.fq.gz}.cor.fq.gz
trim_in_r=${in_reverse%%.fq.gz}.cor.fq.gz
trim_out_f_p=${trim_in_f%%.cor.fq.gz}.P.cor.trim.fq.gz
trim_out_f_u=${trim_in_f%%.cor.fq.gz}.U.cor.trim.fq.gz
trim_out_r_p=${trim_in_r%%.cor.fq.gz}.P.cor.trim.fq.gz
trim_out_r_u=${trim_in_r%%.cor.fq.gz}.U.cor.trim.fq.gz

trimmomatic PE \
    $trim_in_f $trim_in_r \
    $trim_out_f_p $trim_out_f_u \
    $trim_out_r_p $trim_out_r_u \
    -threads 24 \
    ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 \
    SLIDINGWINDOW:4:5 LEADING:5 TRAILING:5 MINLEN:25

echo finished: $(date)
