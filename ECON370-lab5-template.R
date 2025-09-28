
## ECON 370 LAB 5:  CROSS-VALIDATION 
## NAME:  
## DATE:  


# preliminaries ----------------------------------------------------------------

library(tidyverse)


# step 0 : load data, generate unique ID variable ------------------------------

urlfile <- 'https://raw.githubusercontent.com/pjakiela/ECON370/refs/heads/gh-pages/ECON370-lab5-data.csv'


## define datasize as the number of rows in your data set


## add a row data_id that is indicates the row number in the original data set

## Hint: use seq()


# step 1: fit the model with 2 polynomial terms, calculate test and train MSE --

## 1a: split the data into test vs. training samples (ie two folds)

set.seed(8675309)
folds <- sample(rep(1:2, length = datasize))
train_data <- filter(lab5data, folds != 1)
test_data <- filter(lab5data, folds == 1)

## 1b: fit model, calculate training MSE from the residuals
  
ols <- lm(mean_edu ~ poly(log_gdp, 2, raw = TRUE), data = train_data)
train_mse <- mean(ols$residuals^2)

## 1c: predict yhat for test sample, calculate test MSE

test_xmat <- tibble(rep(1, length(test_data$mean_edu)), poly(test_data$log_gdp, 2, raw = TRUE))
test_yhat <- as.matrix(test_xmat) %*% as.matrix(ols$coefficients)
test_mse <- mean((test_data$mean_edu - test_yhat)^2)

## 1d: predict yhat for training data following 1c, (re)calculate training MSE


## 1e: print your results - train_mse should match check_mse

print(paste("Training data MSE:", round(train_mse, 4)))
print(paste("Test data MSE:", round(test_mse, 4)))
print(paste("Check MSE should equal training data MSE:", round(check_mse, 4)))


# step 2: loop through different numbers of polynomial terms -------------------

## write a loop that calculates test, train, and check mse for different...
##    numbers of polynomial terms, from 1 through 8

# define max_order, the maximum number of polynomial terms to consider (set it to 8)


# define num_folds (we'll use 10)


## 2b: create 3 blank max_orderX1 vectors train_mse, test_mse, and check_mse 



## 2c: extend the code for the loop below to calculate train, test, and check MSE

for (i in 1:max_order) {
  ols <- lm(mean_edu ~ poly(log_gdp, i, raw = TRUE), data = train_data)
  train_mse[i] <- mean(ols$residuals^2)
  
}

## 2d: check that train_mse - check_mse sums to 0

print(sum(train_mse - check_mse))

## 2e: store results with an index indicating the number of polynomial terms

poly_id <- seq(1:max_order)

results <- tibble(poly_id, train_mse, test_mse, check_mse) 
print(results)


# step 3: implement 10-fold cross-validation ----------------------------------

## 3a: define num_folds (we'll use 10)


## 3b: create a fold_id vector that is max_order (ie 8) copies of 1 followed by 
##   max_order copies of 2, etc... up to the final fold

## Hint: use rep()


# create a poly_id (for the number of polynomial terms used) that is a sequence from 1 to max_order 
#   repeated num_fold times in a column vector

## Hint: use seq() and then rep()


## 3d: create 3 blank (NA) vectors train_mse, test_mse, and check_mse 
## they need to be the same length as fold_id and poly_id


# 3e: set the seed and randomly assign each observation to one of 10 folds


## 3f: do the cross-validation and store output



## 3g: collapse your results so that you average across the 10 folds

## Which number of polynomial terms minimizes test MSE?



# Step 4: graph the results ---------------------------------------------------

# make a scatter plot w/ polynomial degree as x and test MSE as y
# save your graph as a pdf 



