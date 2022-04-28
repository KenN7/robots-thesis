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
  
  gian2sim = data2sim[which(data2sim[,3]=='Gianduja2'), 1]
  gian2Esim = data2sim[which(data2sim[,3]=='Gianduja2E'), 1]
  evo2sim = data2sim[which(data2sim[,3]=='Evocom2'), 1]
  
  list_methods <- c( "Gianduja2", "Gianduja2E", "EvoCom2" )
  
  #saving_path3 <- file.path(".", paste(task, "-BOXplot.tex", sep=""))
  #tikz(file = saving_path3, width=pdf.dim[1], height=pdf.dim[2])
  saving_path3 <- file.path(".", paste(task, "-BOXplot.jpg", sep=""))
  jpeg(file=saving_path3)
  
  colours_ab = c("white", "white", "white", "white", "white", "white")
  #par(cex.axis=1, cex.lab=1.5, cex.main=1.9)
  boxplot(gian2sim, gian2Esim, evo2sim,
          at =c(1, 2, 3),
          axes=FALSE,
          notch=FALSE,
          #type="l",
          #col=c("gray", "white"),
          #ylim = c(0,130),
          ylab="Objective function",
          width=c(1, 1, 1),
          names=list_methods)
  #abline(v=2.75, lty=3)
  #abline(v=5.25, lty=3)
  axis(1, at =c(1, 2, 3), labels=c("Gianduja2", "Gianduja2E", "EvoCom2"), tick=FALSE)
  #axis(1, at=c(2, 4, 6), labels=c("EvoComX", "GiandujaE", "Chocolate"), tick=FALSE, padj = 1)
  title('Results')
  axis(2)
  box()
  dev.off()
}


generateplotsimpr <- function(data, task, max) {
  data2 = data[order(data$seed),]
  
  gian2sim = data2[which(data2[,3]=='Gianduja2'), 1]
  gian2Esim = data2[which(data2[,3]=='Gianduja2E'), 1]
  evo2sim = data2[which(data2[,3]=='EvoCom2'), 1]
  gian3sim = data2[which(data2[,3]=='Gianduja3'), 1]
  gian3Esim = data2[which(data2[,3]=='Gianduja3E'), 1]
  evo3sim = data2[which(data2[,3]=='EvoCom3'), 1]
  evo3Xsim = data2[which(data2[,3]=='EvoCom3X'), 1]
  evo2Xsim = data2[which(data2[,3]=='EvoCom2X'), 1]
  
  
  #data2 = datapr[order(datasim$seed),]
  
  gian2pr = data2[which(data2[,3]=='Gianduja2PR'), 1]
  gian2Epr = data2[which(data2[,3]=='Gianduja2EPR'), 1]
  evo2pr = data2[which(data2[,3]=='EvoCom2PR'), 1]
  gian3pr = data2[which(data2[,3]=='Gianduja3PR'), 1]
  gian3Epr = data2[which(data2[,3]=='Gianduja3EPR'), 1]
  evo3pr = data2[which(data2[,3]=='EvoCom3PR'), 1]
  evo3Xpr = data2[which(data2[,3]=='EvoCom3XPR'), 1]
  evo2Xpr = data2[which(data2[,3]=='EvoCom2XPR'), 1]
  
  list_methods <- c( "Gianduja2", "Gianduja2E", "EvoCom2", "EvoCom2X", "Gianduja3", "Gianduja3E", "EvoCom3", "EvoCom3X" )
  
  saving_path3 <- file.path(".", paste(task, "-BOXplot.tex", sep=""))
  tikz(file = saving_path3, width=pdf.dim[1], height=pdf.dim[2])#, bg="red")
  #saving_path3 <- file.path(".", paste(task, "-BOXplot.jpg", sep=""))
  #jpeg(file=saving_path3)
  
  #colours_ab = c("gray", "white", "gray", "gray" ,"white", "gray", "white", "gray", "gray", "white","gray", "white", "gray", "white", "gray")
  #par(cex.axis=1, cex.lab=1.5, cex.main=1.9)
  par(mar=c(2.5,2.5,2,0.3))
  boxplot( gian2sim, gian2pr,   gian2Esim, gian2Epr,    evo2sim, evo2pr,      gian3sim, gian3pr,   gian3Esim, gian3Epr,    evo3sim, evo3pr,
          at =c(1, 2,    3.5, 4.5,    6, 7,    8.5, 9.5,    11, 12,    13.5, 14.5  ),
          axes=FALSE,
          notch=FALSE,
          cex=0.5,
          #type="l",
          #col=c("gray", "white",    "gray" ,"white",    "gray", "white",    "gray", "white",     "gray" ,"white",    "gray", "white" ),
          col=c("gray"),
          #ylim = c(0,130),
          #ylab="Objective function",
          width=c(0.5, 2,    0.5, 2,   0.5, 2,    0.5, 2,    0.5, 2,   0.5, 2 ),
          names=list_methods)
  abline(v=2.75, lty=3, col="gray")
  abline(v=5.25, lty=3, col="gray")
  abline(v=7.75, lty=3, col="gray")
  abline(v=10.25, lty=3, col="gray")
  abline(v=12.75, lty=3, col="gray")
  #abline(v=15.25, lty=3, col="gray")
  
  axis(1, at=c(1.5, 4, 6.5, 9, 11.5), labels=c("\\texttt{Gianduja2}", "", "\\texttt{EvoCom2}", "", "\\texttt{Gianduja3E}"), tick=FALSE, mgp=c(0,0.2,0))
  axis(1, at=c(1.5, 4, 6.5, 9, 11.5, 14), labels=c("", "\\texttt{Gianduja2E}", "", "\\texttt{Gianduja3}", "", "\\texttt{EvoCom3}"), tick=FALSE, mgp=c(0,1.2,0))
  title(paste('\\textsc{',task,'}', sep=""), font.main=1, line=1)
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

#datareal = read.csv("real-scores-deci.txt")
#datasim = read.csv("scores-Decision1X.txt")
#datapr = read.csv("scores-Decision1XPR.txt")
#generateplotsimpr(datasim, datapr, datareal, "decision", 24000)


#datasim2 = read.csv("scores-Beacon Aggregation.txt")
#datasim3 = read.csv("scores3-Beacon Aggregation.txt")
#datasim = rbind(datasim2, datasim3)

#datapr2 = read.csv("scores-Beacon AggregationPR.txt")
#datapr3 = read.csv("scores3-Beacon AggregationPR.txt")
#datapr = rbind(datapr2, datapr3)

data = read.csv("scores14-Beacon Aggregation.txt")

generateplotsimpr(data, "Beacon Aggregation", 24000)


#datasim2 = read.csv("scores-Beacon Stop.txt")
#datasim3 = read.csv("scores3-Beacon Stop.txt")
#datasim = rbind(datasim2, datasim3)

#datapr2 = read.csv("scores-Beacon StopPR.txt")
#datapr3 = read.csv("scores3-Beacon StopPR.txt")
#datapr = rbind(datapr2, datapr3)

data = read.csv("scorescenter-Beacon Stop.txt")

generateplotsimpr(data, "Beacon Stop", 24000)

#datasim2 = read.csv("scores-Beacon Dec.txt")
#datasim3 = read.csv("scores3-Beacon Dec.txt")
#datasim = rbind(datasim2, datasim3)

#datapr2 = read.csv("scores-Beacon DecPR.txt")
#datapr3 = read.csv("scores3-Beacon DecPR.txt")
#datapr = rbind(datapr2, datapr3)

data = read.csv("scores14-Beacon Dec.txt")

generateplotsimpr(data, "Beacon Decision", 24000)

#datareal = read.csv("real-scores-aggregation.txt")
#datasim = read.csv("scores-Aggregation1X.txt")
#datapr = read.csv("scores-Aggregation1XPR.txt")
#generateplotsimpr(datasim, datapr, datareal, "aggreg", 24000)

#datareal = read.csv("real-scores-stop.txt")
#datasim = read.csv("scores-Stop1X.txt")
#datapr = read.csv("scores-Stop1XPR.txt")
#generateplotsimpr(datasim, datapr, datareal, "stop", 48000)
