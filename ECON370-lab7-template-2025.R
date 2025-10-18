
## ECON 370 LAB 7:  LASSO AND PDS LASSO
## NAME:  
## DATE:  


# step 0: preliminaries --------------------------------------------------------

## You will need: tidyverse, glmnet, hdm, fastDummies, and broom


# step 1: load data --------------------------------------------------------------------

## load lab7data from the ECON 370 github page, the file ECON370-lab7-data.csv
## this is data on N = 200 children included in the EMERGE study
## familiarize yourself with the data

urlfile <- 'https://raw.githubusercontent.com/pjakiela/ECON370/refs/heads/gh-pages/ECON370-lab7-data.csv'
lab7data <- read_csv(urlfile)


# step 2: prepare data ---------------------------------------------------------

## 2a. define Y as the literacy column from lab7data

## What is the variance of Y?



## 2b. create an X matrix that is lab7data without literacy, convert categoricals to dummies

## enumerator and strata are IDs for the surveyor and the randomization stratum
## generate dummy variables for these (fundamentally categorical) variables
## drop the dummy for the first category

## Hint: use dummy_cols() from fastDummies to generate dummies, remove_first_dummy option
## Hint: make X a matrix (this will be important later)


# step 3: OLS ---------------------------------------------------------------

## run an OLS regression of Y on X
## which variables are statistically significant predictors of literacy (95% level)?
## which variable has the lowest p-value? 

## Hint: use tidy from the broom() package to quickly clean up results


# step 4: lasso and ridge regression -------------------------------------------

# step 4a (Python only):  rescaling the Xs -------------------------------------

## Python users: use scikit-learn's StandardScaler() to rescale the X variables
## (since ridge and lasso are not scale invariant)
## Save the names of the columns of X as a data frame X_names

## R users:  skip this step (R does this automatically)

# step 4b:  ridge and lasso ----------------------------------------------------

## Here is code for estimating a ridge regression with a very low value 
## of the tuning parameter (lambda in lecture, ISL, and R; alpha in Python)

## How does the ridge coefficient on the variable with the lowest OLS p-value
##    compare to the OLS coefficient?

ridge_low <- glmnet(X, Y, alpha = 0, lambda = 10^-3)
coef(ridge_low)
ridge_low$beta[12]

## Estimate a ridge regression with a higher tuning/penalty parameter of 1
## Make sure to set the seed immediately before estimating the model
## How does the coefficient on the variable of interest (from above) change?


## Now estimate lasso by setting the alpha (R) or l1_ratio (Python) to 1
## Set the tuning parameter back to 0.0001
## Which variables are included in the model?


## Now estimate lasso with a tuning parameter of 1
## Which variables are included in the model now?


## Find the lowest value of the tuning parameter that leads to...
##     all the coefficients being set to 0



# step 5: cross-validation -----------------------------------------

## cv.glmnet() in R and LassoCV in Python estimate cross-validated lasso

## define a grid of tuning parameter values to try 
grid <- 10^seq(0, -3, length = 100)

## set the seed and fit cross-validated lasso

## R users:
##    cv.glmnet takes the same arguments as glmnet
##    use grid as your lambda
##    define lasso_cv as the lasso model that you fit
##    type plot(lasso_cv) afterward to see MSE as a function of lambda

## save your graph as a pdf 



# step 6: the tuning parameter that minimizes test MSE -------------------------

## 6a. What value of the tuning parameter minimizes test MSE? 
## You can access this parameter using lasso_cv$lambda.min in R or lasso_cv.alpha_ in Python


## 6b. At this value of the tuning parameter, which variables are included in the model?
## R users:  use predict(lasso_cv, type = "coefficients", s = [your lambda value]) 
## Python users:  the coefficients are in lasso_cv.coef_, inlcuded if non-zero



# step 7: data-driven lasso of Belloni et al. (R only) -------------------------

## R users: you can access the data-driven lasso model using rlasso()
## the formula is Y ~ X, and set post = FALSE
## use summary() to look at the results
## which variables are included in the model?

## Python users skip this step 
## (AFAIK, Belloni et al. data-driven lasso is not available in Python)

