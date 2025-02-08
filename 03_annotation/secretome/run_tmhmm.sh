#! /bin/bash


for FASTA in data/*.fasta; do
   
   NAME=$(basename $FASTA)
   tmhmm $FASTA > output/${NAME}_tmhmm_out.txt


   # get proteins without TM
   grep "Number of predicted TMHs" output/${NAME}_tmhmm_out.txt | awk '{if($NF==0) print $2}' | seqtk subseq -l 60 $FASTA - > output/${NAME}_noSP_noTM_peptide.fasta
   
   # get proteins with TM
   grep "Number of predicted TMHs" output/${NAME}_tmhmm_out.txt | awk '{if($NF>0) print $2}' | seqtk subseq -l 60 $FASTA - > output/${NAME}_noSP_TM_peptide.fasta


done

rm -rf TMHMM_*
