#! /bin/bash

# print command to stdout, which can be piped to hqsub to submit job array

EFFECTORP=/nfs7/BPP/Weisberg_Lab/lab_members/zaccaron/programs/EffectorP-3.0/EffectorP.py

for FASTA in input/*.fasta; do
	NAME=$(basename $FASTA | sed 's/\.fasta.*//g')
	echo python $EFFECTORP -i $FASTA -o output/effectorp3/${NAME}_effectorp.txt
done