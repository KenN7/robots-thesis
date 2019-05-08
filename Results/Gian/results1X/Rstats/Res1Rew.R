#!/usr/bin/env Rscript
library(tikzDevice)

args = commandArgs(trailingOnly=TRUE)

generateplot <- function(datareal, datasim, task, max) {
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

  #saving_path <- file.path(".", paste(task, "-ECDFReal.tex", sep=""))
  #tikz(file = saving_path, width=pdf.dim[1], height=pdf.dim[2])
  ##jpeg(file=saving_path)

  #par(cex.axis=1.5, cex.lab=1.5, cex.main=1.9)
  #plot(ecdf1r, verticals=TRUE, do.points=FALSE,
  #     xlim = c(0,max), xlab= 'Objective function',
  #     ylab='',
  #     main = 'Empirical Cumulative Distribution',
  #     lty = "dotted"
  #     )
  #plot(ecdf2r, verticals=TRUE, do.points=FALSE, add=TRUE, lty = "dashed")
  #plot(ecdf3r, verticals=TRUE, do.points=FALSE, add=TRUE)
  #legend(0, 1.0, legend = c("Chocolate","EvoCom","Gianduja"), lty=1:3 )
  #dev.off()


  #saving_path2 <- file.path(".", paste(task, "-ECDFSim.tex", sep=""))
  #tikz(file = saving_path2, width=pdf.dim[1], height=pdf.dim[2])
  ##jpeg(file=saving_path2)

  #par(cex.axis=1.5, cex.lab=1.5, cex.main=1.9)
  #plot(ecdf1s, verticals=TRUE, do.points=FALSE,
  #     xlim = c(0,max), xlab= 'Objective function',
  #     ylab='',
  #     main = 'Empirical Cumulative Distribution'
  #     )
  #plot(ecdf2s, verticals=TRUE, do.points=FALSE, add=TRUE, col='brown')
  #plot(ecdf3s, verticals=TRUE, do.points=FALSE, add=TRUE, col='orange')
  #dev.off()

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


generateplotsim <- function(datasim, task, max) {
  data2sim = datasim[order(datasim$seed),]
  
  giansim = data2sim[which(data2sim[,3]=='Gianduja'), 1]
  gianEsim = data2sim[which(data2sim[,3]=='GiandujaE'), 1]
  gianEXsim = data2sim[which(data2sim[,3]=='GiandujaEX'), 1]
  chocosim = data2sim[which(data2sim[,3]=='Chocolate'), 1]
  evosim = data2sim[which(data2sim[,3]=='EvoCom'), 1]
  evoXsim = data2sim[which(data2sim[,3]=='EvoComX'), 1]
  
  ecdf1s = ecdf(giansim)
  ecdf2s = ecdf(evosim)
  ecdf3s = ecdf(chocosim)
  
  list_methods <- c("EvoCom", "EvoComX", "Gianduja", "GiandujaE", "GiandujaEX", "Chocolate")
  
  #saving_path3 <- file.path(".", paste(task, "-BOXplot.tex", sep=""))
  #tikz(file = saving_path3, width=pdf.dim[1], height=pdf.dim[2])
  saving_path3 <- file.path(".", paste(task, "-BOXplot.jpg", sep=""))
  jpeg(file=saving_path3)
  
  colours_ab = c("white", "white", "white", "white", "white", "white")
  #par(cex.axis=1, cex.lab=1.5, cex.main=1.9)
  boxplot(evosim, evoXsim, giansim, gianEsim, gianEXsim, chocosim,
          at =c(1, 2, 3, 4, 5, 6),
          #axes=FALSE,
          notch=FALSE,
          #type="l",
          #col=c("gray", "white"),
          #ylim = c(0,130),
          ylab="Objective function",
          width=c(1, 1, 1, 1, 1, 1),
          names=list_methods)
  #abline(v=2.75, lty=3)
  #abline(v=5.25, lty=3)
  axis(1, at =c(1, 3, 5), labels=c("EvoCom", "Gianduja", "GiandujaEX"), tick=FALSE)
  axis(1, at=c(2, 4, 6), labels=c("EvoComX", "GiandujaE", "Chocolate"), tick=FALSE, padj = 1)
  title('Results')
  axis(2)
  box()
  dev.off()
}


generateplotsimpr <- function(datasim, datapr, datareal, task, max) {
  data2sim = datasim[order(datasim$seed),]
  
  giansim = data2sim[which(data2sim[,3]=='Gianduja'), 1]
  gianEsim = data2sim[which(data2sim[,3]=='GiandujaE'), 1]
  gianEXsim = data2sim[which(data2sim[,3]=='GiandujaEX'), 1]
  gianXsim = data2sim[which(data2sim[,3]=='GiandujaX'), 1]
  chocosim = data2sim[which(data2sim[,3]=='Chocolate'), 1]
  evosim = data2sim[which(data2sim[,3]=='EvoCom'), 1]
  evoXsim = data2sim[which(data2sim[,3]=='EvoComX'), 1]
  
  data2pr = datapr[order(datasim$seed),]
  
  gianpr = data2pr[which(data2pr[,3]=='Gianduja'), 1]
  gianEpr = data2pr[which(data2pr[,3]=='GiandujaE'), 1]
  gianEXpr = data2pr[which(data2pr[,3]=='GiandujaEX'), 1]
  gianXpr = data2pr[which(data2pr[,3]=='GiandujaX'), 1]
  chocopr = data2pr[which(data2pr[,3]=='Chocolate'), 1]
  evopr = data2pr[which(data2pr[,3]=='EvoCom'), 1]
  evoXpr = data2pr[which(data2pr[,3]=='EvoComX'), 1]
  
  data2real = datareal[order(datareal$seed),]
  
  gianreal = data2real[which(data2real[,3]=='Gianduja'), 1]
  evoreal = data2real[which(data2real[,3]=='EvoCom'), 1]
  chocoreal = data2real[which(data2real[,3]=='Chocolate'), 1]
  
  print(task)
  print(wilcox.test(gianpr, evopr, alternative = "greater", paired=TRUE))
  print(wilcox.test(gianpr, evoXpr, alternative = "greater"))
  print(wilcox.test(gianEpr, evopr, alternative = "greater", paired=TRUE))
  print(wilcox.test(gianEpr, evoXpr, alternative = "greater"))
  print(wilcox.test(gianXpr, evopr, alternative = "greater", paired=TRUE))
  print(wilcox.test(gianXpr, evoXpr, alternative = "greater"))
  print(wilcox.test(gianEXpr, evopr, alternative = "greater", paired=TRUE))
  print(wilcox.test(gianEXpr, evoXpr, alternative = "greater"))
  
  list_methods <- c("EvoCom","EvoComPR", "EvoComR", "EvoComX","EvoComXPR", "Gianduja", "GiandujaPR", "GiandujaR", "GiandujaE", "GiandujaEPR", "GiandujaEX", "GiandujaEXPR", "GiandujaX", "GiandujaXPR", "Chocolate", "ChocolatePR", "ChocolateR")
  
  saving_path3 <- file.path(".", paste(task, "-BOXplot.tex", sep=""))
  tikz(file = saving_path3, width=pdf.dim[1], height=pdf.dim[2])
  #saving_path3 <- file.path(".", paste(task, "-BOXplot.jpg", sep=""))
  #jpeg(file=saving_path3, width=pdf.dim[1], height=pdf.dim[2])
  
  #colours_ab = c("gray", "white", "gray", "gray" ,"white", "gray", "white", "gray", "gray", "white","gray", "white", "gray", "white", "gray")
  par(mar=c(2.5,2.5,2,0.3))
  boxplot(chocosim, chocopr, chocoreal, evosim, evopr, evoreal, evoXsim, evoXpr, giansim, gianpr, gianreal, gianXsim, gianXpr, gianEsim, gianEpr, gianEXsim, gianEXpr, 
          at =c(1, 2, 3,   4.5, 5.5, 6.5,   8, 9,   10.5, 11.5, 12.5,   14, 15,   16.5, 17.5,   19, 20 ),
          axes=FALSE,
          notch=FALSE,
          cex=0.5 ,
          #type="l",
          #col=c("gray", "white"),
          #col=c("gray", "white", "gray",    "gray" ,"white",    "gray", "white", "gray",    "gray", "white",     "gray", "white",    "gray", "white",    "gray", "white", "gray"),
          col=c("gray", "gray", "white",    "gray", "gray", "white",    "gray", "gray",    "gray", "gray", "white",     "gray", "gray",    "gray", "gray",    "gray", "gray"),
          #ylim = c(0,130),
          width=c(0.5, 2, 2,    0.5, 2, 2,   0.5, 2,   0.5, 2, 2,    0.5, 2,   0.5, 2,   0.5, 2),
          names=list_methods)
  abline(v=3.75, lty=3, col="gray")
  abline(v=7.25, lty=3, col="gray")
  abline(v=9.75, lty=3, col="gray")
  abline(v=13.25, lty=3, col="gray")
  abline(v=15.75, lty=3, col="gray")
  abline(v=18.25, lty=3, col="gray")
  axis(1, at =c(2, 8.5, 14.5, 19.5), labels=c("\\texttt{Chocolate}", "\\texttt{EvoComX}", "\\texttt{GiandujaX}", "\\texttt{GiandujaEX}"), tick=FALSE, mgp=c(0,0.2,0))
  axis(1, at=c(5.5, 11.5, 17), labels=c("\\texttt{EvoCom}", "\\texttt{Gianduja}", "\\texttt{GiandujaE}"), tick=FALSE, mgp=c(0,1.2,0))
  title(paste('\\textsc{',task,'}', sep=""), font.main=1, line=0.7)
  title(ylab="Objective function",line=1.5)
  axis(2, tck=-0.03, mgp=c(0,0.3,0))
  box()
  dev.off()
}


################
### BOXPLOTS ###
################

print("Boxplots ...")

pdf.dim <- c(4.5,2.5) # width, height

datareal = read.csv("real-scores-deci.txt")
datasim = read.csv("scores-Decision1X.txt")
datapr = read.csv("scores-Decision1XPR.txt")
generateplotsimpr(datasim, datapr, datareal, "decision", 24000)

datareal = read.csv("real-scores-aggregation.txt")
datasim = read.csv("scores-Aggregation1X.txt")
datapr = read.csv("scores-Aggregation1XPR.txt")
generateplotsimpr(datasim, datapr, datareal, "aggregation", 24000)

datareal = read.csv("real-scores-stop.txt")
datasim = read.csv("scores-Stop1X.txt")
datapr = read.csv("scores-Stop1XPR.txt")
generateplotsimpr(datasim, datapr, datareal, "stop", 48000)
