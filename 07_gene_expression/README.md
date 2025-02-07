## Gene expression

### Download data from NCBI SRR
The script `download.sh` runs a `for` loop to download reads based on their SRR accession number present in the `sample_info.txt` file.

### Estimating TPM values
The `Snakefile` runs the pipeline. Basically, it uses `seal.sh` to split reads based on the *S. musiva* and *P. trichocarpa* genomes (they are not provided here). Reads that matched to *S. musiva* genome are further trimmed with `bbdusk.sh`, and mapped using `STAR`. Then, `featureCounts` is used to count reads mapped to the genes. The raw counts are parsed, and then given to the script `calculate_tpm.R` to estimate TPM values.