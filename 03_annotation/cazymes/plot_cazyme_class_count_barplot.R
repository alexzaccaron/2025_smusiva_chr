library(ggplot2)
library(paletteer)


dbcan = read.table('plots/cazyme_class_count.txt', sep = '\t', col.names = c("isolate", "class", "count"))



png("plots/cazyme_class_count.png", width = 6.5 , height = 5, units = "in", res=300)
ggplot(dbcan, aes(x = isolate, y = count, fill = class)) + 
  geom_bar(stat = "identity") +
  scale_fill_manual(values = paletteer_d("ggsci::default_locuszoom")) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title = element_text(face = "bold"),
        plot.title = element_text(hjust = 0.5, face = "bold")) +
  labs(title = "Number of genes from main CAZyme classes",
       x = "Isolate",
       y = "Count",
       fill = "Class")

dev.off()
