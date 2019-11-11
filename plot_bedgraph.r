#!/usr/bin/env Rscript

options(scipen = 999)
library(ggplot2)
library(tidyverse)

##### on chr11 #####
files <- list.files(pattern="*.mESC.*chr11.bedgraph")
meth <- data.frame()
for(i in files){
    tmp <- read_delim(i, delim="\t")
    colnames(tmp) <- c("chr", "start","end","meth")
    tmp$smp <- gsub("-","_",i)
    meth <- rbind(meth, tmp)
}

meth.w <- spread(meth,key=smp,value=meth)
p <- ggplot(meth, aes(x = start, y = meth, color = smp)) +
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
files <- list.files(pattern="*.mESC.*chr13.bedgraph")
meth <- data.frame()
for(i in files){
    tmp <- read_delim(i, delim="\t")
    colnames(tmp) <- c("chr", "start","end","meth")
    tmp$smp <- gsub("-","_",i)
    meth <- rbind(meth, tmp)
}

meth.w <- spread(meth,key=smp,value=meth)
p <- ggplot(meth, aes(x = start, y = meth, color = smp)) +
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

##### hbv #####
files <- list.files(pattern="*.hbv.*taps.bedgraph")
meth <- data.frame()
for(i in files){
    tmp <- read_delim(i, delim="\t")
    colnames(tmp) <- c("chr", "start","end","meth")
    tmp$smp <- gsub("-","_",i)
    meth <- rbind(meth, tmp)
}

meth.w <- spread(meth,key=smp,value=meth)
p <- ggplot(meth, aes(x = start, y = meth, color = smp)) +
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

##### lambda #####
files <- list.files(pattern="*.lambda.*taps.bedgraph")
meth <- data.frame()
for(i in files){
    tmp <- read_delim(i, delim="\t")
    colnames(tmp) <- c("chr", "start","end","meth")
    tmp$smp <- gsub("-","_",i)
    meth <- rbind(meth, tmp)
}

meth.w <- spread(meth,key=smp,value=meth)
p <- ggplot(meth, aes(x = start, y = meth, color = smp)) +
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

##### lambda insertion #####
files <- list.files(pattern="*.lambda.*mpileups.insertion.bedgraph")
meth <- data.frame()
for(i in files){
    tmp <- read_delim(i, delim="\t")
    colnames(tmp) <- c("chr", "start","end","meth")
    tmp$smp <- gsub("-","_",i)
    meth <- rbind(meth, tmp)
}

meth.w <- spread(meth,key=smp,value=meth)
p <- ggplot(meth, aes(x = start, y = meth, color = smp)) +
    geom_bar(stat="identity") +
    facet_wrap(~smp,ncol=1) +
    theme_minimal() +
    ylab("meth") +
    theme(legend.position="none")
ggsave(
  paste0("lambda.insertion.pdf"),
  p,
  width = 15,
  height = 5 ,
  dpi = 300
)

##### 4kb insertion #####
files <- list.files(pattern="*.4kb.*mpileups.insertion.bedgraph")
meth <- data.frame()
for(i in files){
    tmp <- read_delim(i, delim="\t")
    colnames(tmp) <- c("chr", "start","end","meth")
    tmp$smp <- gsub("-","_",i)
    meth <- rbind(meth, tmp)
}

meth.w <- spread(meth,key=smp,value=meth)
p <- ggplot(meth, aes(x = start, y = meth, color = smp)) +
    geom_bar(stat="identity") +
    facet_wrap(~smp,ncol=1) +
    theme_minimal() +
    ylab("meth") +
    theme(legend.position="none")
ggsave(
  paste0("4kb.insertion.pdf"),
  p,
  width = 15,
  height = 8 ,
  dpi = 300
)
