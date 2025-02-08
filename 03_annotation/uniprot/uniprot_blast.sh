#! /bin/bash


UNIPROT=/path/to/swissprot/uniprot_sprot_20241103.fasta

for FASTA in input/*fasta; do
   NAME=$(basename $FASTA | sed 's/\.fasta//g')

   mkdir -p output/$NAME/
   echo "blastp -num_threads 4 -query $FASTA -db $UNIPROT -outfmt 6 -max_target_seqs 1 -max_hsps 1 -evalue 1e-10 > output/$NAME/${NAME}_uniprot_blast.txt"
done
