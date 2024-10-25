
## ECON 370 LAB 7:  TREES 
## NAME:  
## DATE:  


# step 0: preliminaries -------------------------------------------------------

## libraries
import os
import numpy as np
import pandas as pd
import sklearn.model_selection as skm
import statsmodels.api as sm
from matplotlib.pyplot import subplots
from sklearn.tree import (DecisionTreeRegressor as DTR, 
                          plot_tree)
from sklearn.ensemble import (RandomForestRegressor as RF, 
                              GradientBoostingRegressor as GBR)

## file path


# step 1: load Kenya 2014 births recode -----------------------------------------------

## load the 2014 Kenya DHS births recode stata file, KEBR72FL.dta

dhs = pd.read_stata(pjpath + "data/raw-dhs/KEBR72DT/KEBR72FL.dta")
dhs = dhs[dhs['midx'].notna()] ## keep only kids born in last 5 yrs
dhs = dhs[dhs['b5'] == 'yes'] ## keep only kids who are still alive
dhs = dhs[dhs['v135'] == 'usual resident'] ## drop moms who are visiting interview HH

### check: at this point, you should have a data frame with 19,625 rows and 1,166 columns

print(dhs.shape)


# step 2: choose variables for tree -------------------------------------------

## this code selects, renames, and in some cases cleans some key predictors

## add the following DHS variables to your data for use in your trees:
##    region of Kenya (v024), urban/rural, water source, sanitation facilities, 
##    electricity, mother's education in years (numeric), household size, 
##    sex of the household head, whether the toilet facilities are shared, 
##    cooking fuel, wealth index, mother's age at first birth, 
##    whether the mother owns her home (alone or with a partner), 
##    whether the mother owns her land (alone or with a partner), 
##    whether the child was wanted by mother, place of birth (e.g. hospital, home)

## Info on the variables is contained in KEBR72FL.do, KEBR72FL.frq, and KEBR72FL.map

treedata = dhs[['kidid', 'hw70', 
                'hw1', 'bord', 'b0', 'b1', 'b2', 'b4', 'b11', 
                'v012',]].copy()
treedata = treedata.rename(columns={
    'hw70': 'haz',
    'hw1': 'age_months', 
    'b1': 'mob', 
    'b2': 'yob', 
    'b4': 'sex',
    'b11': 'interval', 
    'v012': 'mom_age',
    })

## drop observations with missing height-for-age z-scores
treedata['haz'] = pd.to_numeric(treedata['haz'], errors='coerce')
treedata = treedata.dropna(subset=['haz'])

## idiosyncratic cleaning

## change age at time of survey to age at birth
treedata['mom_age'] = treedata['mom_age'] - (2014 - treedata['yob'])

## twin dummy
treedata['twin'] = np.where(treedata['b0'] == "single birth", 0, 1)
treedata = treedata.drop(columns={'b0'})

## birth interval cannot be NAN (first births), replace with median
treedata.interval.fillna(np.nanmedian(treedata['interval']), inplace=True)

treedata['mom_edu'] = pd.to_numeric(treedata['mom_edu'])


# step 3: convert categorical variables to dummies ----------------------------

## python: use get_dummies

treedata = pd.get_dummies(treedata, 
                          columns=["mob", 
                                   "yob",
                                   "sex",
                                   ], 
                          prefix = ["mob", 
                                    "yob",
                                    "sex",
                                    ], 
                          dummy_na=True, 
                          dtype=int)
  

# step 4: create test and training data sets  ---------------------------------

## assign 40 percent of the observations to the training data set

D = treedata.drop(columns=['haz'])
feature_names = list(D)
X = np.asarray(D)

(X_train, 
 X_test, 
 y_train, 
 y_test) = skm.train_test_split(X, 
                                treedata['haz'], 
                                test_size = 0.4, 
                                random_state = 8675309)

                                
# step 5: OLS benchmark -------------------------------------------------------

## calculate the test MSE for two OLS benchmarks:
##    1. using the mean of Y as the predictor (ie a tree with 0 splits)
##        (you can do this by regressing Y on a constant in the training data)
##    2. running OLS with all the X variables in the training data

                         
# step 6: fitting a regression tree -------------------------------------------

## fit a simple regression tree using the training data and plot the output
## use the tree to predict Y in the test data and calculate the test MSE

### python users:  explore changing the max_depth parameter to 1, 3, or 4
### how does this change the test mse?

### R users: the tree package doesn't allow you to control the depth of the tree
### you can try doing this with the rpart package if you want...

reg = DTR(max_depth = 2)
mytree = reg.fit(X_train, y_train)
ax = subplots(figsize=(24,24))[1]
plot_tree(reg, 
          feature_names = feature_names, 
          ax = ax);

y_hat = mytree.predict(X_test)
tree_mse = np.mean((y_test - y_hat)**2)


# step 7: fit a random forest -------------------------------------------------

## bagging is fitting a random forest that consider all the Xs at every split 
## how does the bagged test MSE compare to the test MSE from a single tree?

## update the # of Xs considered at each split to fit a random forest 
## the norm is to try about the square root of the # of Xs, 
##    but test out a few options to see what improves fit
## you can also try increasing the number of trees from 100 to 200 or 500

## how many variables do you consider at each split in your preferred RF?
## which variables are the most important?

## does your preferred RF outperform OLS?
 
bag_dhs = RF(max_features = 133, 
               n_estimators = 100, 
               random_state = 0).fit(X_train, y_train)
yhat_bag = bag_dhs.predict(X_test)
mse_bag = np.mean((y_test - yhat_bag)**2)

feature_imp = pd.DataFrame(
    {'importance':bag_dhs.feature_importances_},
    index=feature_names)
with pd.option_context('display.max_rows', None,):
    print(feature_imp.sort_values(by='importance', ascending=False))


# step 8: fit gradient-boosted trees ------------------------------------------

## how does the test MSE of gradient-boosted trees compare to that of a RF?

boost_dhs = GBR(n_estimators=100,
                   learning_rate=0.001,
                   max_depth=2,
                   random_state=0)
boost_dhs.fit(X_train, y_train)

test_error = np.zeros_like(boost_dhs.train_score_)
for idx, y_ in enumerate(boost_dhs.staged_predict(X_test)):
    test_error[idx] = np.mean((y_test - y_)**2)

plot_idx = np.arange(boost_dhs.train_score_.shape[0])
ax = subplots(figsize=(12,12))[1]
ax.plot(plot_idx, 
        boost_dhs.train_score_, 
        'b', 
        label = 'Training')
ax.plot(plot_idx, 
        test_error, 
        'r', 
        label = 'Test')
ax.legend();

y_hat_boost = boost_dhs.predict(X_test);
mse_boost = np.mean((y_test - y_hat_boost)**2)
