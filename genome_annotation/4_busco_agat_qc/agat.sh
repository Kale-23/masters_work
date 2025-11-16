module purge
module load anaconda/colsa
source activate agat
module purge

agat_sp_statistics.pl -gff ~/Genome_Annotation/braker/braker_final.gtf > braker_final_agat_stats.txt
