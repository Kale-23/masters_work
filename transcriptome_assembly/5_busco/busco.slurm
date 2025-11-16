#!/bin/bash

#SBATCH --job-name="busco"
#SBATCH --ntasks=1
#SBATCH --array=1-10%10
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G
#SBATCH --output=/mnt/home/plachetzki/kcd1021/new_hag/logs/busco/busco-%J.log
#SBATCH --exclude=node117,node118

batch_list=/mnt/home/plachetzki/kcd1021/new_hag/commands/5_busco/busco_slurm
transcriptome=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $batch_list)
file=$(basename $transcriptome)
species=${file%%.*}  
out_dir="/mnt/home/plachetzki/kcd1021/new_hag/busco_output/"
mkdir -p $out_dir
#out_plots="$out_dir"/plots
#mkdir -p $out_plots

echo working on $species
echo starting at $(date)

module purge
module load anaconda/colsa
source activate busco-5.8.3
module purge

lineage="/mnt/gpfs01/home/plachetzki/kcd1021/new_hag/commands/5_busco/busco_downloads/lineages/metazoa_odb12"
#lineage=metazoa_odb12 # closest busco lineage
output="$out_dir"/"$species"

busco \
    -l $lineage \
    -m transcriptome\
    -c 10 \
    -i $transcriptome \
    -o $output \
    --offline \
    --tar
    #--plot $out_plots \

echo done at $(date)
