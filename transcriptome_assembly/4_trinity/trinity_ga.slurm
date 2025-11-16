#!/bin/bash
#!/bin/bash
#SBATCH --job-name="trinity"
#SBATCH --ntasks=1 
#SBATCH --array=1-12%12
#SBATCH --cpus-per-task=24 
#SBATCH --mem=128G
#SBATCH --output=/mnt/home/plachetzki/kcd1021/new_hag/logs/trinity/trinity-%J.log
#SBATCH --exclude=node117,node118

# slurm batch script input
batch_list=/mnt/home/plachetzki/kcd1021/new_hag/commands/4_trinity/trinity_in_slurm
read_dir=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $batch_list)
species=$(basename $read_dir)
out_dir="/mnt/home/plachetzki/kcd1021/new_hag/trinity_output/"${species}"_trinity_ga"
mkdir -p $out_dir

star_bam="/mnt/home/plachetzki/kcd1021/new_hag/star_output/"${species}"_concat_sorted.bam"
mem="120G"

Trinity \
    --genome_guided_bam $star_bam \
    --genome_guided_max_intron 10000 \
    --max_memory $mem \
    --CPU 24 \
    --output $out_dir
