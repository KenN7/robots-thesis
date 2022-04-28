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
  
  dataall <- dataall[dataall$alg != 'EvoCom3XPR' & dataall$alg != 'EvoCom2XPR' & dataall$alg != 'EvoCom3X' & dataall$alg != 'EvoCom2X',]
  
  names <- c("EvoCom2PR", "EvoCom3PR", "Gianduja2PR", "Gianduja2EPR", "Gianduja3PR", "Gianduja3EPR")
  if (suffix == "PR") {
    dataall <- dataall[sapply(dataall$alg,function(x)endsWith(as.character(x),"PR")),]
  }
  else if (suffix =="sim") {
    dataall <- dataall[sapply(dataall$alg,function(x)!endsWith(as.character(x),"PR")),]
    names <- c("EvoCom2", "EvoCom3", "Gianduja2", "Gianduja2E", "Gianduja3", "Gianduja3E")
  }
  
  
  dataall$score <- dataall$score * -1
  
  R <- AP.SCI(score~alg+task,data=dataall,method="Ranks",test="Conover")
  #R <- AP.SCI(score~alg*task,data=dataall,method="Parametric",test="Tukey")
  
  print(R)
  #R <- R[c(1,3,2,6,7,5,4),]
  #rownames(R) <- 1:nrow(R)
  
  #R$algo <- factor(R$algo, levels = R$algo[c(4,3,7,8,2,1,5,6)])
  R$algo <- factor(R$algo, levels = R$algo[c(2,5,6,1,3,4)])
  
  print(R)
  
  #saving_path <- file.path(".", paste("Friedman-","tasks.jpg", sep=""))
  pdf.dim <- c(5,1.5) # width, height
  saving_path <- file.path(".", paste("FriedmanB2-",suffix,"tasks.tex", sep=""))
  tikz(file = saving_path, width=pdf.dim[1], height=pdf.dim[2])
  #tikz(file = saving_path)
  fried_test <- ggplot(R, aes(x=y,y=algo,x)) +
    #geom_point(size=2) +
    labs(x=paste("rank in ", title, sep=""), y="Design Method") +
    geom_vline(aes(xintercept=upper),  color="light gray", size=0.2) +
    geom_vline(aes(xintercept=lower), color="light gray", size=0.2) +
    geom_errorbarh(aes(xmax=upper, xmin=lower,height=0.3)) +
    geom_point(shape = 21, colour = "black", fill = "white", size = 1.5, stroke = 0.5) +
    scale_y_discrete(breaks=names,
                     labels=c("\\texttt{EvoCom2}", "\\texttt{EvoCom3}", "\\texttt{Gianduja2}", "\\texttt{Gianduja2E}", "\\texttt{Gianduja3}", "\\texttt{Gianduja3E}" )) +
    
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
      #panel.grid.minor = element_line(colour = "gray"),
      panel.border = element_rect(fill=NA, colour="gray"),
      panel.grid.major.y = element_line(colour = "light gray"),
      #panel.grid.major.y = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),
      axis.text=element_text(size=8),
      axis.title=element_text(size=9,face="bold")
    )
  
  print(fried_test)
  dev.off()
}

# 
# data11 = read.csv("scores-Beacon Aggregation.txt")
# data12 = read.csv("scores3-Beacon Aggregation.txt")
# data21 = read.csv("scores-Beacon Dec.txt")
# data22 = read.csv("scores3-Beacon Dec.txt")
# data31 = read.csv("scores-Beacon Stop.txt")
# data32 = read.csv("scores3-Beacon Stop.txt")


data1 = read.csv("scores14-Beacon Aggregation.txt")
data2 = read.csv("scores14-Beacon Stop.txt")
data3 = read.csv("scores14-Beacon Dec.txt")

friedman(data1, data2, data3, "sim", "Simulation")

# data11 = read.csv("scores-Beacon AggregationPR.txt")
# data21 = read.csv("scores-Beacon DecPR.txt")
# data31 = read.csv("scores-Beacon StopPR.txt")
# data12 = read.csv("scores3-Beacon AggregationPR.txt")
# data22 = read.csv("scores3-Beacon DecPR.txt")
# data32 = read.csv("scores3-Beacon StopPR.txt")

friedman(data1, data2, data3, "PR", "Pseudo-reality")

