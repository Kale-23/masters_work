#!/bin/bash
#SBATCH --job-name="eggs"
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=256G
#SBATCH --output=eggnog-%J.log
#SBATCH --exclude=node117,node118

module load anaconda/colsa
source activate eggnog-mapper-2.1.12
module purge
##export EGGNOG_DATA_DIR="/mnt/home/hcgs/shared/databses/eggnog-mapper"
export EGGNOG_DATA_DIR="/mnt/home/plachetzki/kcd1021/Genome_Annotation/braker/eggnog/"

prot_fasta="/mnt/gpfs01/home/plachetzki/kcd1021/Genome_Annotation/braker/eggnog/braker.aa"
db_name="/mnt/gpfs01/home/plachetzki/kcd1021/Genome_Annotation/braker/eggnog/eukaryote.dmnd"
gtf="/mnt/gpfs01/home/plachetzki/kcd1021/Genome_Annotation/braker/eggnog/braker.gtf"
output="E_stoutii_eggnog_pfam_2"
emapper.py \
    --cpu 48 \
    -i $prot_fasta \
    --itype proteins \
    -m diamond \
    --dmnd_db $db_name \
    --evalue 0.001 \
    --sensmode more-sensitive \
    --decorate_gff $gtf \
    --pfam_realign realign \
    -o $output 

##--dbmem \
## sensmode has 2 levels above more-sensitive
## dbmem stores db in memory, diable if needed but runs faster
## pfam_realign might be cool in denovo mode
## decorate_gff might work with gtf? idk


