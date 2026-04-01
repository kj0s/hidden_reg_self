## Inputs
We combine three independent layers: 
1. RNA, in a seurat object, which tells us the cell state.
2. HTO/ SNP donor IDs that tell you the sample identity
3. SPLINTR/lineage barcodes that tell you h=the lineage identity.

## Methodology

the data follows the pipeline:
NormalizeData → FindVariableFeatures → ScaleData → RunPCA 
FindNeighbors → FindClusters → RunUMAP

this creates a feature space ( based on gene eexpression), a graph (connected by similarity), and clusters ( groups of similar cells). 

each cluster is a transcriptional state. and each state is a cell fate (proxy).

we remove any low quality cells, ambiguous assignments, and unwanted donors.
we then asign donor identites to the cells so each one has a biological origin. 

the cell (RNA) and barcode (lineage tag) are then linked. after, we can link barcodes to patient identity into one table. 

## Results
one table showing:
cell
 ├── RNA expression (state)
 ├── cluster (state group)
 ├── donor (sample origin)
 └── barcode (lineage identity)

 # Cell Fate
 we find the 'fates' of cells using clustering aka they're grouped by EXPRESSION. this is _phenotypic fate_. 

 we also measure the fate from barcodes aka lineage fate; from shared barcodes across plates/patients and percentage per plate. this aims to measure:
 1. does a lineage persist?
 2. does it expand?
 3. where does it appear?
this is _lineage fate_.

## finding cell fates
for each barcode, 
find all cells with this barcode{
→ look at their clusters
→ look at their donor identity
→ look at their distribution across plates
}
