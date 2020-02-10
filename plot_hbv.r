library(data.table)
library(pheatmap)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)
library(fgsea)
library(GenomicRanges)


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
# meth$cgi <- apply(meth[,2:12],1,function(x){sum(x[!is.na(x)])})
# methlist <- list()
# methlist[["pos2284"]] <- meth[meth$pos2284_seq==1,1]
# methrank <- meth$cgi
# names(methrank) <- meth[,1]
# fgseaRes <- fgsea(pathways = methlist, 
#                   stats = methrank,
#                   minSize=15,
#                   maxSize=500,
#                   nperm=1000)
# write.table(meth,
#   "pacbio_rep2.hbv_huh1.taps.read.tmp",
#   sep = "\t",
#   quote = F,
#   row.names = F,
#   col.names = T
# )
# colnames(meth) <- gsub("_seq|pos","",colnames(meth))

pheatmap(meth[,-1],filename = "hbv.readmeth.pdf",cluster_rows=FALSE,cluster_cols = FALSE,show_rownames = FALSE, width=8, height=2.5, res=100,
         color = colorRampPalette(c("white", "steelblue"))(2))

cors <- c()
selmeth <- meth[,-c(1,41:51)]
for(i in 1:ncol(selmeth)){
  for(j in 1:ncol(selmeth)){
    n1 <- cor(selmeth[complete.cases(selmeth[,c(i,j)]),c(i,j)])[1,2]
    n2 <- phicoef(selmeth[complete.cases(selmeth[,c(i,j)]),i]==1, selmeth[complete.cases(selmeth[,c(i,j)]),j]==1)
    cors <- rbind(cors,
    c(colnames(selmeth)[i], colnames(selmeth)[j], n1,n2))
  }
}
cors <- as.data.frame(cors, stringAsFactor=FALSE)
colnames(cors) <- c("pos1","pos2","cor","phicoef")
cors$cor <- as.numeric(as.character(cors$cor))
cors$cor[cors$cor==1] <- 0
cors.w <- spread(cors[,-4],key=pos2,value=cor)
cors.w <- cors.w[order(as.numeric(as.character(gsub("pos|_seq","",cors.w$pos1)))),
                 c(1,order(as.numeric(as.character(gsub("pos|_seq","",colnames(cors.w))[-1])))+1)]
cors.w[,-1] <- apply(cors.w[,-1],2, function(x){as.numeric(as.character(x))})

pheatmap(cors.w[,-1],filename = "hbv.readmeth.cor.pdf",cluster_rows=FALSE,cluster_cols = FALSE,show_rownames = FALSE,
         color = colorRampPalette(c("steelblue","white", "salmon"))(100), breaks =seq(-0.65,0.65,0.013))

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

