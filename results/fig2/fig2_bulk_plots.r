library(Seurat)
library(dplyr)
library(ggplot2)

# saras obj
ST223.annotated_fate <- readRDS("/vast/projects/Sisseq/ST223/ST223.annotated_fate.rds")

# 1D RNA UMAP embedded in obj, extract
ST223.annotated_fate@meta.data$rna_umap <- ST223.annotated_fate@reductions$X1d.rna.umap@cell.embeddings[,1]

# mapping from clusters to cell type- using sara's code
cluster_map <- data.frame(
  seurat_clusters = c("0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"),
  celltype = c("primitive-RBC","Mk-ery_prog","Mk",
               "early_lymphoid_progenitor","HSC",
               "basophil-mast_progenitor","pre-cDC","Ery",
               "Mk","CDP","CD14+Monocyte","CMP-GMP",
               "Ery","Ery","Mk","unknown")
)

# merging mapped onto original obj
ST223.annotated_fate@meta.data <- ST223.annotated_fate@meta.data %>%
  left_join(cluster_map, by = c("seurat_clusters"))

# colours- picked from sara's code 
celltype_colors <- c(
  "primitive-RBC" = "#BEFD73",
  "Mk-ery_prog" = "#F7B6D2",
  "Megakayocyte" = "#E6AB02", 
  "early_lymphoid_progenitor" = "#66A61E",
  "HSC" = "#7570B3",
  "basophil-mast_progenitor" = "#A6761D",
  "pre-cDC" = "#666666",
  "Ery" = "#E7298A",
  "CDP" = "#8C564B",
  "CD14+Monocyte" = "#C49C94",
  "CMP-GMP" = "#D95F02",
  "unknown" = "#CCCCCC",
)

# Ploting Fate UMAP vs RNA UMAP
ggplot(ST223.annotated_fate@meta.data, aes(x = fate_umap, y = rna_umap, colour = celltype)) +
  geom_point(size = 1) +
  scale_colour_manual(values = celltype_colors) +
  labs(x = "Fate UMAP 1D", y = "WNN UMAP 1D", colour = "Cell Type") +
  theme_bw() +
  theme(
    text = element_text(size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.text.y = element_text(colour = "black"),
    panel.grid = element_blank()
  )
