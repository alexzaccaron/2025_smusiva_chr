
## Gene preditions

### 1. Repeat masking
Prior to gene prediction, genome assembies were softmasked using RepeatModeler and RepeatMasker. In the code snippet bellow, `SAMPLE` is the isolate name.

```
BuildDatabase -name $SAMPLE ${SAMPLE}.fasta; RepeatModeler -database $SAMPLE -threads $NPROCS -LTRStruct
RepeatMasker -xsmall -lib ${SAMPLE}-families.fa -gff -s -a -pa $NPROCS ${SAMPLE}.fasta
```


### 2. BRAKER3
Gene predictions were performed with braker3, with protein database in a fully automated pipeline to train and predict highly reliable genes with GeneMark-ETP and AUGUSTUS. The protein database is from  reference sequences of 54 annotated genomes retriveied on NCBI in Dothideomycetes representative around 1.7 million of proteins.

commands used:

```
singularity exec --bind braker3.sif braker.pl --threads 16 --gff3 --species=S_musiva --fungus --useexisting --genome=<isolate>.fasta.masked --prot_seq=prot_seq.faa --AUGUSTUS_CONFIG_PATH=/home/alexandre/Augustus/config
```

```
selectSupportedSubsets.py --fullSupport <isolate>_fullsupp.gff --anySupport <isolate>_anysupp.gff --noSupport <isolate>_nosupp.gff <isolate>_braker.gtf hintsfile.gff
```


### 3. Liftoff
To complement the predictions obtained with BRAKER, gene models from the previous reference genome SO2202 were mapped to assemblies using liftoff. This was done using the following Snakemake file:

```
# genome assemblies in data/
SAMPLES,=glob_wildcards("data/{sample}.fasta")


rule all:
   input:
      expand("output/{sample}.gff_polished", sample=SAMPLES)


##liftoff: call liftoff to map gene models from one genome to another
rule liftoff:
   input:
      ref="data/GCF_000320565.1_Septoria_musiva_SO2202_v1.0_genomic.fna",    # previous S. musiva SO2202 genome from NCBI
      gff="data/GCF_000320565.1_Septoria_musiva_SO2202_v1.0_genomic.gff",    # previous S. musiva SO2202 genome from NCBI
      target="data/{sample}.fasta"                                           # new assembly to map gene models
   output:
      gff="output/{sample}.gff",                           # gene models mapped to new assembly
      gff_polish="output/{sample}.gff_polished",           # gene models mapped to new assembly (polished by liftoff)
      unmapped="output/{sample}_unmapped.txt"              # gene models that failed to map
   log:
      "logs/{sample}.log"
   shell: """


      liftoff \
         -g {input.gff} \
         -o {output.gff} \
         -copies \
         -sc 0.90 \
         -u {output.unmapped} \
         -dir intermediate_files_{wildcards.sample} \
         -exclude_partial \
         -polish {input.target} {input.ref} > {log} 2>&1

       rm -rf intermediate_files_{wildcards.sample}
   """
```


### 4. Combine gene models

To combine gene models from BRAKER3 and liftoff, 

Gene models from liftoff that did not overlap with those predicted by BRAKER3 were identified. This was done using BEDtools overlap to perform a reverse overlapping of gene models from liftoff and gene models from BRAKER3. The following Snakemake file was used:

```


SAMPLES,=glob_wildcards("data/{sample}_braker.gff3")


rule all:
   input:
      expand("output/{sample}_new_models.gff", sample=SAMPLES)




##get_non_overlaping_models: find gene models that do not overlap with current BRAKER models
# some explanation, line-by-line:
# 	get mRNA features from gene models mapped
# 	get mRNA features that do not overlap with any features from BRAKER
# 	select mRNA that have a "valid_ORF" flag, meaning it encodes a protein
# 	get rid of mRNA features with inframe_stop_codon
# 	get column 9
# 	both sed commnads will get rid of flags, keeping only mRNA ids and their parent genes
# 	grep mRNA ids and their parent gene ids in the liftoff output to get all exons/cds features
rule get_non_overlaping_models:
   input:
      liftoff="data/{sample}.gff_polished",
      braker="data/{sample}_braker.gff3"
   output:
      "output/{sample}_new_models.gff"
   shell: """
      awk '$3=="mRNA"' {input.liftoff} | \
         bedtools intersect -v -a - -b {input.braker} | \
         grep "valid_ORF=" | \
         grep -v inframe_stop_codon | \
         cut -f 9 | \
         sed 's/;Parent=/\\n/g' | sed 's/;.*//g; s/ID=//g' | \
         grep -wf - {input.liftoff} > {output}
```


### 4. Merge gene models

Once the new gene model were identified, they were merged with the genes predicted with BRAKER3 using AGAT:

```

SAMPLES,=glob_wildcards("data/{sample}_braker.gff3")



rule all:
   input:
      expand("output/{sample}_merged.gff", sample=SAMPLES)



rule merge_annotations:
   input:
      braker="data/{sample}_braker.gff3",
      liftoff="data/{sample}_new_models.gff"
   output:
      "output/{sample}_merged.gff"
   log:
      "logs/{sample}.log"
   shell: """
      agat_sp_merge_annotations.pl --gff {input.braker} --gff {input.liftoff} --out {output} > {log} 2>&1
   """
```

### 5. Filtering gene models

Filter alternative isoforms and genes overlapping repetitive DNA

The current gene models predicted with BRAKER has many cases of alternative splicing, which is not the focus in out study, and therefore can be removed. Also, it is considered good practice to remove gene models that are likely repeats (tranposable elements). Thus, this filtering is to remove alternative isoforms of the alternative splicing genes and remove gene models overlapping with repetitive DNA.

To do so, I use the script agat_sp_keep_longest_isoform.pl to keep the longest isoform per gene, and bedtools intersect to find and the remove genes overlapping with repeats


Alternative trancripts were filtered with the script agat_sp_keep_longest_isoform.pl from AGAT v1.4.1. Genes models with more than 50% overlap with repetitive DNA, predicted with RepeatModeler and RepeatMasker, were identified with the module intersect from BEDtools v2.31.1 and then removed.

Snakemake used:

```

SAMPLES,=glob_wildcards("data/{sample}_merged.gff")



rule all:
   input:
      expand("output/03filt_gffs/{sample}_merged_long_isoform_filt.gff", sample=SAMPLES),


##filt_isoforms: filter out alternative isoforms, keeping only longest isoform
rule filt_isoforms:
   input:
      "data/{sample}_merged.gff"
   output:
      "output/01isoform_filt/{sample}_merged_long_isoform.gff"
   log:
      "logs/agat_sp_keep_longest_isoform/{sample}.log"
   shell: """
      agat_sp_keep_longest_isoform.pl --gff {input} --output {output} > {log} 2>&1
   """



##get_gene_reepat_cov: get how much % gene regions overlap with repetitive DNA
rule get_gene_reepat_cov:
   input:
      genes="output/01isoform_filt/{sample}_merged_long_isoform.gff",
      repeats="data/{sample}.fasta.out.gff"
   output:
      "output/02genes_repeat_coverage/{sample}_merged_long_isoform_repeat_coverage.gff"
   shell: """
      awk '$3=="gene"' {input.genes} | bedtools coverage -a - -b {input.repeats} > {output}
   """




##get_genes_to_remove: make a list of genes to remove
rule get_genes_to_remove:
   input:
      "output/02genes_repeat_coverage/{sample}_merged_long_isoform_repeat_coverage.gff"
   output:
      "output/02genes_repeat_coverage/{sample}_kill_list.txt"
   shell: """
      awk '$NF>0.5' {input} | cut -f 9 | sed 's/ID=//g; s/;.*//g' > {output}
   """



##remove_genes_from_gff: remove genes and their children features based on a kill list
rule remove_genes_from_gff:
   input:
      gff="output/01isoform_filt/{sample}_merged_long_isoform.gff",
      kill="output/02genes_repeat_coverage/{sample}_kill_list.txt"
   output:
      "output/03filt_gffs/{sample}_merged_long_isoform_filt.gff"
   log:
      "logs/agat_sp_filter_feature_from_kill_list/{sample}_agat_kill.log"
   shell: """
      agat_sp_filter_feature_from_kill_list.pl \
         --gff {input.gff} \
         --kill_list {input.kill} \
         --type gene \
         --output {output} > {log} 2>&1
   """
```

### 6. Filtering gene models inframestop codon

Remove gene models with premature stop codon (pseudogenized)


Many gene models from the previous S. musiva SO2202 reference genome that were mapped to the new assemblies have inframe stop codon. This is strange, because I thought I had avoided them during the mapping. Anyway, lots of them are present, and they will be removed from the GFF files.


By extracting the encoded protein sequences, premature stop codons will result in a '\*' within the sequence. After trimming the last stop (final codon), any '\*' within the sequence indicate premature stop.


Protein sequences were extracted with the script agat_sp_extract_sequences.pl from AGAT v1.4.1 with parameter --cfs to trim the final stop codon. Sequences containing a '*' were found with grep searches, and the corresponding gene IDs of the sequences found were retried and given to the script agat_sp_filter_feature_from_kill_list.pl from AGAT to remove them from the annotation files.

```


SAMPLES,=glob_wildcards("data/{sample}_merged_long_isoform_filt.gff")



rule all:
   input:
      expand("output/02filt_gffs/{sample}_merged_long_isoform_filt.gff", sample=SAMPLES)





##get_protein_sequences: extract protein sequences from GFF
# make sure that the final stop '*' is trimmed. Thus, any '*' in the sequence means inframe stop
rule get_protein_sequences:
   input:
      gff="data/{sample}_merged_long_isoform_filt.gff",
      fasta="data/{sample}.fasta"
   output:
      "output/01pro_seqs/{sample}_merged_long_isoform_filt_aa.fasta"
   log:
      "logs/agat_sp_extract_protein/{sample}.log"
   shell: """

      eval "$(/nfs7/BPP/Weisberg_Lab/lab_members/zaccaron/miniforge3/condabin/conda shell.bash hook)"
      conda activate agat

      agat_sp_extract_sequences.pl \
         -g {input.gff} \
         -f {input.fasta} \
         --protein \
         --output {output} \
         --clean_final_stop > {log} 2>&1
   """






##get_geneIDs_prem_stop: get gene IDs with premature stop codon
rule get_geneIDs_prem_stop:
   input:
      "output/01pro_seqs/{sample}_merged_long_isoform_filt_aa.fasta"
   output:
      "output/01pro_seqs/{sample}_merged_long_isoform_filt_prem_stop.txt"
   shell: """
      seqtk seq {input} | \
         grep "\*" -B 1 | \
         grep "^>"      | \
         sed 's/.*gene=//g; s/ .*//g' > {output}
   """







##remove_genes_from_gff: remove genes and their children features based on a kill list
rule remove_genes_from_gff:
   input:
      gff="data/{sample}_merged_long_isoform_filt.gff",
      kill="output/01pro_seqs/{sample}_merged_long_isoform_filt_prem_stop.txt"
   output:
      "output/02filt_gffs/{sample}_merged_long_isoform_filt.gff"
   log:
      "logs/agat_sp_filter_feature_from_kill_list/{sample}_agat_kill.log"
   shell: """

      eval "$(/nfs7/BPP/Weisberg_Lab/lab_members/zaccaron/miniforge3/condabin/conda shell.bash hook)"
      conda activate agat

      agat_sp_filter_feature_from_kill_list.pl \
         --gff {input.gff} \
         --kill_list {input.kill} \
         --type gene \
         --output {output} > {log} 2>&1
   """
```

