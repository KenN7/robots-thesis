#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library("ggplot2")
library(tikzDevice)
#friedman

data1 = read.csv("real-scores-aggregation.txt")
data2 = read.csv("real-scores-deci.txt")
data3 = read.csv("real-scores-stop.txt")
#data1 = read.csv(args[1])
#data2 = read.csv(args[2])
#data3 = read.csv(args[3])

#data1 = data1[order(data1$score),]
#data2 = data2[order(data2$score),]
#data3 = data3[order(data3$score),]

source("/home/ken/depots/robots-thesis/scripts/friedman/R/lib_posthoc.R")


dataall <-rbind(data1, data2, data3)
dataall$score <- dataall$score * -1


R <- AP.SCI(score~alg+task,data=dataall,method="Ranks",test="Conover")
#R <- AP.SCI(score~alg*task,data=dataall,method="Parametric",test="Tukey")

#saving_path <- file.path(".", paste("Friedman-","tasks.jpg", sep=""))
pdf.dim <- c(5,1.5) # width, height
saving_path <- file.path(".", paste("Friedman-","tasks.tex", sep=""))
tikz(file = saving_path, width=pdf.dim[1], height=pdf.dim[2])
#tikz(file = saving_path)
fried_test <- ggplot(R, aes(x=y,y=algo,x)) +
  geom_point(size=2) +
  labs(x="rank", y="Design Method") +
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

