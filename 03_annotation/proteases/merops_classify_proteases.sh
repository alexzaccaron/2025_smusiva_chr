#! /bin/bash


MEROPS=/path/to/merops/merops_scan_v12.5.lib

for FASTA in input/*fasta; do
   NAME=$(basename $FASTA | sed 's/\.fasta//g')

   awk '{print $1"\n"$2}' output/$NAME/${NAME}_merops_blast.txt | while read ID; do 
      read TOP_HIT
      grep -m1 $TOP_HIT $MEROPS | awk -v id="$ID" -v FS="#" '{print id"\t"$2}'
   done > output/$NAME/${NAME}_merops_classification.txt
done
