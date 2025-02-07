
library(ggplot2)
library(pheatmap)


tab_tpm_fname = "output/05tpm/gene_tpms.txt"           # TPM values
tab_cnt_fname = "output/04featurecounts/gene_counts.txt"   # raw counts of RNAseq reads mapped to the genes
ssp_ids_fname = "data/candidate_effectors_ids.txt"         # gene IDs of candidate effectors
ssp_acc_ids_fname = "data/candidate_effectors_accessory_ids.txt"     # gene IDs of accessory genes
ssp_csep_ids_fname = "data/candidate_effectors_cloned_ids.txt"       # gene IDs of preiously cloned genes


tab_tpm = read.table(tab_tpm_fname)
tab_cnt = read.table(tab_cnt_fname)
ssp_ids = readLines(ssp_ids_fname)
ssp_acc_ids = readLines(ssp_acc_ids_fname)
ssp_csep_ids = readLines(ssp_csep_ids_fname)


# format column names by removing prefix and sufix
colnames(tab_tpm) = gsub(".Aligned.sortedByCoord.out.bam","",gsub("output.03star.", "", colnames(tab_tpm)))


# remove TPM from low read counts
tab_tpm[tab_cnt < 10] = NA


# subset candidate effector genes
tab_tpm_ssp = tab_tpm[ssp_ids,]


# select these columns. They are already ordered based on host genotype, time points, and replicates
tab_tpm_ssp = tab_tpm_ssp[,c("SRR10852271",
                             "SRR10852267",
                             "SRR10852266",
                             "SRR10852268",
                             "SRR10852265",
                             "SRR10852263",
                             "SRR10852264",
                             "SRR10852262",
                             "SRR10852261",
                             "SRR10852249",
                             "SRR10852255",
                             "SRR10852259",
                             "SRR10852254",
                             "SRR10852251",
                             "SRR10852252",
                             "SRR10852253",
                             "SRR10852256",
                             "SRR10852258",
                             "SRR10852336",
                             "SRR10852337",
                             "SRR10852339",
                             "SRR10852331",
                             "SRR10852334",
                             "SRR10852338",
                             "SRR10852333",
                             "SRR10852341",
                             "SRR10852342")]


# replace NA with 0s
tab_tpm_ssp[is.na(tab_tpm_ssp)] = 0


# remove genes for which TPM values are 0 for all samples
tab_tpm_ssp = tab_tpm_ssp[rowSums(tab_tpm_ssp) > 0, ]


# convert to matrix so it can be ploted
df_matrix <- as.matrix(tab_tpm_ssp)


# prepare annotation for rows (genes)
row_annotation = data.frame(
  Accessory = ifelse(rownames(df_matrix) %in% ssp_acc_ids, "Highlight", "Normal"),
  CSEP = ifelse(rownames(df_matrix) %in% ssp_csep_ids, "Highlight", "Normal")
)
rownames(row_annotation) = rownames(df_matrix)
ann_colors = list(
  Accessory = c(Highlight = "#56b4e9ff", Normal = "white"),
  CSEP = c(Highlight = "#f0e442ff", Normal = "white")
)




pdf('heatmap.pdf', width = 6, height = 10)
pheatmap(log10(df_matrix+1),
         scale = "none",
         cluster_rows = TRUE,
         cluster_cols = FALSE,
         show_rownames = TRUE,
         show_colnames = FALSE,
         annotation_row = row_annotation,
         annotation_colors = ann_colors,
         main = "Gene Expression Heatmap",
         color = colorRampPalette(c("navy", "white", "firebrick3"))(50),
         fontsize_row = 3,
         na_col = "black",
         angle_col = 45)

dev.off()






