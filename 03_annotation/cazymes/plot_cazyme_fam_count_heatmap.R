
# Load required libraries
library(tidyverse)
library(reshape2)
library(scales)


fam_count = read.table('plots/cazyme_fam_counts.txt', sep = '\t', col.names = c("isolate", "family", "count"))


# Reshape the data
data_wide <- dcast(fam_count, family ~ isolate, value.var = "count")

# Calculate z-scores for color scaling
calculate_z_scores <- function(x) {
  (x - mean(x)) / sd(x)
}

z_scores <- as.data.frame(t(apply(data_wide[,-1], 1, calculate_z_scores)))
z_scores$family <- data_wide$family

# Melt the data for plotting
data_melted <- melt(data_wide, id.vars = "family", variable.name = "isolate", value.name = "count")

# Add z-scores to the melted data
data_melted$z_score <- melt(z_scores, id.vars = "family")$value


png("plots/cazyme_fam_counts.png", width = 6.5, height = 5, units = "in", res=300)
# Create the heatmap
ggplot(data_melted, aes(x = isolate, y = family, fill = z_score)) +
  geom_tile() +
  scale_fill_gradient2(low = "purple", mid = "white", high = "green", midpoint = 0) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title = element_text(face = "bold"),
        plot.title = element_text(hjust = 0.5, face = "bold")) +
  labs(title = "Heatmap CAZyme domains count",
       x = "Isolate",
       y = "CAZyme family",
       fill = "Z-Score") +
  geom_text(aes(label = count), color = "black", size = 3)

dev.off()

