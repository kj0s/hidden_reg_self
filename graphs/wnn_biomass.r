library(reshape2)

line_plot <- avg.common.cell.barcodes
line_plot$barcode <- rownames(line_plot)

line_plot <- melt(line_plot,
                  id.vars=c("cluster", "umap1", "umap2", "barcode"))

line_plot$value <- log2(line_plot$value + 1)

ggplot(line_plot,
       aes(x= umap1, y=umap2, colour = value)) + 
  geom_point(size=0.5) +
  scale_colour_viridis_c()
