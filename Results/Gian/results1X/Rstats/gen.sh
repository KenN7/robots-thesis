#!/bin/bash 
Rscript Res1Rew.R && Rscript friedman1.R  &&  pdflatex latex_fig.tex && pdflatex latex_fig.tex
