## Quality control
The script `Snakefile.QC` has the rules used to call NanoPlot and chopper to perform quality control of the nanopore reads

## Assemblies
* The script `Snakefile.canu` has the rule used to call Canu to assemble the reads. Note that it takes as input `assembler_input_canu.tsv`, which is a is a 3-column table with sample name, estimated genome size, and fastq files to assemble.