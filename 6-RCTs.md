# 6 Potential Outcomes, Causal Inference, and Randomized Trials  

<br>

## Readings  

[Mastering Metrics, Chapter 1](https://assets.press.princeton.edu/chapters/s10363.pdf) 

<br>

## Lecture 

[Slides from Lecture 6](https://pjakiela.github.io/ECON370/ECON370-L6-RCTs-2026-handout.pdf)  

<br>

## Optional Lab

This lab makes use of the data set [E1-CohenEtAl-data.dta](https://pjakiela.github.io/ECON523/exercises/E1-CohenEtAl-data.dta), 
a subset of the data used in the 
paper [Price Subsidies, Diagnostic Tests, and Targeting of Malaria Treatment: Evidence from a Randomized Controlled Trial](https://www.aeaweb.org/articles?id=10.1257/aer.20130267) 
by Jessica Cohen, Pascaline Dupas, and Simone Schaner, published in the _American Economic Review_ in 2015. The authors examine behavioral responses to 
various discounts ("subsidies") for malaria treatment, called "artemisinin combination therapy" or "ACT." An overview of the randomized evalaution is available [here](https://www.povertyactionlab.org/sites/default/files/publication/2011.12.15-Subsidizing-Malaria.pdf).  

To complete the lab, write a script that does the following:  

1. Downloads the data.
2. Runs a regression of the outcome of interest, `c_act`, on the treatment dummy `act_any`.
3. Identifies the baseline covariates (beginning with `b_`) that predict `c_act` in the control group.
4. Compares the R-squared Question 2 to the R-squared from a regression that also includes the baseline covariates that predict `c_act` in the control group.
5. Defines a `low_education` variable equal to 1 if the household head had 0 or 1 years of education, and then tests for treatment effect heterogeneity along this dimension of baseline variation.

<br>
