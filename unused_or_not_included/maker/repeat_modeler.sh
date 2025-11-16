#!/bin/bash
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task=24 
#SBATCH --job-name="RepeatModeler"
#SBATCH --output=repeat_model-%J.log
#SBATCH --exclude=node117,node118
#SBATCH --mem=128G

module purge
module load anaconda/colsa
source activate repeatmodeler-2.0.5

database="~/Genome_Annotation/repeat_modeler_2.0.5/test/E_stoutii"
#recoverDir="./RM_1504102.MonFeb241538062025"
RepeatModeler \
    -database $database \
    -threads 24 \
    -LTRStruct
