## ECON 370 LAB 6:  LASSO 
## NAME:  
## DATE:  


# step 0: preliminaries -------------------------------------------------------

import numpy as np
import pandas as pd
import statsmodels.api as sm
import matplotlib.pyplot as plt
from sklearn.linear_model import ElasticNet
from sklearn.linear_model import LassoCV
from sklearn.preprocessing import StandardScaler

# step 1: load data -----------------------------------------------------------

## load lab6data from the ECON 370 github page, the file ECON370-lab6-data.csv
## this is data on N = 200 children included in the EMERGE study
## familiarize yourself with the data

url = 'https://raw.githubusercontent.com/pjakiela/ECON370/refs/heads/gh-pages/ECON370-lab6-data.csv'
lab6data = pd.read_csv(url)

# step 2: prepare data --------------------------------------------------------

## define Y as the literacy column from lab5data


## enumerator and strata are IDs for the surveyor and the randomization stratum
## generate dummy variables for these (fundamentally categorical) variables

## Python hint: use pd.get_dummies() and then df.astype(int)
##     or use OneHotEncoder from sklearn.preprocessing

## for future reference:
## from sklearn.preprocessing import OneHotEncoder
## one_hot_encoder = OneHotEncoder(sparse=False, drop='first')
## encoded_features = one_hot_encoder.fit_transform(X[['strata']])
## encoded_df = pd.DataFrame(encoded_features, columns=one_hot_encoder.get_feature_names_out(['strata']))
## X = pd.concat([X.drop(columns=['strata']), encoded_df], axis=1)    



## define a data frame X that combines lab6data and the strata and enumerator dummies
## drop literacy (your Y variable) and (character variables) enumerator and strata 
## R users, make X a matrix (so that you can run lasso)



# step 3: OLS -----------------------------------------------------------------

## run an OLS regression of Y on X
## which variables are statistically significant predictors of literacy (95% level)?
## which variable has the lowest p-value? 
## what is the OLS coefficient associated with that variable?



# step 4: lasso and ridge regression ------------------------------------------

# step 4a (Python only):  rescaling the Xs ------------------------------------

## Python users: use scikit-learn's StandardScaler() to rescale the X variables
## (since ridge and lasso are not scale invariant)
## Save the names of the columns of X as a data frame X_names



# step 4b:  actually fitting ridge and lasso ----------------------------------

## Here is code for estimating a ridge regression with a very low value 
## of the tuning parameter (lambda in lecture, ISL, and R; alpha in Python)

## How does the ridge coefficient on the variable with the lowest OLS p-value
##    compare to the OLS coefficient?

## Python users: you need to convert the coefficients back to the original scale
##    by dividing them by scaler.scale_ (just ignore the intercept)
## Save them in a data frame with the names in X_names

np.random.seed(8675309)
ridge_low = ElasticNet(alpha=0.0001, l1_ratio = 0)  
ridge_low.fit(X_scaled, Y)
coefficients = ridge_low.coef_
coefficients_original = coefficients / scaler.scale_
coef_low = pd.DataFrame({
    'Feature': X.columns,  # Feature names from your DataFrame X
    'Coefficient': coefficients_original
})
coef_low

## Estimate a ridge regression with a higher tuning/penalty parameter of 1
## Make sure to set the seed immediately before estimating the model
## How does the coefficient on the variable of interest (from above) change?



## Now estimate lasso by setting the alpha (R) or l1_ratio (Python) to 1
## Set the tuning parameter back to 0.0001
## Which variables are included in the model?



## Now estimate lasso with a tuning parameter of 1
## Which variables are included in the model now?




# step 5: cross-validation ----------------------------------------------------

## cv.glmnet() in R and LassoCV in Python estimate cross-validated lasso

## define a grid of tuning parameter values to try 
grid = 10 ** np.linspace(0, -3, 100)

## set the seed and fit cross-validated lasso


## Python users:
##    LassoCV takes alphas as an argument instead of alpha, use your grid for that
##    set cv to 10 (the number of folds)
##    set the seed by setting the random_state argument
##    to make a scatter plot of your results, use lasso_cv.alphas_ as x
##       and np.mean(lasso_cv.mse_path_, axis=1) as y
##       and add a vertical line at lasso_cv.alpha_ (not alphas_)
##       to see where the test MSE is minimized

## save your graph as a pdf 



# step 6: the tuning parameter that minimizes test MSE ------------------------

## What value of the tuning parameter minimizes test MSE? 
## You can access this parameter using lasso_cv$lambda.min in R or lasso_cv.alpha_ in Python


## At this value of the tuning parameter, which variables are included in the model?

## Python users:  the coefficients are in lasso_cv.coef_, inlcuded if non-zero



# step 7: the 1SE tuning parameter --------------------------------------------

## which variables are included in the model if you use a tuning parameter that is 
##     1 SE higher than the MSE-minimizing one? 

## R users:  this value is stored as lasso_cv$lambda.1se

## Python users: as far as I can tell, scikit-learn doesn't do this, 
##    so you need to do it by hand (please, prove me wrong!)
## lasso_cv.mse_path_ is an N (observations) by k (CV folds) 
##    matrix of test MSE values
## calculate the mean test MSE across folds, 
## then find the index of the row with the minimum MSE
## the value of lasso_cv.alphas_ at this index should be lasso_cv.alpha_
## calculate the SD of the within-fold test MSEs at this index 
##    (ie the standard deviation of lasso_cv.mse_path_[mse_best_index])
## the SE of the CV estimate of the MSE is this SD / sqrt(# folds))
## add the SE to the mean test MSE at this MSE-minimizing value
## the 1SE tuning parameter is largest value that yields a test MSE below that sum

## use the code from step 4 to estimate lasso with this tuning parameter



# step 8: data-driven lasso of Belloni et al. ---------------------------------

## Python users skip this step 
## (AFAIK, Belloni et al. data-driven lasso is not available in Python)


# step 9 (optional): adding noise variables -----------------------------------

## add 50 additional X variables that are iid standard normals
## run lasso
## how many are chosen using the CV-selected tuning parameter?