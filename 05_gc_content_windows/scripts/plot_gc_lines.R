
library(ggplot2)
library(paletteer)

# get names of files without extension
fnames = list.files("output/", pattern = ".nuc.txt")
sample_names = gsub(".nuc.txt", "", fnames)

# read table and sort by repeat content
order_tab = read.table("input/order.txt", col.names = c("samp", "repeats"))
order_tab = order_tab[order(order_tab$repeats, decreasing = F),]


my_palette = paletteer_c("grDevices::Viridis", length(sample_names),  direction = -1)
#my_palette = paletteer_c("grDevices::Blue-Red 3", length(sample_names))


# empty
gc.df = NULL

for(samp in sample_names){
  
  # read table output of bedtools nuc
  tab = read.table(paste0("output/", samp, ".nuc.txt"), header = T, comment.char = "$")
  
  # which column has the GC content?
  gc_col = grep("pct_gc", colnames(tab))
  
  gc_values = tab[,gc_col]
  
  # Create a histogram with breaks of 0.02 (50 bins from 0 to 1)
  hist_data = hist(gc_values, breaks = seq(0, 1, by = 0.02), plot = F)
  
  # Calculate percentages for each bin
  h = (hist_data$counts / length(gc_values)) * 100
  m = hist_data$mids * 100
  
  gc.df.temp = as.data.frame(cbind(samp, m, h))
  
  gc.df = rbind(gc.df, gc.df.temp)
}

gc.df$m = as.numeric(gc.df$m)
gc.df$h = as.numeric(gc.df$h)
gc.df$samp = factor(gc.df$samp, levels = rev(order_tab$samp))



pdf("plot.pdf", width = 5.5, height = 5)
ggplot(gc.df, aes(x = m, y = h, color = samp, group = samp)) +
  geom_line() +
  theme_bw() +
  xlim(30,70) +
  scale_color_manual(values = my_palette) +
  xlab("GC content (%)") +
  ylab("Genome windows (%)") +
  #labs(title = "",
  #     x = ,
  #     y = ,
  #     color = "Isolate") +
  theme(legend.position = "right")

dev.off()


