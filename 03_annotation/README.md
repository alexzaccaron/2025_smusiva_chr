## Functional annotation of genes

### BUSCO completeness
Script `run_busco.sh` was used to estimate protein completeness based on Dothideomycetes database


### GO term assignment
GO terms were assigned with [PANNZER webserver](http://ekhidna2.biocenter.helsinki.fi/sanspanz/). The script `pannzer_download_res.sh` was used to download results from the webserver. Then, the script `pannzer2go.sh` was used to parse the `GO.out` file output of PANNZER, filtering GO terms with PPV values less than 0.4 and printing in a format more 'friendly' to topGO to perform GO enrichment analysis.


### Uniprot/Swiss prot search
The script `uniprot_blast.sh` was used to blastp the proteins againt the uniprot database.


### Proteases
The script `merops_blast.sh` was used to blastp the proteins sequences against the MEROPS database. And the script `merops_classify_proteases.sh` was used to assign protease classification based on the top blastp hit.

### Secreted proteins
The snakemake scripts `Snakefile.signalp6` and `Snakefile.signalp5` were used to search for secreted proteins based on SignalP6 and SignalP5. The script `get_mature_proteins.sh` was used to find the cleavage site of secreted proteins, and output mature protein sequences without the signal peptide. The script `run_tmhmm.sh` predicted transmembrane domains in proteins with TMHMM2. Other scripts used to predict candidate effectors inclue:

* `count_cys_size.sh`: script that reads in a fasta file and outputs a 3-column table with sequences IDs, number of cysteine residues, and sequence size
* `filter_tmhmm_gpi.sh`: script that outputs protein sequences that do not have a transmembrane domain or a GPI anchor in the mature amino acid sequences
* `effectorp_commands.sh`:  print command to stdout, which can be piped to `hqsub` to submit job array.
* `get_candidate_effectors.sh`: combine results from effectorp and protein composition to produce the final set of candidate effectors.

### Transporters
The snakefile `Snakefile.tcdb` was used to search the TCDB database and assign transporter classification based on top blastp hit.

### CAZymes
There are a few scripts used to analzye CAZymes:

* `dbcan_download_res.sh`: download files from dbCAN webserver results
* `cazymes_count.sh`: count the number of major CAZyme classes
* `cazymes_fam_count.sh`: script to count number of CAZyme modules (families)
* `classify_cazys.sh`: script to assign CAZyme classification to proteins based on the output of dbCAN