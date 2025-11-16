#!/bin/bash
csv_file=$1
#csv_file="/mnt/home/plachetzki/kcd1021/new_hag/commands/1_SRA_download/SRA_to_meta.csv"
#csv_file="/mnt/lz01/plachetzki/kcd1021/raw_reads/SRA_smol.csv"

download_sra() {
    local sample="$1"
    local srr_accession="$2"
    local dir="$3"
    sub_dir=$(echo $sample | cut -d"_" -f3)
    output_dir="/mnt/home/plachetzki/kcd1021/new_hag/raw_reads/"$dir"/"$sub_dir"/"$sample""
    mkdir -p $output_dir 
    ~/bin/sratoolkit.3.1.1/bin/fasterq-dump.3.1.1 --split-files -e 10 "$srr_accession" -O "$output_dir"
    for file in $output_dir/*_2.fastq; do
        awk '{if (NR % 4 == 1) {print $1 "/2" substr($0, index($0, " "));} else print $0;}' "$file" | gzip > ${file%.fastq}.fq.gz
    done
    for file in $output_dir/*_1.fastq; do
        awk '{if (NR % 4 == 1) {print $1 "/1" substr($0, index($0, " "));} else print $0;}' "$file" | gzip > ${file%.fastq}.fq.gz
    done
}

while IFS=' ' read -r sample srr_accession dir; do
    # Skip header row if present
    if [[ "$srr_accession" == *"SRR"* ]]; then
        download_sra $sample $srr_accession $dir 
    fi
done < "$csv_file"
