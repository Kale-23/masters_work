#!/bin/bash


noseq="../maker/round1/E_stoutii_round1_gff3.maker.output/E_stoutii_no_seq.gff3"
genome="../Hagatha_EST_ONT_HiC_quad_addl.hic.p_ctg.fa"
output="E_stoutii_round1_transcripts1000.fasta"




awk -v OFS="\t" '{ if ($3 == "mRNA") print $1, $4, $5 }' $noseq | \
  awk -v OFS="\t" '{ if ($2 < 1000) print $1, "0", $3+1000; else print $1, $2-1000, $3+1000 }' | \
  bedtools getfasta -fi $genome -bed - -fo $output 

