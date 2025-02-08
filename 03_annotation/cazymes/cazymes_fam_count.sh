#! /bin/bash


# simple script to count number of CAZyme modules (families)


# single-colunm file with fazyme families to count
FAMS=$1


# find classification files
find output/ -name classification.txt | while read CLASSIFICATION; do

   # isolate name
   ISOLATE=$(echo $CLASSIFICATION | awk -v FS="/" '{print $2}')


   # for each family
   cat $FAMS | while read FAM; do

      # count number of domains found
      COUNT=$(grep -o -e ${FAM}$ -e ${FAM}+ -e ${FAM}_ output/${ISOLATE}/classification.txt  | wc -l)
      echo $ISOLATE$'\t'$FAM$'\t'$COUNT
   done


done
