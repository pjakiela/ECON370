
## ECON 370 LAB 7 (OPTIONAL): RIDGE REGRESSION AND LASSO 
## NAME:  
## DATE:  


# preliminaries ----------------------------------------------------------------

## libraries

#install.packages("tidyverse")
#install.packages("glmnet")

library(tidyverse)
library(glmnet)


# generate data ----------------------------------------------------------------

## generate X variables
set.seed(8675309)
datasize <- 400
numvars <- 80

## generate Y from some of the X variables
X <- matrix(rnorm(datasize*numvars), datasize, numvars)
Y <- X[,1] + X[,2] + X[,3] + X[,4] + X[,5] + rnorm(datasize)
data <- data.frame(Y, X)
X <- as.matrix(X)
Y <- as.matrix(Y)

# OLS --------------------------------------------------------------------------

## look at OLS coefficients
ols <- lm(Y ~ + X, data = data) 
summary(ols)

# lasso ------------------------------------------------------------------------

## run lasso with a very small penalty parameter
small_lambda <- 0.0001
lasso_small_penalty <- glmnet(X, Y, alpha = 1, lambda = small_lambda)
lasso_small_penalty$beta

## raise the penalty until some coefficients are set to 0
## raise the penalty until *all* coefficients are set to 0

## does lasso correctly identify the variables used to construct Y?
## with what penalty?

# ridge regression -------------------------------------------------------------

## now change alpha to 0 to estimate a ridge regression on the same data

# setting the alpha between 0 and 1 allows for elastic net
