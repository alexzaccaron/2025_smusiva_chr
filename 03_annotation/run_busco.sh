#! /bin/bash


# run BUSCO. Here, NPROCS = number of cpus allocated with `-p` when submitting to cluster
busco -c $NPROCS -m prot -l dothideomycetes -i data/ -o busco_out


# create a folder to store summary files
mkdir summary_files


# copy summary files to summary_files
find busco_out/ -name short_summary.specific*.txt | xargs cp -t summary_files/


# call busco script to generate plot
busco-generate_plot.py -wd summary_files/


# remove folder that busco downloads
rm -rf busco_downloads/
