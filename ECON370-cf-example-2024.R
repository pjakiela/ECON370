
## ECON 370: CAUSAL FOREST EXAMPLE
## ECON 370: CAUSAL FOREST EXAMPLE


# step 0: preliminaries --------------------------------------------------------

## libraries
# install.packages("tidyverse")
# install.packages("grf")
# install.packages("policytree")
# install.packages("DiagrammeR")
# install.packages("tree")

library(tidyverse)
library(grf)
library(policytree)
library(DiagrammeR)
library(tree)

# generate data ---------------------------------------------------------------

## set seed
set.seed(8675309)

## define parameters
N <- 2000 # number of observations
p <- 6 # number of variables

## generate covariates X and binary treatment W
X <- matrix(rnorm(N * p), N, p) 
W <- sample(rep(c(0,1), N/2))
W_hat = mean(W)
Y_hat = 0

## treatment effect varies with X1
Y <- W + pmax(X[, 1], 0) * W + X[, 2] - pmin(X[, 3], 0) + rnorm(N)

## true individual-level treatment effect (based on formula above)
tau  <- 1 + pmax(X[, 1], 0) * 1
mean_tau  <- mean(tau)

# plot a histogram of the actual taus / conditional average treatment effects
hist(tau, 
     breaks = 28, 
     col = "lightblue", 
     main = "Actual Treatment Effects",
     xlab = "Individual Treatment Effects", 
     ylab = "Frequency")

# estimate a causal forest ----------------------------------------------------

## R users: here we shut down the double ML aspect (predicted Y is 0, predicted W is mean)
## removing Y.hat and W.hat arguments will default to using random forests to predict Y, W

## Python users: 'auto' tries a range of different ML approaches and chooses
##    the one that minimizes CV MSE to predict treatment and outcome Y
## I recommend setting model_t and model_y equal to 
##    RF(n_estimators=200, random_state=8675309)
##    to avoid errors when you move to the DHS data

cf <- causal_forest(X, # X variables
                    Y, # outcome
                    W, # treatment variable
                    Y.hat = Y_hat, # model to use to predict Y (in double ML)
                    W.hat = W_hat, # model to use to predict treatment (double ML)
                    tune.parameters = "all", 
                    num.trees = 200, 
                    seed = 8675309)


# results from a causal forest ----------------------------------------------------

## CF prediction of the average treatment effect
## made using some obscure double ML technique so take with a grain of salt
cf_ate <- average_treatment_effect(cf) 
cf_ate 

## R users: assess whether the causal forest succeeded in capturing heterogeneity
cf_test <- test_calibration(cf)
cf_test

## identify most important predictors of treatment effect heterogeneity
cf_importance <- variable_importance(cf)
cf_importance

## there is no hard and fast rule for choosing important predictors...
cf_select_vars <- which(cf_importance > mean(cf_importance))
cf_select_vars

## estimate treatment effects for the training data using out-of-bag predictions
tau_hat_oob  <- predict(cf)$predictions

## plot a histogram of the estimated OOB conditional average treatment effects (tau)
hist(tau_hat_oob, 
     breaks = 28, 
     col = "tomato", 
     main = "Out-of-Bag Predicted Treatment Effects",
     xlab = "Estimated Treatment Effect", 
     ylab = "Frequency")

## compare the estimated treatment effect in high and low CATE groups (OOB estimates)
high_effect <- tau_hat_oob > median(tau_hat_oob)
cate_high <- average_treatment_effect(cf, subset = high_effect)
cate_low <- average_treatment_effect(cf, subset = !high_effect)
cate_high
cate_low

## Python users: plot a single tree based on the causal forest
## you used to be able to do this with the policytree package in R, ...
##    but I can no longer get it to work


