#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#datasim = read.csv(args[1])
#datareal = read.csv(args[2])

datasim2 = read.csv("scores-Beacon Aggregation.txt")
datasim3 = read.csv("scores3-Beacon Aggregation.txt")
datasimagg = rbind(datasim2, datasim3)

datapr2 = read.csv("scores-Beacon AggregationPR.txt")
datapr3 = read.csv("scores3-Beacon AggregationPR.txt")
datapragg = rbind(datapr2, datapr3)

datasim2 = read.csv("scores-Beacon Stop.txt")
datasim3 = read.csv("scores3-Beacon Stop.txt")
datasimst = rbind(datasim2, datasim3)

datapr2 = read.csv("scores-Beacon StopPR.txt")
datapr3 = read.csv("scores3-Beacon StopPR.txt")
dataprst = rbind(datapr2, datapr3)

datasim2 = read.csv("scores-Beacon Dec.txt")
datasim3 = read.csv("scores3-Beacon Dec.txt")
datasimdec = rbind(datasim2, datasim3)

datapr2 = read.csv("scores-Beacon DecPR.txt")
datapr3 = read.csv("scores3-Beacon DecPR.txt")
dataprdec = rbind(datapr2, datapr3)


data2simagg = datasimagg[order(datasimagg$seed),]
data2pragg = datapragg[order(datapragg$seed),]

data2simst = datasimst[order(datasimst$seed),]
data2prst = dataprst[order(dataprst$seed),]

data2simdec = datasimdec[order(datasimdec$seed),]
data2prdec = dataprdec[order(dataprdec$seed),]

gian2pragg = data2pragg[which(data2pragg[,3]=='Gianduja2'), 1]
gian3pragg = data2pragg[which(data2pragg[,3]=='Gianduja3'), 1]
gian2Epragg = data2pragg[which(data2pragg[,3]=='Gianduja2E'), 1]
gian3Epragg = data2pragg[which(data2pragg[,3]=='Gianduja3E'), 1]
evo2pragg = data2pragg[which(data2pragg[,3]=='Evocom2'), 1]
evo3pragg = data2pragg[which(data2pragg[,3]=='Evocom3'), 1]

gian2prst = data2prst[which(data2prst[,3]=='Gianduja2'), 1]
gian3prst = data2prst[which(data2prst[,3]=='Gianduja3'), 1]
gian2Eprst = data2prst[which(data2prst[,3]=='Gianduja2E'), 1]
gian3Eprst = data2prst[which(data2prst[,3]=='Gianduja3E'), 1]
evo2prst = data2prst[which(data2prst[,3]=='Evocom2'), 1]
evo3prst = data2prst[which(data2prst[,3]=='Evocom3'), 1]

gian2prdec = data2prdec[which(data2prdec[,3]=='Gianduja2'), 1]
gian3prdec = data2prdec[which(data2prdec[,3]=='Gianduja3'), 1]
gian2Eprdec = data2prdec[which(data2prdec[,3]=='Gianduja2E'), 1]
gian3Eprdec = data2prdec[which(data2prdec[,3]=='Gianduja3E'), 1]
evo2prdec = data2prdec[which(data2prdec[,3]=='Evocom2'), 1]
evo3prdec = data2prdec[which(data2prdec[,3]=='Evocom3'), 1]

evalmission <- function(data) {
  gian2pr = data[which(data[,3]=='Gianduja2'), 1]
  gian3pr = data[which(data[,3]=='Gianduja3'), 1]
  gian2Epr = data[which(data[,3]=='Gianduja2E'), 1]
  gian3Epr = data[which(data[,3]=='Gianduja3E'), 1]
  evo2pr = data[which(data[,3]=='Evocom2'), 1]
  evo3pr = data[which(data[,3]=='Evocom3'), 1]
  a1 = 100*(median(gian2pr)-median(evo2pr))/median(gian2pr)
  b1 = 100*(median(gian2pr)-median(gian3pr))/median(gian2pr)
  c1 = 100*(median(gian2Epr)-median(evo2pr))/median(gian2Epr)
  d1 = 100*(median(gian2Epr)-median(gian3Epr))/median(gian2Epr)
  return(c(a1,b1,c1,d1))
}

tabular<-matrix(c( evalmission(data2pragg),evalmission(data2prst),evalmission(data2prdec) ),ncol=4,byrow=TRUE)
colnames(tabular)<-c("Gi2-EC2","Gi2-Gi3","Gi2E-EC2","Gi2E-Gi3E")
rownames(tabular)<-c("BAgg", "BStop", "BDec")
tabular = as.table(tabular)
tabular

print('gian2pr vs evo2-3')
wilcox.test(gian2pr, evo2pr, alternative = "greater", paired=TRUE)
wilcox.test(gian2pr, evo2pr, alternative = "greater")
wilcox.test(gian2pr, evo3pr, alternative = "greater", paired=TRUE)
wilcox.test(gian2pr, evo3pr, alternative = "greater")

print('gian3pr vs evo2-3')
wilcox.test(gian3pr, evo2pr, alternative = "greater", paired=TRUE)
wilcox.test(gian3pr, evo2pr, alternative = "greater")
wilcox.test(gian3pr, evo3pr, alternative = "greater", paired=TRUE)
wilcox.test(gian3pr, evo3pr, alternative = "greater")

print('gian2Epr vs evo2-3')
wilcox.test(gian2Epr, evo2pr, alternative = "greater", paired=TRUE)
wilcox.test(gian2Epr, evo2pr, alternative = "greater")
wilcox.test(gian2Epr, evo3pr, alternative = "greater", paired=TRUE)
wilcox.test(gian2Epr, evo3pr, alternative = "greater")

print('gian3Epr vs evo2-3')
wilcox.test(gian3Epr, evo2pr, alternative = "greater", paired=TRUE)
wilcox.test(gian3Epr, evo2pr, alternative = "greater")
wilcox.test(gian3Epr, evo3pr, alternative = "greater", paired=TRUE)
wilcox.test(gian3Epr, evo3pr, alternative = "greater")



