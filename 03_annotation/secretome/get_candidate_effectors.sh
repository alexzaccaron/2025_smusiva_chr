#! /bin/bash

# combine results from effectorp and protein composition

for ISOLATE in {AB-133,BC-01,BC-06,BC-126,BC-14,MN-14,MN-5,MO-114,OH-1,ON-143,OR-1,OR-9,PA-19A,QC-157,SK-204,TN-1,WI-244,WV-2}; do
	mkdir -p output/candidate_effectors/${ISOLATE}

	# get effectors predicted with effectorp and small, cysteine rich proteins
	cat \
	   <(grep -v "Non-effector" output/effectorp3/${ISOLATE}_noGPI_noTM_noSP_effectorp.txt | cut -f 1) \
	   <(awk '$3<=200 && ($2*100/$3)>=2' output/prot_size/${ISOLATE}_noGPI_noTM_noSP.txt | cut -f 1) | \
	   
	   # make the union
	   sort -u > output/candidate_effectors/${ISOLATE}/${ISOLATE}_candidate_effectors.ids

	# extract sequences
	seqtk subseq input/${ISOLATE}_noGPI_noTM_noSP.fasta output/candidate_effectors/${ISOLATE}/${ISOLATE}_candidate_effectors.ids > output/candidate_effectors/${ISOLATE}/${ISOLATE}_candidate_effectors_noSP.fasta

	seqtk subseq input/${ISOLATE}_noGPI_noTM_SP.fasta output/candidate_effectors/${ISOLATE}/${ISOLATE}_candidate_effectors.ids > output/candidate_effectors/${ISOLATE}/${ISOLATE}_candidate_effectors_SP.fasta

done


