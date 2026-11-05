
## ECON 370 LAB 9: CAUSAL FORESTS 
## NAME:  
## DATE:  


# step 0: preliminaries -------------------------------------------------------

# install packages (if you have not already) and then load associated libraries
# you are going to need:

##     tidyverse, fastDummies (just as in Labs 7 and 8)
##     fixest (for the OLS regression)
##     grf (for the causal forest)


# step 1: load and prep EMERGE data --------------------------------------------

## load the data set ECON370-lab9-cf-data.csv directly from github
## convert the enumerator and strata variables to category dummies 
## drop observations missing the outcome variable, story_comp
## impute other missing values 



# step 2: OLS estimate of the average treatment effect ------------------------

## regress story_comp on treatment, clustering
## standard errors at the village level (schoolrespid)

## Hint: use feols() from the fixest package



# step 3: define variables and matrices needed for causal forest ---------------

## 3a. the dependent variable is storybook comprehension (story_comp)
## Hint: it needs to be stored as a vector



## 3b. Create a vector W that is the treatment dummy



## 3c. Store the schoolrespid (i.e. village ID) variable...
## ... as an integer for use later (village-level clustering)



## 3d. define covars as your clean data frame minus the variables above...
## ... and define X as a matrix version of covars



## 3e. define W_hat and Y_hat, your predicted values of treatment and Y

W_hat <- mean(W)
Y_hat <- 0


# step 4: "train" a causal forest ----------------------------------------------

cf <- causal_forest(X, # X variables
                    Y, # outcome
                    W, # treatment variable
                    Y.hat = Y_hat, # model to use to predict Y (in double ML)
                    W.hat = W_hat, # model to use to predict treatment (double ML)
                    clusters = village, 
                    tune.parameters = "all", 
                    num.trees = 200, 
                    seed = 8675309)


# step 5: calculate the average treatment effect -------------------------------

## Hint: use average_treatment_effect()

## How do the estimated ATE and standard error compare to the OLS results?

## How do the point estimate and standard error change if you let causal_forest...
## ...estimate an ML model of Y? What if you set Y_hat to the mean of Y (a la W)?
## Which approach seems preferable?



# step 6: estimate individual-level CATEs using OOB predictions ----------------

## Hint: OOB predictions are stored in predict(cf)$predictions
## Make a nice-looking histogram to illustrate the distribution of CATEs
## Save your histogram as a pdf (so you can upload it to gradescope)



# step 7: is there statistically significant treatment effect heterogeneity? ----

## Hint: use test_calibration() as described in lecture

## Can you reject the hypothesis that there is no treatment effect heterogeneity?



# step 8: identify most important predictors of treatment effect heterogeneity ----

## Hint: use variable_importance()
## Hint: combine the importance measure with names(covars) in a data frame

## What are the five most important predictors of treatment effect heterogeneity?


