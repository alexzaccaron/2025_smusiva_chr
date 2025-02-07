#! /bin/bash

cat sample_info.txt  | cut -f 2 | while read SRR; do
   prefetch $SRR
   fastq-dump --gzip --split-3 $SRR
done

