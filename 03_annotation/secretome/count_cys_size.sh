#! /bin/bash


# script that reads in a fasta file and outputs a 3-column table with sequences IDs, number of cysteine residues, and sequence size
# Call:
#   count_cys_size.sh fasta.file
#
# output:
#   seqID	cys_count	seq_size



FASTA=$1


# get the fasta in tabular format, make sure it's a two column table with seqID\tsequence
seqkit fx2tab $FASTA | awk '{print $1"\t"$NF}' | \
   
   # count number of cysteines (either C or c characters) with gsub in AWK, and print seqID\tcount\tseqSize
   awk 'BEGIN {FS="\t"; OFS="\t"} {seq=$NF; count=gsub(/[Cc]/, "", seq); print $1, count, length(seq)}'

