#! /bin/bash


# script that outputs protein sequences that do not have a transmembrane domain or a GPI anchor in the mature amino acid sequences


for ISOLATE in {AB-133,BC-01,BC-06,BC-126,BC-14,MN-14,MN-5,MO-114,OH-1,ON-143,OR-1,OR-9,PA-19A,QC-157,SK-204,TN-1,WI-244,WV-2}; do

	# fasta files of secreted proteins with or without signal peptide cleaved
	FASTA_NO_SP=../05peptides/${ISOLATE}/${ISOLATE}_noSP_peptide.fasta
	FASTA_W_SP=../05peptides/${ISOLATE}/${ISOLATE}_peptide.fasta



	# fasta file of secreted proteins with no GPI anchor predicted
	GPI_FASTA=../07gpi_anchor/output/${ISOLATE}/${ISOLATE}_SP_noGPI.fasta

	# fasta file of secreted proteins with no TM domain predicted
	TMHMM_FASTA=../06tmhmm/tmhmm/output/${ISOLATE}.fasta_noSP_noTM_peptide.fasta




	# concatenate files and get seqs IDs
	cat $GPI_FASTA $TMHMM_FASTA | grep "^>" | tr -d '>' | sed 's/ .*//g' | \
	   
	   # if ID appear twice, print ID, because it means the sequence has no GPI and no TM
	   sort | uniq -c | awk '{if($1==2) print $2}' | \

	   # now, extract sequences
	   while read ID; do
	   	   echo $ID | seqtk subseq -l 60 $FASTA_NO_SP - >> input/${ISOLATE}_noGPI_noTM_noSP.fasta
	   	   echo $ID | seqtk subseq -l 60 $FASTA_NO_SP - >> input/${ISOLATE}_noGPI_noTM_SP.fasta
	   	done
done

