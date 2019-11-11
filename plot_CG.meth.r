#!/usr/bin/env Rscript

options(scipen = 999)
library(ggplot2)
library(tidyverse)
library(dplyr)

##### on chr11 #####
files <- list.files(pattern="*.mESC.*chr11.CG.meth.xls")
meth <- data.frame()
for(i in files){
    tmp <- read_delim(i, delim="\t")
    tmp$smp <- i
    meth <- rbind(meth, tmp)
}

meth.w <- spread(meth[,c(1,2,10)],key=smp,value=mods)
p <- ggplot(meth, aes(x = pos, y = mods, color = smp)) +
    geom_bar(stat="identity") +
    facet_wrap(~smp,ncol=1) +
    theme_minimal() +
    ylab("meth") +
    theme(legend.position="none")
ggsave(
  paste0("chr11.meth.pdf"),
  p,
  width = 15,
  height = 8 ,
  dpi = 300
)

##### on chr13 #####
files <- list.files(pattern="*.mESC.*chr13.CG.meth.xls")
meth <- data.frame()
for(i in files){
    tmp <- read_delim(i, delim="\t")
    tmp$smp <- i
    meth <- rbind(meth, tmp)
}

meth.w <- spread(meth[,c(1,2,10)],key=smp,value=mods)

p <- ggplot(selmeth, aes(x = pos, y = mods, color = smp)) +
    geom_bar(stat="identity") +
    facet_wrap(~smp,ncol=1) +
    theme_minimal() +
    ylab("meth") +
    theme(legend.position="none")
ggsave(
  paste0("chr13.meth.pdf"),
  p,
  width = 15,
  height = 5 ,
  dpi = 300
)


meth.w <- spread(meth[,c(1,2,10)],key=smp,value=mods)
selmeth <- meth.w[,c(1,3,5)] %>% as.data.frame()

p <- ggplot(selmeth, aes(x = selmeth[,2], y = selmeth[,3])) +
    geom_point(color="#F0C415") +
    theme_minimal() +
    ylab("SMRT-TAPS") +
    xlab("Nano-TAPS") +
    theme(legend.position="none")
ggsave(
  paste0("chr13.meth.cor.pdf"),
  p,
  width = 3,
  height = 3 ,
  dpi = 300
)

cor(selmeth[,2],selmeth[,3])
##### hbv #####
files <- list.files(pattern="*.hbv.*taps.CG.meth.xls")
meth <- data.frame()
for(i in files){
    tmp <- read_delim(i, delim="\t")
    tmp$smp <- i
    meth <- rbind(meth, tmp)
}

selmeth <- meth[(meth$fwdmC+1)/(meth$revmC+1)>0.25 & (meth$fwdmC+1)/(meth$revmC+1)<4 & meth$varratio <0.2, ]

meth.w <- spread(selmeth[,c(1,2,10)],key=smp,value=mods)
p <- ggplot(selmeth, aes(x = pos, y = mods, color = smp)) +
    geom_bar(stat="identity") +
    facet_wrap(~smp,ncol=1) +
    theme_minimal() +
    ylab("meth") +
    theme(legend.position="none")
ggsave(
  paste0("hbv.meth.pdf"),
  p,
  width = 15,
  height = 12 ,
  dpi = 300
)
selmeth <- selmeth[grep("hbv_huh1.taps",selmeth$smp),]
p <- ggplot(selmeth, aes(x = pos, y = mods, color = smp)) +
    geom_bar(stat="identity") +
    facet_wrap(~smp,ncol=1) +
    theme_minimal() +
    ylab("meth") +
    scale_color_manual(values=c("#046699","#EFC319"))+
    theme(legend.position="none") +
    xlim(0,3248)
ggsave(
  paste0("hbv.meth.huh1_taps.pdf"),
  p,
  width = 15,
  height = 3 ,
  dpi = 300
)
##### lambda #####
files <- list.files(pattern="*.lambda.*taps.CG.meth.xls")
meth <- data.frame()
for(i in files){
    tmp <- read_delim(i, delim="\t")
    tmp$smp <- i
    meth <- rbind(meth, tmp)
}


meth.w <- spread(meth[,c(1,2,10)],key=smp,value=mods)
p <- ggplot(meth, aes(x = pos, y = mods, color = smp)) +
    geom_bar(stat="identity") +
    facet_wrap(~smp,ncol=1) +
    theme_minimal() +
    ylab("meth") +
    theme(legend.position="none")
ggsave(
  paste0("lambda.meth.pdf"),
  p,
  width = 15,
  height = 5 ,
  dpi = 300
)

##### 4kb #####
files <- list.files(pattern="*.4kb.*.CG.meth.xls")
meth <- data.frame()
for(i in files){
    tmp <- read_delim(i, delim="\t")
    tmp$smp <- i
    meth <- rbind(meth, tmp)
}

meth.w <- spread(meth[,c(1,2,10)],key=smp,value=mods)
p <- ggplot(meth, aes(x = pos, y = mods, color = smp)) +
    geom_bar(stat="identity") +
    facet_wrap(~smp,ncol=1) +
    theme_minimal() +
    ylab("meth") +
    theme(legend.position="none")
ggsave(
  paste0("4kb.meth.pdf"),
  p,
  width = 15,
  height = 5 ,
  dpi = 300
)
