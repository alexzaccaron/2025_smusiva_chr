#! /bin/bash


MEROPS=/path/to/merops/merops_scan_v12.5.lib

for FASTA in input/*fasta; do
   NAME=$(basename $FASTA | sed 's/\.fasta//g')

   mkdir -p output/$NAME/
   echo "blastp -query $FASTA -db $MEROPS -outfmt 6 -max_target_seqs 1 -max_hsps 1 -evalue 1e-10 > output/$NAME/${NAME}_merops_blast.txt"

done
