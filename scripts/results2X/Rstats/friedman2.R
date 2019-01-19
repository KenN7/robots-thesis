#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library("ggplot2")
library(tikzDevice)
#friedman


#data1 = read.csv(args[1])
#data2 = read.csv(args[2])
#data3 = read.csv(args[3])

#data1 = data1[order(data1$score),]
#data2 = data2[order(data2$score),]
#data3 = data3[order(data3$score),]
source("/home/ken/depots/robots-thesis/scripts/friedman/R/lib_posthoc.R")

friedman <- function(data1, data2, data3, suffix, title) {
  dataall <-rbind(data1, data2, data3)
  dataall$score <- dataall$score * -1
  
  
  R <- AP.SCI(score~alg+task,data=dataall,method="Ranks",test="Conover")
  #R <- AP.SCI(score~alg*task,data=dataall,method="Parametric",test="Tukey")
  
  #saving_path <- file.path(".", paste("Friedman-","tasks.jpg", sep=""))
  pdf.dim <- c(5,1.5) # width, height
  saving_path <- file.path(".", paste("Friedman-",suffix,"tasks.tex", sep=""))
  tikz(file = saving_path, width=pdf.dim[1], height=pdf.dim[2])
  #tikz(file = saving_path)
  fried_test <- ggplot(R, aes(x=y,y=algo,x)) +
    geom_point(size=2) +
    labs(x=paste("rank in ", title, sep=""), y="Design Method") +
    geom_errorbarh(aes(xmax=upper, xmin=lower,height=.2)) +
    theme_light() +
    theme(
      #       panel.border = element_blank(),
      #       panel.grid = element_blank(),
      #       panel.grid.major.y = element_line(color = "gray"),
      #       axis.line.x = element_line(color = "gray"),
      #       axis.text = element_text(face = "italic"),
      #       legend.position = "top",
      #       legend.direction = "horizontal",
      #       legend.box = "horizontal",
      #       legend.text = element_text(size = 12),
      axis.text=element_text(size=8),
      axis.title=element_text(size=9,face="bold")
    )
  
  print(fried_test)
  dev.off()
}


data11 = read.csv("scores-Beacon Aggregation.txt")
data12 = read.csv("scores3-Beacon Aggregation.txt")
data21 = read.csv("scores-Beacon Dec.txt")
data22 = read.csv("scores3-Beacon Dec.txt")
data31 = read.csv("scores-Beacon Stop.txt")
data32 = read.csv("scores3-Beacon Stop.txt")

data1 = rbind(data11, data12)
data2 = rbind(data21, data22)
data3 = rbind(data31, data32)

friedman(data1, data2, data3, "sim", "Simulation")

data11 = read.csv("scores-Beacon AggregationPR.txt")
data21 = read.csv("scores-Beacon DecPR.txt")
data31 = read.csv("scores-Beacon StopPR.txt")
data12 = read.csv("scores3-Beacon AggregationPR.txt")
data22 = read.csv("scores3-Beacon DecPR.txt")
data32 = read.csv("scores3-Beacon StopPR.txt")

data1 = rbind(data11, data12)
data2 = rbind(data21, data22)
data3 = rbind(data31, data32)

friedman(data1, data2, data3, "PR", "Pseudo-reality")

