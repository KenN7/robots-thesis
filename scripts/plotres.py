#!/usr/bin/python3


import seaborn as sea
import pandas as pd
import matplotlib.pyplot as plt
import argparse

p = argparse.ArgumentParser(description='plots box plots based on files')
p.add_argument('-f', '--files', nargs='+', help='input files')

def main(args):
    d = []
    for f in args.files:
        d.append(pd.read_csv(f))
    d = pd.concat(d, ignore_index=True)

    ax = sea.violinplot(x="alg", y="score", data=d, cut=0, hue="real")
    #ax = sea.boxplot(x="alg", y="score", data=d, notch=True, hue="real")
    #ax = sea.swarmplot(x="alg", y="score", data=d, hue="real")

    plt.show()


if __name__ == '__main__':
    args = p.parse_args()
    main(args)


# > datasim = read.csv("scores-Decision making.txt")
# > data2sim = datasim[order(datasim$seed),]
# > View(data2sim)
# > giansim = data2sim[which(data2sim[,3]=='AutoMoDe-Gianduja'), 1]
# > chocosim = data2sim[which(data2sim[,3]=='AutoMoDe-Chocolate'), 1]
# > evosim = data2sim[which(data2sim[,3]=='Evostick'), 1]
# > wilcox.test(chocosim, giansim, alternative = "less", paired=TRUE)
