#!/usr/bin/env Rscript
library(tikzDevice)

args = commandArgs(trailingOnly=TRUE)

generateplot <- function(datareal, datasim, task) {
  data2sim = datasim[order(datasim$seed),]
  
  data2real = datareal[order(datareal$seed),]
  
  giansim = data2sim[which(data2sim[,3]=='Gianduja'), 1]
  chocosim = data2sim[which(data2sim[,3]=='Chocolate'), 1]
  evosim = data2sim[which(data2sim[,3]=='EvoCom'), 1]
  
  gianreal = data2real[which(data2real[,3]=='Gianduja'), 1]
  chocoreal = data2real[which(data2real[,3]=='Chocolate'), 1]
  evoreal = data2real[which(data2real[,3]=='EvoCom'), 1]
  
  ecdf1r = ecdf(gianreal)
  ecdf2r = ecdf(evoreal)
  ecdf3r = ecdf(chocoreal)
  
  ecdf1s = ecdf(giansim)
  ecdf2s = ecdf(evosim)
  ecdf3s = ecdf(chocosim)
  
  saving_path <- file.path(".", paste(task, "-ECDFReal.tex", sep=""))
  tikz(file = saving_path, width=pdf.dim[1], height=pdf.dim[2])
  #jpeg(file=saving_path)
  
  par(cex.axis=1.5, cex.lab=1.5, cex.main=1.9)
  plot(ecdf1r, verticals=TRUE, do.points=FALSE, 
       xlim = c(0,24000), xlab= 'Objective function',
       ylab='', 
       main = 'Empirical Cumulative Distribution Real values',
       lty = "dotted"
       )
  plot(ecdf2r, verticals=TRUE, do.points=FALSE, add=TRUE, lty = "dashed")
  plot(ecdf3r, verticals=TRUE, do.points=FALSE, add=TRUE)
  legend(0, 1.0, legend = c("Chocolate","EvoCom","Gianduja"), lty=1:3 )
  dev.off()
  
  
  saving_path2 <- file.path(".", paste(task, "-ECDFSim.tex", sep=""))
  tikz(file = saving_path2, width=pdf.dim[1], height=pdf.dim[2])
  #jpeg(file=saving_path2)
  
  par(cex.axis=1.5, cex.lab=1.5, cex.main=1.9)
  plot(ecdf1s, verticals=TRUE, do.points=FALSE, 
       xlim = c(0,24000), xlab= 'Objective function', 
       ylab='', 
       main = 'Empirical Cumulative Distribution Simlulation values'
       )
  plot(ecdf2s, verticals=TRUE, do.points=FALSE, add=TRUE, col='brown')
  plot(ecdf3s, verticals=TRUE, do.points=FALSE, add=TRUE, col='orange')
  dev.off()
  
  list_methods <- c("GianS", "GianR", "EvoS", "EvoR", "ChocoS", "ChocoR")
  
  saving_path3 <- file.path(".", paste(task, "-BOXplot.tex", sep=""))
  tikz(file = saving_path3, width=pdf.dim[1], height=pdf.dim[2])
  #jpeg(file=saving_path3)
  
  colours_ab = c("gray", "white", "gray", "white", "gray", "white")
  par(cex.axis=1.5, cex.lab=1.5, cex.main=1.9)
  boxplot(evosim, evoreal, giansim, gianreal, chocosim, chocoreal,
          at =c(1, 2, 3.5, 4.5, 6, 7),
          axes=FALSE,
          notch=FALSE,
          type="l",
          col=c("gray", "white"),
          #ylim = c(0,130),
          ylab="Objective function",
          width=c(0.7, 2, 0.7, 2, 0.7, 2),
          names=list_methods)
  abline(v=2.75, lty=3)
  abline(v=5.25, lty=3)
  axis(1, at=c(1.5, 4, 6.5), labels=c("evom", "gian", "cho"), tick=FALSE)
  title('Results')
  axis(2)
  box()
  dev.off()
}


################
### BOXPLOTS ###
################

print("Boxplots ...")

pdf.dim <- c(5,6) # width, height


datasim = read.csv("scores-Decision Making.txt")
datareal = read.csv("real-scores-deci.txt")

generateplot(datareal, datasim, "decision")

datasim = read.csv("scores-Aggregation.txt")
datareal = read.csv("real-scores-aggregation.txt")

generateplot(datareal, datasim, "aggreg")

datasim = read.csv("scores-Stop.txt")
datareal = read.csv("real-scores-stop.txt")

generateplot(datareal, datasim, "stop")

