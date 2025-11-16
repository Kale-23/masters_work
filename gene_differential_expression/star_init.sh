#!/bin/bash

common="/mnt/home/plachetzki/kcd1021"
input_dir="$common"/new_hag/raw_reads/M_glutinosa
tmp_output=$(mktemp)
output_file="$common"/Genome_Annotation/M_glu/star/star_slurm_input.txt
log_dir="$common"/Genome_Annotation/M_glu/star/logs

for dir in "$input_dir"/Mgl?_*; do
    for item in "$dir"/*; do
        echo $item
    done
done | cut -d"_" -f1-5 | sort | uniq > "$tmp_output"

nl "$tmp_output" > "$output_file"
mkdir -p "$log_dir" 
