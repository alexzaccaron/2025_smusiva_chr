#! /bin/bash


# custom script to find the cleavage site of secreted proteins, and output mature protein sequences without the SP.


# call it like:
#   ./get_mature_proteins.sh AB-133






# isolate name as a positional parameter
ISOLATE=$1


# first, get all secreted proteins from output tables of signalp6 and targetp2
awk '$2=="SP"' ../01signalp6/output/${ISOLATE}/prediction_results.txt > ${ISOLATE}_signalp
awk '$2=="SP"' ../03targetp2/${ISOLATE}/${ISOLATE}_summary.targetp2 > ${ISOLATE}_targetp


# now, get IDs of proteins predicted to be secreted
grep "^>" ${ISOLATE}/${ISOLATE}_peptide.fasta | tr -d '>' > ${ISOLATE}_ids


# now, let's find the cleavage site of the signal peptide. First look in signalp, then targetp results
# for each secreted protein
cat ${ISOLATE}_ids | while read ID; do

   # search ID in signalp output, if not there, search in the targetp output. It must be in either of them
   grep -m1 $ID ${ISOLATE}_signalp || grep -m1 $ID ${ISOLATE}_targetp

# do some adjustments to output just ID and clevage site. Output to a file
done | sed 's/\tSP\t.*CS pos:/\t/g; s/\-.*//g' | awk '{print $1"\t"$2+1}' > ${ISOLATE}/${ISOLATE}_cleavage_site.txt


# print regions of the protein sequences to keep, from cleavage site until the c-terminus. Using 999999 here to force until the end of all proteins.
awk '{print $1":"$2"-999999"}' ${ISOLATE}/${ISOLATE}_cleavage_site.txt | \

   # use samtools to extract the protein sequences without the SP. It will complain that proteins are truncated because the 999999. But not a problem
   samtools faidx --region-file - ${ISOLATE}/${ISOLATE}_peptide.fasta | sed 's/:.*//g' > ${ISOLATE}/${ISOLATE}_noSP_peptide.fasta


# remove temporary files
rm -f ${ISOLATE}_signalp ${ISOLATE}_targetp ${ISOLATE}_ids ${ISOLATE}/${ISOLATE}_peptide.fasta.fai
