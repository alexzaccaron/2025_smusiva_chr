## Synteny

There are two versions of the synteny analysis: pairwise-based, which shows synteny between pairs of genomes, and reference-based that used a single referece genome (isolate MN-14)

### Pairwise-based

The snakefile runs the steps to obtain the pairwise synteny. It relies on `GFF` files of gene annotation and `order.txt` file that specifies the order of genomes to perform the pairwise analysis.


### Reference-based
The snakefile runs the steps to obtain the reference-based (MN-14) synteny. It follows almost the same steps as the pairwise-based synteny, with the difference that pairs will always contain the reference MN-14.