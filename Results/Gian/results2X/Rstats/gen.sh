#!/bin/bash 
Rscript Res2Rew.R && Rscript friedman2.R && pdflatex latex_fig.tex && pdflatex latex_fig.tex
