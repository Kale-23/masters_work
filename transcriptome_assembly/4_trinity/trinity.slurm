#!/bin/bash
#!/bin/bash
#SBATCH --job-name="trinity"
#SBATCH --ntasks=1 
#SBATCH --array=1-1%1
#SBATCH --cpus-per-task=24 
#SBATCH --mem=128G
#SBATCH --output=/mnt/home/plachetzki/kcd1021/new_hag/logs/trinity/trinity-%J.log
#SBATCH --exclude=node117,node118

# slurm batch script input
batch_list=/mnt/home/plachetzki/kcd1021/new_hag/commands/4_trinity/trinity_in_slurm
read_dir=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $batch_list)
species=$(basename $read_dir)
out_dir="/mnt/home/plachetzki/kcd1021/new_hag/trinity_output/"${species}"_trinity"
mkdir -p $out_dir

mem="120G"
forwards=$(find $read_dir -name "*1.P.cor.trim.fq.gz" -type f | tr '\n' ',')
reverses=$(find $read_dir -name "*2.P.cor.trim.fq.gz" -type f | tr '\n' ',')

Trinity \
    --max_memory $mem \
    --CPU 24 \
    --left $forwards \
    --right $reverses \
    --seqType fq \
    --output $out_dir
