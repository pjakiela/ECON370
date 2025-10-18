
## ECON 370 LAB 7 (OPTIONAL): RIDGE REGRESSION AND LASSO 
## NAME:  
## DATE:  


# preliminaries ---------------------------------------------------------------

import numpy as np
import pandas as pd
import statsmodels.api as sm 
from sklearn import linear_model

# generate data ---------------------------------------------------------------

## generate X variables
np.random.seed(8675309)
datasize = 400
numvars = 80
X = np.random.randn(datasize, numvars)

## generate Y from some of the X variables
Y = X[:, 0] + X[:, 1] + X[:, 2] + X[:, 3] + X[:, 4]+ np.random.randn(datasize)
data = pd.DataFrame({'Y': Y, 'X': X})
print(data)

## OLS ------------------------------------------------------------------------

olsmodel = sm.OLS(Y, sm.add_constant(X)).fit() 
print(olsmodel.summary())

# lasso ------------------------------------------------------------------------

## run lasso with a very small penalty parameter
small_penalty = 0.01
lasso_small_penalty = linear_model.Lasso(alpha=small_penalty)
lasso_small_penalty.fit(X, Y)
lasso_small_coefs = lasso_small_penalty.coef_

## raise the penalty until some coefficients are set to 0
## raise the penalty until *all* coefficients are set to 0

## does lasso correctly identify the variables used to construct Y?
## with what penalty?

# ridge regression -------------------------------------------------------------

## use Ridge() in place of Lasso() to estimate a ridge regression

# sklearn has a separate ElasticNet() for elastic net








