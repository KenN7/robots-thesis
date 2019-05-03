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


#' Title
#'
#' @param data 
#' @param data2 
#' @param data3 
#' @param data4 
#' @param data5 
#' @param task 
#' @param max 
#'
#' @return
#' @export
#'
#' @examples
generateplotsimpr <- function(data, data2, data3, data4, data5, task, max) {
  data12 = data[order(data$seed),]
  data22 = data2[order(data3$seed),]
  data32 = data3[order(data3$seed),]
  data42 = data4[order(data4$seed),]
  data52 = data5[order(data5$seed),]
  
  data12$score <- data12$score/24000
  data22$score <- data22$score/48000
  data32$score <- data32$score/96000
  data42$score <- data42$score/192000
  data52$score <- data52$score/384000
  
  gian2E1 = data12[which(data12[,3]=='Gianduja2EPR'), 1]
  evo21 = data12[which(data12[,3]=='EvoCom2PR'), 1]
  
  gian2E2 = data22[which(data22[,3]=='Gianduja2EPR'), 1]
  evo22 = data22[which(data22[,3]=='EvoCom2PR'), 1]
  
  gian2E3 = data32[which(data32[,3]=='Gianduja2EPR'), 1]
  evo23 = data32[which(data32[,3]=='EvoCom2PR'), 1]
  
  gian2E4 = data42[which(data42[,3]=='Gianduja2EPR'), 1]
  evo24 = data42[which(data42[,3]=='EvoCom2PR'), 1]
  
  gian2E5 = data52[which(data52[,3]=='Gianduja2EPR'), 1]
  evo25 = data52[which(data52[,3]=='EvoCom2PR'), 1]
  
 # SIM
  gian2E1s = data12[which(data12[,3]=='Gianduja2E'), 1]
  evo21s = data12[which(data12[,3]=='EvoCom2'), 1]
  
  gian2E2s = data22[which(data22[,3]=='Gianduja2E'), 1]
  evo22s = data22[which(data22[,3]=='EvoCom2'), 1]
  
  gian2E3s = data32[which(data32[,3]=='Gianduja2E'), 1]
  evo23s = data32[which(data32[,3]=='EvoCom2'), 1]
  
  gian2E4s = data42[which(data42[,3]=='Gianduja2E'), 1]
  evo24s = data42[which(data42[,3]=='EvoCom2'), 1]
  
  gian2E5s = data52[which(data52[,3]=='Gianduja2E'), 1]
  evo25s = data52[which(data52[,3]=='EvoCom2'), 1]
  
  list_methods <- c( "Gianduja2E", "EvoCom2", "Gianduja2E", "EvoCom2", "Gianduja2E", "EvoCom2", "Gianduja2E", "EvoCom2", "Gianduja2E", "EvoCom2" )
  
  saving_path3 <- file.path(".", paste(task, "-BIGBOXplot.tex", sep=""))
  tikz(file = saving_path3, width=pdf.dim[1], height=pdf.dim[2])#, bg="red")
  #saving_path3 <- file.path(".", paste(task, "-BOXplot.jpg", sep=""))
  #jpeg(file=saving_path3)
  
  #colours_ab = c("gray", "white", "gray", "gray" ,"white", "gray", "white", "gray", "gray", "white","gray", "white", "gray", "white", "gray")
  #par(cex.axis=1, cex.lab=1.5, cex.main=1.9)
  par(mar=c(2.5,2.5,2,0.3))
  boxplot( gian2E1, gian2E1s, evo21, evo21s,     gian2E2,gian2E2s, evo22,evo22s,      gian2E3,gian2E3s, evo23,evo23s,     gian2E4,gian2E4s, evo24,evo24s,       gian2E5,gian2E5s, evo25,evo25s,
          at =c(1,2,3,4,    5.5, 6.5,7.5,8.5,    10,11,12,13,   14.5,15.5,16.5,17.5,     19,20,21,22   ),
          axes=FALSE,
          notch=FALSE,
          cex=0.5,
          #type="l",
          #col=c("gray", "white",    "gray" ,"white",    "gray", "white",    "gray", "white",     "gray" ,"white",    "gray", "white" ),
          col=c("gray", "gray"),
          #ylim = c(0,130),
          #ylab="Objective function",
          width=c(1.2,0.3, 1.2,0.3,    1.2,0.3, 1.2,0.3,   1.2,0.3, 1.2,0.3,    1.2,0.3, 1.2,0.3,    1.2,0.3, 1.2,0.3 ),
          names=list_methods)
  abline(v=4.75, lty=3, col="gray")
  abline(v=9.25, lty=3, col="gray")
  abline(v=13.75, lty=3, col="gray")
  abline(v=18.25, lty=3, col="gray")
  
  #axis(1, at=c(1, 2, 4, 5, 7, 8, 10, 11, 13,14 ), labels=c("\\texttt{Gianduja2E}", "\\texttt{EvoCom2}", "\\texttt{Gianduja2E}", "\\texttt{EvoCom2}", "\\texttt{Gianduja2E}", "\\texttt{EvoCom2}", "\\texttt{Gianduja2E}", "\\texttt{EvoCom2}" , "\\texttt{Gianduja2E}", "\\texttt{EvoCom2}"  ), tick=FALSE, mgp=c(0,0.2,0))
  #axis(1, at=c(2.5, 7, 11.5, 16, 20.5 ), labels=c( "Original", "scale sqrt2", "scale 2", "scale sqrt(2)*2", "scale 4"  ), tick=FALSE, mgp=c(0,0.2,0))
  axis(1, at=c(1.5, 6, 10.5, 15, 19.5 ), labels=c("\\texttt{Gianduja2E}", "\\texttt{Gianduja2E}", "\\texttt{Gianduja2E}", "\\texttt{Gianduja2E}", "\\texttt{Gianduja2E}" ), tick=FALSE, mgp=c(0,0.2,0), cex.axis=0.8)
  axis(1, at=c(3.5, 8, 12.5, 17, 21.5 ), labels=c( "\\texttt{EvoCom2}", "\\texttt{EvoCom2}", "\\texttt{EvoCom2}", "\\texttt{EvoCom2}", "\\texttt{EvoCom2}"  ), tick=FALSE, mgp=c(0,1.1,0), cex.axis=0.8)
  title(paste('\\textsc{',task,'}'," (increasing arena size)", sep=""), font.main=1, line=1.2)
  title(ylab="Objective function",line=1.5)
  axis(3, at=c(2.5, 7, 11.5, 16, 20.5 ),  labels=c("x1", "x2", "x4", "x8", "x16"), tick=FALSE, mgp=c(0,0.1,0), cex.axis=0.8 )
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

#data = read.csv("scores14-Beacon Aggregation.txt")

#generateplotsimpr(data, "Beacon Aggregation", 24000)


#datasim2 = read.csv("scores-Beacon Stop.txt")
#datasim3 = read.csv("scores3-Beacon Stop.txt")
#datasim = rbind(datasim2, datasim3)

#datapr2 = read.csv("scores-Beacon StopPR.txt")
#datapr3 = read.csv("scores3-Beacon StopPR.txt")
#datapr = rbind(datapr2, datapr3)

data = read.csv("scorescenter-Beacon Stop.txt")
data2 = read.csv("scoresxsqrt2centerSIM-Beacon Stop.txt")
data3 = read.csv("scoresx2centerSIM-Beacon Stop.txt")
data4 = read.csv("scoresx2sqrt2centerSIM-Beacon Stop.txt")
data5 = read.csv("scoresx4centerSIM-Beacon Stop.txt")

generateplotsimpr(data, data2 , data3, data4, data5, "Beacon Stop", 96000)

#datasim2 = read.csv("scores-Beacon Dec.txt")
#datasim3 = read.csv("scores3-Beacon Dec.txt")
#datasim = rbind(datasim2, datasim3)

#datapr2 = read.csv("scores-Beacon DecPR.txt")
#datapr3 = read.csv("scores3-Beacon DecPR.txt")
#datapr = rbind(datapr2, datapr3)

#data = read.csv("scores14-Beacon Dec.txt")

#generateplotsimpr(data, "Beacon Decision", 24000)

#datareal = read.csv("real-scores-aggregation.txt")
#datasim = read.csv("scores-Aggregation1X.txt")
#datapr = read.csv("scores-Aggregation1XPR.txt")
#generateplotsimpr(datasim, datapr, datareal, "aggreg", 24000)

#datareal = read.csv("real-scores-stop.txt")
#datasim = read.csv("scores-Stop1X.txt")
#datapr = read.csv("scores-Stop1XPR.txt")
#generateplotsimpr(datasim, datapr, datareal, "stop", 48000)
