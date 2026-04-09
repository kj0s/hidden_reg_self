library(dplyr)
library(ggplot2)
library(skmeans)
library(umap)

# Load data
common.cell <- read.table("ST223_common.barcodes.cell.txt", header = TRUE)

# Merge plates
Samples=unique(substr(names(common.cell[,1:80]),1,nchar(names(common.cell[,1:80]))-3))
avg=data.frame(row.names=row.names(common.cell))
new.names=vector()

for (s in Samples)
{
  e=as.data.frame(common.cell[,grep(s,names(common.cell))])
  if(ncol(e)<2)next;
  new.names=c(new.names,substr(names(e)[1],1,nchar(names(e)[1])-3))
  avg=cbind(avg,rowSums(e)/2)
}

names(avg)= new.names
avg.common.cell.barcodes= avg

# Clustering
clusters <- log2(avg.common.cell.barcodes[,1:40]+1)
clusters <- as.matrix(clusters)

clusters <- skmeans(clusters, 10)
avg.common.cell.barcodes$cluster=clusters$cluster

# UMAP
dt <- avg.common.cell.barcodes 
dt[,1:40] <- log2(dt[,1:40]+1)

u <- umap(dt[,1:40],metric="cosine", min_dist=0.3, n_neighbors=80, spread=15)

avg.common.cell.barcodes$umap1= u$layout[,1]
avg.common.cell.barcodes$umap2= u$layout[,2]

# Plot
ggplot(avg.common.cell.barcodes,
       aes(x= umap1, y=umap2, colour = as.factor(cluster))) + 
  geom_point(size=0.5)
