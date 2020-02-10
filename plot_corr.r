setwd("/users/ludwig/cfo155/cfo155/longReads/processed")
library(ggplot2)
selcolor <- c("#CB962B","#48A1D9")
##### the one with gap #####
methFiles <- list.files(pattern = "*rep2*.mESC_chr11.*stat.txt$")
cors <- NULL
for(i in 1:length(methFiles)){
  methFile <- methFiles[i]
  dat <- read.table(methFile, header=T)
  dat$ratio_wgbs <- apply(dat[,c(4,5)],1,function(x){ifelse(x[2]>0,x[1]/x[2],0)})
  dat$ratio_taps <- apply(dat[,c(6,7)],1,function(x){ifelse(x[2]>0,x[1]/x[2],0)})
  head(dat)
  dat$cov_wgbs <- cut(dat$aC_wgbs, breaks=c(-Inf,8,+Inf))
  dat$cov_taps <- cut(dat$aC_taps, breaks=c(-Inf,8,+Inf))
  cors <- c(cors, round(cor(dat[dat$aC_taps>8,c(3,9)])[2,1],3))
  # p2 <- ggplot(dat[dat$aC_taps>10, c(3,9,11)],
  #              aes(x=ratio_taps,y=longread, color=factor(cov_taps))) +
  #   geom_point() + 
  #   xlim(0,1) +
  #   ylim(0,1) +
  #   theme_minimal() +
  #   xlab("TAPS") +
  #   ylab("longreads-TAPS")+
  #   scale_color_manual(values = selcolor[i]) +
  #   theme(
  #     strip.text.x = element_text(size = 18, color = "black"),
  #     text = element_text(size = 18),
  #     axis.ticks.y = element_line(colour = "black", size = 0.8),
  #     axis.ticks.x = element_line(colour = "black", size = 0.8),
  #     legend.position = "none") +
  #   geom_text(x=0.1, y=1, label=round(cor(dat[dat$aC_taps>8,c(3,9)])[2,1],3), color="black",size=6)
  # ggsave(paste0(methFile,".taps.pdf"),p2, width = 4, height = 4)
}

for(n in c(2,4,6,8,10,12,14)){
  cors<- c()
  for(i in 1:length(methFiles)){
  methFile <- methFiles[i]
  dat <- read.table(methFile, header=T)
  dat$ratio_wgbs <- apply(dat[,c(4,5)],1,function(x){ifelse(x[2]>0,x[1]/x[2],0)})
  dat$ratio_taps <- apply(dat[,c(6,7)],1,function(x){ifelse(x[2]>0,x[1]/x[2],0)})
  dat$cov_wgbs <- cut(dat$aC_wgbs, breaks=c(-Inf,8,+Inf))
  dat$cov_taps <- cut(dat$aC_taps, breaks=c(-Inf,8,+Inf))
  cors <- c(n,cors, round(cor(dat[dat$aC_taps>n,c(3,9)])[2,1],3), nrow(dat[dat$aC_taps>n,c(3,9)]))
  print(cors)
}
}
