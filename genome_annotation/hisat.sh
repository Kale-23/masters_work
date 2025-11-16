#! /bin/bash
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task=24 
#SBATCH --job-name="hisat2"
#SBATCH --output=hisat2-%J.log
#SBATCH --exclude=node117,node118

input_dir="/mnt/home/plachetzki/kcd1021/new_hag/raw_reads/E_stoutii"

for dir in $input_dir/Est?_*; do
    for item in $dir/*; do
        echo $item
    done
done | cut -d"_" -f1-5 | sort | uniq > hisat_slurm_input.txt

nl hisat_slurm_input.txt > hisat_numbered_input.txt
rm hisat_slurm_input.txt
mkdir -p ./logs
