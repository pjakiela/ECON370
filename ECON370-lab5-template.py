
## ECON 370 LAB 5:  CROSS-VALIDATION 
## NAME:  
## DATE:  


# preliminaries ---------------------------------------------------------------

import numpy as np
import pandas as pd
import statsmodels.api as sm
from sklearn.preprocessing import PolynomialFeatures
import matplotlib.pyplot as plt


# step 0 : load data, generate unique ID variable -----------------------------

url = 'https://raw.githubusercontent.com/pjakiela/ECON370/refs/heads/gh-pages/ECON370-lab5-data.csv'


# setup -----------------------------------------------------------------------

## define datasize as the number of rows in your data set


## add a row data_id that is indicates the row number in the original data set


# step 1: fit the model with 2 polynomial terms, calculate test and train MSE -
    
## 1a: split the data into test vs. training samples (ie two folds)

np.random.seed(314159)
folds = np.random.permutation(np.tile(np.arange(1, 3), (datasize // 2) + 1)[:datasize])
train_data = lab5data[folds != 1]
test_data = lab5data[folds == 1]

## 1b: fit model, calculate training MSE from the residuals

poly = PolynomialFeatures(degree=2, include_bias=False)
X_train_poly = poly.fit_transform(train_data[['log_gdp']])
model = sm.OLS(train_data['mean_edu'], sm.add_constant(X_train_poly)).fit()  
train_mse = np.mean(model.resid**2)
    
## 1c: predict yhat for test sample, calculate test MSE

X_test_poly = poly.transform(test_data[['log_gdp']])
test_yhat = model.predict(sm.add_constant(X_test_poly))
test_mse = np.mean((test_data['mean_edu'] - test_yhat)**2)  

## 1d: predict yhat for training data following 1c, (re)calculate training MSE


## 1e: print your results - train_mse should match check_mse

print("Training data MSE: ", round(train_mse, 4))
print("Test data MSE: ", round(test_mse, 4))
print("Check MSE should equal training data MSE: ", round(check_mse, 4))
    

# step 2: loop through different numbers of polynomial terms ------------------

## write a loop that calculates test, train, and check mse for different...
##    numbers of polynomial terms, from 1 through 8

## 2a: define max_order, the number of polynomial terms to consider (set it to 8)


## 2b: create 3 blank max_orderX1 vectors train_mse, test_mse, and check_mse

## Hint: use np.full()


## 2c: extend the code for the loop below to calculate train, test, and check MSE

for i in range(1, max_order + 1):
    
    j = i - 1 # Python indices start from 0
    poly = PolynomialFeatures(degree=i, include_bias=False)
    X_train_poly = poly.fit_transform(train_data[['log_gdp']])
    model = sm.OLS(train_data['mean_edu'], sm.add_constant(X_train_poly)).fit()  
    train_mse[j] = np.mean(model.resid**2)


## 2d: check that train_mse - check_mse sums to 0

diff_check = train_mse - check_mse
print(diff_check.sum())

## 2e: store results with an index indicating the number of polynomial terms

poly_id = np.tile(np.arange(1, max_order + 1), 1)

results = pd.DataFrame({
    'poly_id': poly_id, 
    'train_mse': train_mse, 
    'test_mse': test_mse, 
    'check_mse': check_mse, 
    'diff_check': diff_check
})

print(results)


# step 3: implement 10-fold cross-validation ----------------------------------

## 3a: define num_folds (we'll use 10)


## 3b: create a fold_id vector that is max_order (ie 8) copies of 1 followed by 
#   max_order copies of 2, etc... up to the final fold

## Hint: use np.repeat()
    

## 3c: create a poly_id vector - the sequence 1:max_order repeated num_folds times

## Hint: use np.tile()


## 3d: create 3 blank (NA) vectors train_mse, test_mse, and check_mse 
## they need to be the same length as fold_id and poly_id


# 3e: set the seed and randomly assign each observation to one of 10 folds

## 3f: do the cross-validation and store output

## Hint: extend the code from Step 2 so that you loop over your 10 folds


## 3g: collapse your results so that you average across the 10 folds

## Which number of polynomial terms minimizes test MSE?

## Hint: use .groupby().agg() 



# Step 4: graph the results ---------------------------------------------------

# make a scatter plot w/ polynomial degree as x and test MSE as y
# save your graph as a pdf 


  


