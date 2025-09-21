
## ECON 370 LAB 4:  OLS 
## NAME:  
## DATE:  


# preliminaries ---------------------------------------------------------------

import numpy as np
import pandas as pd
import statsmodels.api as sm
import statsmodels.formula.api as smf
from scipy.optimize import minimize

## set the seed for replicability
np.random.seed(8675309)

# bivariate OLS, no constant --------------------------------------------------

## Step 1:  generate a data set -----------------------------------------------
##   - set a datasize parameter set to 200
##   - generate X = a vector of 200 draws from a standard normal
##   - generate Y = 2X + a normal error with mean = 0 and sd = 8 (so no constant)
##   - put X and Y in a data frame called data

## Hint 1: np.randn() takes draws from a standard normal
## Hint 2:  np.random.normal() takes arguments loc and scale for any normal



## Step 2:  regress Y on X and save the results -------------------------------

## Hint 1: use statsmodels.formula.api's ols()
## Aside: statsmodels.api is OK too if you prefer; smf is closer to R/Stata
## Hint 2: add - 1 to your formula to remove the constant



## Step 3: calculate the OLS coefficient betahat "by hand" --------------------
##    using the formula on slide 10



## Step 4: find betahat by minimizing the RSS ---------------------------------

## First, define beta_min and beta_max as limits of search window, -10 to 10
## Then, set beta_steps = 100000
## Then, define trial_betas as a sequence of beta_steps from beta_min to beta_max

## Hint #1: use np.linspace() to create an array with 10k trial betas
## Hint #2: use .reshape(-1, 1) to turn it into a column vector 



## Step 5: define the RSS(beta) function --------------------------------------

## Define a function RSS(beta) that 
## (1) multiplies X times a candidate beta 
## and then (2) calculates, squares, and sums the residuals

def RSS(beta):
    y_hat = X * beta   
    return np.sum((Y - y_hat)**2) 

rss_results = np.array([RSS(beta) for beta in trial_betas])

results = pd.DataFrame({
    'trial_betas': trial_betas.flatten(),  # Convert column vector to 1D array
    'rss_results': rss_results
})

## Step 6: find the trial beta that minimizes the RSS -------------------------
    
## create a data frame of the trial beta values and associated RSSs,
##   then find the value of beta that minimizes the RSS

## Hint: use df['col'].idxmin() to find the index of the min of df['col']



## Step 7: find the optimal beta using numerical optimization -----------------

##  Hint 1: first, define a 1x1 array of starting values of 0
##  Hint 2: use scipi.optimize's minimize() 

b0 = np.array([0.0])
result = minimize(RSS, b0, method='BFGS', options={'maxiter': int(1e5)})
print(f"Optimized beta: {result.x[0]}")


# Step 8: multivariate regression ---------------------------------------------

## Replicate Steps 1, 2, 5 + 7 to find the OLS coefficients when: 
##    datasize = 2000
##    X has six columns (X1 through X6) all of which are standard normals
##    Y = 2*X1 + 3*X2 + a standard normal error term
##    You want to run an OLS regression of Y on X including a constant
## Define a vector check that indicates whether the parameter estimates from 
##    numerical optimization are within 0.001 of the OLS coefficients

## Step 8 should have four parts
## 8a: generate the data
## 8b: regress Y on X and save the results
## 8c: define the function RSS (beta)
## 8d: use minimize() to find the beta that minimizes the RSS
## 8e: define the array check to check your results

## Hint 1: add a constant to X before using the RSS function (sm.add_constant())
## Hint 2: use @ for matrix multiplication

