
## ECON 370 LAB 9: CAUSAL FORESTS 
## NAME:  
## DATE:  


# step 0: preliminaries -------------------------------------------------------

# install packages (if you have not already) and then load associated libraries
# you are going to need:

##     numpy, pandas, matplotlib.pyplot, and statsmodels.api (just as in Labs 7 and 8)
##     DummyClassifier and DummyRegressor from sklearn.dummy
##     CausalForestDML from econml.dml (for the causal forest)


# step 1: load and prep EMERGE data --------------------------------------------

## load the data set ECON370-lab9-cf-data.csv directly from github
## convert the enumerator and strata variables to category dummies 
## drop observations missing the outcome variable, story_comp
## impute other missing values 



# step 2: OLS estimate of the average treatment effect ------------------------

## regress story_comp on treatment, clustering
## standard errors at the village level (schoolrespid)

## Hint: sm.OLS(...).fit() takes cov_type = 'cluster' and cov_kwds = {'groups': ...}



# step 3: define variables and matrices needed for causal forest ---------------

## 3a. the dependent variable is storybook comprehension (story_comp)



## 3b. Create a vector W that is the treatment dummy



## 3c. Store the schoolrespid (i.e. village ID) variable...
## ... for use later (keeping villages together when the forest splits the sample)



## 3d. define covars as your clean data frame minus the variables above...
## ... and define X as the matrix of covariates (econml accepts a data frame)



## 3e. define model_W and model_Y, the models used to predict treatment and Y
## Python users: econml wants a model object rather than a vector of predictions
##    DummyClassifier(strategy = 'prior') predicts the mean of W (the share treated)
##    DummyRegressor(strategy = 'constant', constant = 0) predicts 0 for Y

model_W = DummyClassifier(strategy = 'prior')
model_Y = DummyRegressor(strategy = 'constant', constant = 0)


# step 4: "train" a causal forest ----------------------------------------------

cf = CausalForestDML(model_t = model_W,         # model to use to predict treatment (double ML)
                     model_y = model_Y,         # model to use to predict Y (in double ML)
                     discrete_treatment = True, 
                     n_estimators = 200, 
                     random_state = 8675309)

cf.tune(Y, W, X = X, groups = village)          # tune the forest parameters (as in R)
cf.fit(Y, W, X = X, groups = village)


# step 5: calculate the average treatment effect -------------------------------

## Hint: the doubly robust ATE and its standard error are stored in cf.ate_ and cf.ate_stderr_

## How do the estimated ATE and standard error compare to the OLS results?

## How do the point estimate and standard error change if you let CausalForestDML...
## ...estimate an ML model of Y (model_y = 'auto')? What if you set model_Y to...
## ...predict the mean of Y (DummyRegressor(strategy = 'mean'))?
## Which approach seems preferable?



# step 6: estimate individual-level CATEs ---------------------------------------

## Hint: the CATE estimate for each observation is cf.effect(X)
## Make a nice-looking histogram to illustrate the distribution of CATEs
## Save your histogram as a pdf (so you can upload it to gradescope)



# step 7: is there statistically significant treatment effect heterogeneity? ----

## econml has no test_calibration(), so run the regression from lecture by hand:
## regress Y on (mean CATE) x W and (CATE - mean CATE) x W, with W and Y demeaned
## the second coefficient tests for heterogeneity that the forest can predict

## Hint: build the two regressors in a data frame and use sm.OLS with clustered SEs

## Can you reject the hypothesis that there is no treatment effect heterogeneity?



# step 8: identify most important predictors of treatment effect heterogeneity ----

## Hint: use cf.feature_importances_
## Hint: combine the importance measure with covars.columns in a data frame

## What are the five most important predictors of treatment effect heterogeneity?


