#! /bin/bash

# filter PANNZER output and print in a format that is compatible with topGO for GO enrichment


# GO.out file from PANNZER
PANNZER_GO=$1


# avoid header
tail -n+2 $PANNZER_GO  | \

# get GO terms with PPV>=threshold
awk '$6>=0.4' | \

# print protein ID and GO term, tab-separated
awk '{print $1"\tGO:"$3}' | \

# make sure file is sorted by gene ID
sort -k1,1 | \

# group by protein ID, and collapse GO terms into a comma-separated list
bedtools groupby -g 1 -c 2 -o distinct | \

# just add a space after comma
sed 's/,/, /g'
