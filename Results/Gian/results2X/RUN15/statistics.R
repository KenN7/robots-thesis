#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#datasim = read.csv(args[1])
#datareal = read.csv(args[2])

data2 = read.csv("scores14-Beacon Aggregation.txt")

gian2simagg = data2[which(data2[,3]=='Gianduja2'), 1]
gian2Esimagg = data2[which(data2[,3]=='Gianduja2E'), 1]
evo2simagg = data2[which(data2[,3]=='EvoCom2'), 1]
gian3simagg = data2[which(data2[,3]=='Gianduja3'), 1]
gian3Esimagg = data2[which(data2[,3]=='Gianduja3E'), 1]
evo3simagg = data2[which(data2[,3]=='EvoCom3'), 1]
evo3Xsimagg = data2[which(data2[,3]=='EvoCom3X'), 1]
evo2Xsimagg = data2[which(data2[,3]=='EvoCom2X'), 1]

gian2pragg = data2[which(data2[,3]=='Gianduja2PR'), 1]
gian2Epragg = data2[which(data2[,3]=='Gianduja2EPR'), 1]
evo2pragg = data2[which(data2[,3]=='EvoCom2PR'), 1]
gian3pragg = data2[which(data2[,3]=='Gianduja3PR'), 1]
gian3Epragg = data2[which(data2[,3]=='Gianduja3EPR'), 1]
evo3pragg = data2[which(data2[,3]=='EvoCom3PR'), 1]
evo3Xpragg = data2[which(data2[,3]=='EvoCom3XPR'), 1]
evo2Xpragg = data2[which(data2[,3]=='EvoCom2XPR'), 1]

datasimagg = data2[sapply(data2$alg,function(x)!endsWith(as.character(x),"PR")),]
datapragg = data2[sapply(data2$alg,function(x)endsWith(as.character(x),"PR")),]

data2 = read.csv("scores14-Beacon Stop.txt")

gian2simst = data2[which(data2[,3]=='Gianduja2'), 1]
gian2Esimst = data2[which(data2[,3]=='Gianduja2E'), 1]
evo2simst = data2[which(data2[,3]=='EvoCom2'), 1]
gian3simst = data2[which(data2[,3]=='Gianduja3'), 1]
gian3Esimst = data2[which(data2[,3]=='Gianduja3E'), 1]
evo3simst = data2[which(data2[,3]=='EvoCom3'), 1]
evo3Xsimst = data2[which(data2[,3]=='EvoCom3X'), 1]
evo2Xsimst = data2[which(data2[,3]=='EvoCom2X'), 1]

gian2prst = data2[which(data2[,3]=='Gianduja2PR'), 1]
gian2Eprst = data2[which(data2[,3]=='Gianduja2EPR'), 1]
evo2prst = data2[which(data2[,3]=='EvoCom2PR'), 1]
gian3prst = data2[which(data2[,3]=='Gianduja3PR'), 1]
gian3Eprst = data2[which(data2[,3]=='Gianduja3EPR'), 1]
evo3prst = data2[which(data2[,3]=='EvoCom3PR'), 1]
evo3Xprst = data2[which(data2[,3]=='EvoCom3XPR'), 1]
evo2Xprst = data2[which(data2[,3]=='EvoCom2XPR'), 1]

datasimst = data2[sapply(data2$alg,function(x)!endsWith(as.character(x),"PR")),]
dataprst = data2[sapply(data2$alg,function(x)endsWith(as.character(x),"PR")),]

data2 = read.csv("scores14-Beacon Dec.txt")

gian2simdec = data2[which(data2[,3]=='Gianduja2'), 1]
gian2Esimdec = data2[which(data2[,3]=='Gianduja2E'), 1]
evo2simdec = data2[which(data2[,3]=='EvoCom2'), 1]
gian3simdec = data2[which(data2[,3]=='Gianduja3'), 1]
gian3Esimdec = data2[which(data2[,3]=='Gianduja3E'), 1]
evo3simdec = data2[which(data2[,3]=='EvoCom3'), 1]
evo3Xsimdec = data2[which(data2[,3]=='EvoCom3X'), 1]
evo2Xsimdec = data2[which(data2[,3]=='EvoCom2X'), 1]

gian2prdec = data2[which(data2[,3]=='Gianduja2PR'), 1]
gian2Eprdec = data2[which(data2[,3]=='Gianduja2EPR'), 1]
evo2prdec = data2[which(data2[,3]=='EvoCom2PR'), 1]
gian3prdec = data2[which(data2[,3]=='Gianduja3PR'), 1]
gian3Eprdec = data2[which(data2[,3]=='Gianduja3EPR'), 1]
evo3prdec = data2[which(data2[,3]=='EvoCom3PR'), 1]
evo3Xprdec = data2[which(data2[,3]=='EvoCom3XPR'), 1]
evo2Xprdec = data2[which(data2[,3]=='EvoCom2XPR'), 1]

datasimdec = data2[sapply(data2$alg,function(x)!endsWith(as.character(x),"PR")),]
dataprdec = data2[sapply(data2$alg,function(x)endsWith(as.character(x),"PR")),]

data2simagg = datasimagg[order(datasimagg$seed),]
data2pragg = datapragg[order(datapragg$seed),]

data2simst = datasimst[order(datasimst$seed),]
data2prst = dataprst[order(dataprst$seed),]

data2simdec = datasimdec[order(datasimdec$seed),]
data2prdec = dataprdec[order(dataprdec$seed),]

# gian2pragg = data2pragg[which(data2pragg[,3]=='Gianduja2'), 1]
# gian3pragg = data2pragg[which(data2pragg[,3]=='Gianduja3'), 1]
# gian2Epragg = data2pragg[which(data2pragg[,3]=='Gianduja2E'), 1]
# gian3Epragg = data2pragg[which(data2pragg[,3]=='Gianduja3E'), 1]
# evo2pragg = data2pragg[which(data2pragg[,3]=='Evocom2'), 1]
# evo3pragg = data2pragg[which(data2pragg[,3]=='Evocom3'), 1]
# 
# gian2prst = data2prst[which(data2prst[,3]=='Gianduja2'), 1]
# gian3prst = data2prst[which(data2prst[,3]=='Gianduja3'), 1]
# gian2Eprst = data2prst[which(data2prst[,3]=='Gianduja2E'), 1]
# gian3Eprst = data2prst[which(data2prst[,3]=='Gianduja3E'), 1]
# evo2prst = data2prst[which(data2prst[,3]=='Evocom2'), 1]
# evo3prst = data2prst[which(data2prst[,3]=='Evocom3'), 1]
# 
# gian2prdec = data2prdec[which(data2prdec[,3]=='Gianduja2'), 1]
# gian3prdec = data2prdec[which(data2prdec[,3]=='Gianduja3'), 1]
# gian2Eprdec = data2prdec[which(data2prdec[,3]=='Gianduja2E'), 1]
# gian3Eprdec = data2prdec[which(data2prdec[,3]=='Gianduja3E'), 1]
# evo2prdec = data2prdec[which(data2prdec[,3]=='Evocom2'), 1]
# evo3prdec = data2prdec[which(data2prdec[,3]=='Evocom3'), 1]

evalmission <- function(gian2pr, gian3pr, gian2Epr, gian3Epr, evopr) {
  a1 = 100*(median(gian2pr)-median(evopr))/median(gian2pr)
  b1 = 100*(median(gian2pr)-median(gian3pr))/median(gian2pr)
  c1 = 100*(median(gian2Epr)-median(evopr))/median(gian2Epr)
  d1 = 100*(median(gian2Epr)-median(gian3Epr))/median(gian2Epr)
  return(c(a1,b1,c1,d1))
}

tabular<-matrix(c( evalmission(gian2pragg, gian3pragg, gian2Epragg, gian3Epragg, evo2pragg),
                   evalmission(gian2prst, gian3prst, gian2Eprst, gian3Eprst, evo2prst),
                   evalmission(gian2prdec, gian3prdec, gian2Eprdec, gian3Eprdec, evo2prdec) ),
                    ncol=4,byrow=TRUE)
colnames(tabular)<-c("Gi2-EC2","Gi2-Gi3","Gi2E-EC2","Gi2E-Gi3E")
rownames(tabular)<-c("BAgg", "BStop", "BDec")
tabular = as.table(tabular)
tabular


tabular<-matrix(c( evalmission(gian2pragg, gian3pragg, gian2Epragg, gian3Epragg, evo3Xpragg),
                   evalmission(gian2prst, gian3prst, gian2Eprst, gian3Eprst, evo3Xprst),
                   evalmission(gian2prdec, gian3prdec, gian2Eprdec, gian3Eprdec, evo3Xprdec) ),
                ncol=4,byrow=TRUE)
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



