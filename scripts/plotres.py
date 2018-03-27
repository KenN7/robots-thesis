#!/usr/bin/python3


import seaborn as sea
import pandas as pd
import matplotlib.pyplot as plt

d = pd.read_csv('real-scores-deci.txt')
ax = sea.violinplot(x="alg", y="score", data=d)
plt.show()
