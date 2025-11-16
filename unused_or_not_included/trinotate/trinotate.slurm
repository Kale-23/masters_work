#!/bin/bash
#SBATCH --job-name="trinotate"
#SBATCH --ntasks=1 
#SBATCH --array=1-1%1
#SBATCH --cpus-per-task=24 
#SBATCH --mem=128G
#SBATCH --output=/mnt/home/plachetzki/kcd1021/new_hag/logs/trinotate/trinotate-%J.log
#SBATCH --exclude=node117,node118

# slurm batch script input
batch_list=/mnt/home/plachetzki/kcd1021/new_hag/commands/6_trinotate/trinotate_in_slurm
read_dir=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $batch_list)
species=$(basename $read_dir)
out_dir="/mnt/home/plachetzki/kcd1021/new_hag/trinotate_output/"${species}"_trinotate"
mkdir -p $out_dir

sqldata=${out_dir}/${species}.sqlite
echo sqldata = $sqldata
cp /mnt/gpfs01/home/plachetzki/kcd1021/new_hag/trinotate/database/TrinotateBoilerplate.sqlite $sqldata
trinity_files=/mnt/gpfs01/home/plachetzki/kcd1021/new_hag/trinity_output

fasta=$trinity_files/${species}_trinity.Trinity.fasta
transmap=$trinity_files/${species}_trinity.Trinity.fasta.gene_trans_map
transdecoder=$trinity_files/${species}_trinity.Trinity.fasta.transdecoder_dir/longest_orfs.pep

Trinotate --db $sqldata --init \
       --gene_trans_map $transmap \
       --transcript_fasta $fasta \
       --transdecoder_pep $transdecoder

Trinotate --db $sqldata --CPU 24 \
           --transcript_fasta $fasta \
           --transdecoder_pep $transdecoder \
           --trinotate_data_dir $TRINOTATE_DATA_DIR \
           --run ALL \
           --use_diamond
