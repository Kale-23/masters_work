#!/bin/bash
#SBATCH --job-name="maker_full"
#SBATCH --ntasks=48
#SBATCH --mem=256G
#SBATCH --output=maker-%J.log
#SBATCH --exclude=node117,node118

module purge
module load anaconda/colsa
#source activate maker_sep_repeat
#source activate maker-3.01.02
#source activate Maker-3.01.03 # capital M
source activate maker-3.01.03
#export PATH="/mnt/home/plachetzki/kcd1021/bin/maker/bin:$PATH"


base="E_stoutii_round1_gff3"
#export REPEATMASKER_LIB_DIR="/mnt/gpfs01/software/anaconda/colsa/envs/maker-3.01.02/share/RepeatMasker/Libraries"
#export LIBDIR="/mnt/gpfs01/software/anaconda/colsa/envs/maker_sep_repeat/share/RepeatMasker/Libraries"
#export LIBDIR="/mnt/home/plachetzki/kcd1021/.conda/envs/maker_sep_repeat/share/RepeatMasker/Libraries"
#export LIBDIR="/mnt/lustre/software/anaconda/colsa/envs/maker-3.01.02/local/src/RepeatMasker/Libraries"
#export REPEATMASKER_DIR="/mnt/lustre/software/anaconda/colsa/envs/maker-3.01.02/local/src/RepeatMasker/"Z
#export LIBDIR="/mnt/home/plachetzki/kcd1021/bin/RepeatMasker/Libraries"
export LIBDIR="/mnt/home/plachetzki/kcd1021/.conda/envs/maker-3.01.03/share/RepeatMasker/Libraries"

which maker
which RepeatMasker
RepeatMasker configure

mpiexec -n 48 maker \
    -base "$base" \
    round1_opts.ctl maker_bopts.ctl maker_exe.ctl  2>&1 | tee round1_run_maker_6.log
