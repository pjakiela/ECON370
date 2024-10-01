# 4 Numerical Approaches to OLS  

<br>

## Readings  

[Intro to Statistical Learning](https://www.statlearning.com/): 3.1, 3.2  

_If you have not yet taken at least the first week of linear algebra:_  
[Intro to Statistical Learning](https://www.statlearning.com/): pp. 20-23  
_("Notation and Simple Matrix Algebra")_  

_If you are new to defining functions in R/Python:_  
R for Data Science: [25](https://r4ds.hadley.nz/functions)   
Python for Data Analysis: [3.2](https://wesmckinney.com/book/python-builtin#functions)  

<br>

## Lecture 

[Slides from Lecture 4](https://pjakiela.github.io/ECON370/ECON370-L4-ols-2024-handout.pdf) 

<br>

## Lab

Objective: in this lab, you will simulate data-generating processes and then recover OLS coefficients through numerical minimization of the residual sum of squares (RSS).  

The lab has eight steps:  

1. Generate a simple data set where X is a standard normal and Y is 2X plus a standard normal error term.
2. Save the OLS coefficients from a regression of Y on X.
3. Calculate the OLS coefficients "by hand" using the formula given in lecture.
4. Set up a grid search by defining a range of candidate values of beta.
5. Define a function that calculates the RSS for a given candidate value of beta.
6. Find the candidate beta that minimizes the RSS.
7. Find the beta that minimizes the RSS using R or Python's numerical minimization functions.
8. Repeat the process for a multivariate regression.

A text file outlining the steps in the lab is available [here](ECON370-lab4.txt).  When you are finished with the lab, 
you can upload it [here](https://www.gradescope.com/courses/854937/assignments/5082657/).
