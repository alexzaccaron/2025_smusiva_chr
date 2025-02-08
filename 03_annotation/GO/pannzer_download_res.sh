#! /bin/bash


# download output files from PANNZER webserver

# ID of the run 
ID=$1

wget \
http://ekhidna2.biocenter.helsinki.fi/barcosel/tmp//$ID/anno.out \
http://ekhidna2.biocenter.helsinki.fi/barcosel/tmp//$ID/DE.out \
http://ekhidna2.biocenter.helsinki.fi/barcosel/tmp//$ID/GO.out \
http://ekhidna2.biocenter.helsinki.fi/barcosel/tmp//$ID/log \
http://ekhidna2.biocenter.helsinki.fi/barcosel/tmp//$ID/err

