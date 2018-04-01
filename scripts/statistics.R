#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

datasim = read.csv(args[1])
datareal = read.csv(args[2])

data2sim = datasim[order(datasim$seed),]

data2real = datareal[order(datareal$seed),]

giansim = data2sim[which(data2sim[,3]=='AutoMoDe-Gianduja'), 1]
chocosim = data2sim[which(data2sim[,3]=='AutoMoDe-Chocolate'), 1]
evosim = data2sim[which(data2sim[,3]=='Evostick'), 1]

gianreal = data2real[which(data2real[,3]=='AutoMoDe-Gianduja'), 1]
chocoreal = data2real[which(data2real[,3]=='AutoMoDe-Chocolate'), 1]
evoreal = data2real[which(data2real[,3]=='Evostick'), 1]

print('Sim choco vs gian')
wilcox.test(chocosim, giansim, alternative = "less", paired=TRUE)
wilcox.test(chocosim, giansim, alternative = "less")

print('Sim evo vs gian')
wilcox.test(evosim, giansim, alternative = "less", paired=TRUE)
wilcox.test(evosim, giansim, alternative = "less")

print('real choco vs gian')
wilcox.test(chocoreal, gianreal, alternative = "less", paired=TRUE)
wilcox.test(chocoreal, gianreal, alternative = "less")

print('real evo vs gian')
wilcox.test(evoreal, gianreal, alternative = "less", paired=TRUE)
wilcox.test(evoreal, gianreal, alternative = "less")
