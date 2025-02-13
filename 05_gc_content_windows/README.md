## GC content analysis
This analysis was done to compare the distribution of GC content among genome. To do so, the genomes are split into sliding windows of 10 kb, and the GC content of windows are calculated. A line plot is generated with the R script `plot_gc_lines.R` that shows the percentage of windows (y-axis) with the respective GC content (x-axis)

The snakefile runs the pipeline. 