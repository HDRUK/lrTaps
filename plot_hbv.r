library(data.table)
library(pheatmap)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)


file <- "pacbio_rep2.hbv_huh1.taps.read.CG.details.xls"
meth <- read.delim(file, sep="\t", quote ="", stringsAsFactors = FALSE)
meth <- meth[,c(1,grep("pos.*seq",colnames(meth)))]
# assign TG|CA as methylation
for(i in 2:ncol(meth)){
  meth[,i] <- gsub("pos.*:","",meth[,i])
  meth[meth[,i]=="TG" | meth[,i]=="CA", i] <- 1 
  meth[meth[,i]=="CG", i] <- 0 
  meth[meth[,i]!="0" & meth[,i]!="1",i] <- NA
  meth[,i] <- as.numeric(meth[,i])
}



meth <- meth[order(apply(meth[,2:12],1,function(x){sum(x[!is.na(x)])})),-c(grep("pos885|pos1167|pos1328|pos1376|pos1423|pos1489|pos1534|pos1849|pos1942|pos1994|pos2497|pos2696|pos2802",colnames(meth)))]
colnames(meth) <- gsub("_seq|pos","",colnames(meth))

pheatmap(meth[,-1],filename = "hbv.readmeth.pdf",cluster_rows=FALSE,cluster_cols = FALSE,show_rownames = FALSE,
         color = colorRampPalette(c("white", "salmon"))(2))
pheatmap(cor(meth[-1]),filename = "hbv.readmeth.cor.pdf",cluster_rows=FALSE,cluster_cols = FALSE,show_rownames = FALSE,
         color = colorRampPalette(c("steelblue","white", "salmon"))(100), breaks =seq(-1,1,0.02))


### only on selected regions ###


pheatmap( cor(meth[,-c(1,41:51)]),filename = "hbv.readmeth.cor.sel.pdf",cluster_rows=FALSE,cluster_cols = FALSE,show_rownames = FALSE,
         color = colorRampPalette(c("steelblue","white", "salmon"))(100), breaks =seq(-1,1,0.02))

counts <- c()
selmeth <- meth[,-c(1,41:51)]
for(i in 1:ncol(selmeth)){
  for(j in 1:ncol(selmeth)){
    n <- sum(selmeth[,i]=="1" & selmeth[,j]=="1", na.rm=TRUE)/nrow(selmeth[complete.cases(selmeth[,c(i,j)]),])
    counts <- rbind(counts,
    c(colnames(selmeth)[i], colnames(selmeth)[j], n))
  }
}
counts <- as.data.frame(counts)
colnames(counts) <- c("pos1","pos2","mC")
counts.w <- spread(counts,key=pos2,value=mC)
counts.w <- counts.w[order(as.numeric(as.character(counts.w$pos1))),
                     c(1,order(as.numeric(as.character(colnames(counts.w)[-1])))+1)]
counts.w[,-1] <- apply(counts.w[,-1],2, function(x){as.numeric(as.character(x))})
maxc <- max(as.numeric(as.character(counts$mC)))
pheatmap(counts.w[,-1],filename = "hbv.readmeth.sel.count.pdf",cluster_rows=FALSE,cluster_cols = FALSE,show_rownames = FALSE,
         color = colorRampPalette(c("white", "salmon"))(100), breaks =seq(0,maxc,maxc/100))

