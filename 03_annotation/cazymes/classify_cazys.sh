#! /bin/bash

# simple script to assign CAZyme classification to proteins based on the output of dbCAN
# dbCAN shows classification based on three tools. This script will keep proteins classified by at least two of them.


# main output table from dbCAN, provide as a positional argument
DBCAN=$1



# select proteins classified by at least two tools
awk '$NF>=2' $DBCAN | \
   
   # print the classification from HMMER:dbCAN. If not present, then print classification from DIAMOND
   awk '{if($3!="N") print $1"\t"$3; else print $1"\t"$5}' | \
   
   # remove parentheses present in the HMMER:dbCAN classification: these are where the domain is located in the protein sequence
   sed 's/([^)]*)//g'
