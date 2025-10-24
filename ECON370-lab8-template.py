
## ECON 370 LAB 8:  REGRESSION TREES AND RANDOM FORESTS
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
username = os.getenv("USERNAME")
pjpath = f"C:/Users/{username}/Dropbox/ECON-370/"


# step 1: load Kenya 2014 births recode ---------------------------------------

## load the 2014 Kenya DHS births recode stata file, KEBR72FL.dta
## select only living children under 5 years old whose mothers were interviewed

dhs = pd.read_stata(pjpath + "data/raw-dhs/KEBR72DT/KEBR72FL.dta")
dhs = dhs[dhs['midx'].notna()] ## keep only kids born in last 5 yrs
dhs = dhs[dhs['b5'] == 'yes'] ## keep only kids who are still alive
dhs = dhs[dhs['v135'] == 'usual resident'] ## drop moms who are visiting interview HH

### check: at this point, you should have a data frame with 19,625 rows and 1,166 columns

print(dhs.shape)


# step 2: choose variables for tree/forest ------------------------------------

## this code selects, renames, and in some cases cleans some key predictors

## select the following variables for use in your trees:
##    hw70 (height-for age, the outcome of interest),  child sex,
##    whether the child is a single birth or a twin/triplet,
##    child age in months, birth order, month of birth, year of birth, 
##    mother's age, urban/rural, water source, sanitary facilities, 
##    electricity, mother's education in years (numeric), household size, 
##    sex of the household head, 
##    cooking fuel, wealth index, 
##    place of birth/delivery (e.g. hospital, home)

## Info on the variables is contained in KEBR72FL.do, KEBR72FL.frq, and KEBR72FL.map

treedata = dhs[['hw70', 
                'hw1', 'bord', 'b0', 'b1', 'b2', 'b4', 
                'v012', 'v025', 'v133', 'v113', 'v116', 'v119', 'v136', 
                'v151', 'v161', 'v190', 'm15']].copy()
treedata = treedata.rename(columns={
    'hw70': 'haz',
    'hw1': 'age_months', 
    'b1': 'mob', 
    'b2': 'yob', 
    'b4': 'sex',
    'v012': 'mom_age',
    'v025': 'location',
    'v113': 'water',
    'v116': 'toilet', 
    'v119': 'power',
    'v133': 'mom_edu', 
    'v136': 'hh_size', 
    'v151': 'HH_head_sex',
    'v161': 'fuel', 
    'v190': 'wealth_index',
    'm15': 'place_of_birth'
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

treedata['mom_edu'] = pd.to_numeric(treedata['mom_edu'])

## EXTEND THIS CODE TO DO ANY ADDITIONAL CLEANING THAT YOU CHOOSE: 
    
## here is how the DHS recommends coding safe water sources:
## https://dhsprogram.com/data/Guide-to-DHS-Statistics/Household_Drinking_Water.htm

## here is how the DHS recommends coding improved sanitary facilities:
## https://dhsprogram.com/data/Guide-to-DHS-Statistics/Type_of_Sanitation_Facility.htm

## here is how the DHS recommends coding places of delivery:
## https://dhsprogram.com/data/Guide-to-DHS-Statistics/Place_of_Delivery.htm

treedata['wealth_index'] = np.where(treedata['wealth_index'] == "poorest", "1", treedata['wealth_index'])
treedata['wealth_index'] = np.where(treedata['wealth_index'] == "poorer", "2", treedata['wealth_index'])
treedata['wealth_index'] = np.where(treedata['wealth_index'] == "middle", "3", treedata['wealth_index'])
treedata['wealth_index'] = np.where(treedata['wealth_index'] == "richer", "4", treedata['wealth_index'])
treedata['wealth_index'] = np.where(treedata['wealth_index'] == "richest", "5", treedata['wealth_index'])
treedata['wealth_index'] = pd.to_numeric(treedata['wealth_index'])

# step 3: convert categorical variables to dummies ----------------------------

## Hint: use get_dummies

  

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
## use the tree to predict Y in the test data and **calculate the test MSE**

### python users:  explore changing the max_depth parameter to 1, 3, or 4
### how does this change the test mse?

reg = DTR(max_depth = 2)
mytree = reg.fit(X_train, y_train)
ax = subplots(figsize=(24,24))[1]
plot_tree(reg, 
          feature_names = feature_names, 
          ax = ax);



# step 7: fit a random forest -------------------------------------------------

## update the # of Xs considered at each split to fit a random forest 
## the norm is to try about the square root of the # of Xs, 
##    but test out a few options to see what improves fit
## you can also try increasing the number of trees from 100 to 200 or 500

## how many variables do you consider at each split in your preferred RF?
## does your preferred RF outperform OLS?
## what is the test MSE of your preferred model?

rf_dhs = RF(max_features = 12, 
               n_estimators = 200, 
               random_state = 0).fit(X_train, y_train)


# step 8: variable importance -------------------------------------------------

## use the code below to identify the 5 most important variables 

feature_imp = pd.DataFrame(
    {'importance':rf_dhs.feature_importances_},
    index=feature_names)
with pd.option_context('display.max_rows', None,):
    print(feature_imp.sort_values(by='importance', ascending=False))


