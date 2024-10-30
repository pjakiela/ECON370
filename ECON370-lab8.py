
## ECON 370 LAB 8: CAUSAL FORESTS 
## NAME:  
## DATE:  


# step 0: preliminaries -------------------------------------------------------

## libraries
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.ensemble import (RandomForestRegressor as RF)
from econml.dml import CausalForestDML


## file path


# step 1: load Kenya 2014 births recode ---------------------------------------

## load the 2014 Kenya DHS births recode stata file, KEBR72FL.dta

dhs = pd.read_stata(datapath + "data/raw-dhs/KEBR72DT/KEBR72FL.dta")
dhs = dhs[dhs['midx'].notna()] ## keep only kids born in last 5 yrs
dhs = dhs[dhs['b5'] == 'yes'] ## keep only kids who are still alive
dhs = dhs[dhs['v135'] == 'usual resident'] ## drop moms who are visiting interview HH

### check: at this point, you should have a data frame with 19,625 rows and 1,166 columns

print(dhs.shape)


# step 2: generate a unique ID following DHS instructions ---------------------
## the variables caseid and bidx (birth index) uniquely identify observations

dhs['kidid'] = dhs.caseid.str.replace(" ", "", regex=True)
dhs['birthid'] = dhs.bidx.astype(str)
dhs['kidid'] = "1" + dhs['kidid'] + "0" + dhs['birthid']
check_length = dhs.kidid.str.len()
    
print(dhs.kidid.nunique())


# step 3: keep relevant variables, preprocessing ------------------------------

Xvars = dhs[['kidid', 'hw70', 
                'hw1', 'bord', 
                'v012', 'v025', 'v133', 'v136', 
                'v151', 'v190', 
                'v212'
                ]].copy()
Xvars = Xvars.rename(columns={
    'hw70': 'haz',
    'hw1': 'age_months', 
    'bord': 'birth_order',
    'v012': 'mom_age',
    'v025': 'loc',
    'v133': 'mom_edu', 
    'v136': 'hh_size', 
    'v151': 'HH_head_sex',
    'v190': 'wealth_index',
    'v212': 'age_1st_birth',
    })

## idiosyncratic cleaning

## drop observations with missing height-for-age z-scores
Xvars['haz'] = pd.to_numeric(Xvars['haz'], errors='coerce')
Xvars = Xvars.dropna(subset=['haz'])

Xvars['mom_edu'] = pd.to_numeric(Xvars['mom_edu'])

Xvars = pd.get_dummies(Xvars, columns=["loc", 
                                       "HH_head_sex",
                                       "wealth_index"
                                       ],
                       prefix = ["loc",
                                 "head",
                                 "wealth"
                                 ], dummy_na=True, dtype=int)


# step 4: load the outcome data, merge with DHS births data -------------------
## make sure you end up with 18,302 observations

url = 'https://raw.githubusercontent.com/pjakiela/ECON370/refs/heads/gh-pages/ECON370-lab8-data.csv'
outcomes = pd.read_csv(url, 
                       dtype={"kidid": str})



# step 5: estimate a causal forest --------------------------------------------

## adapt the code from the CF example and, if necessary, lab #7
## train causal forest and then follow the additional steps below
## R users: set Y_hat to 0 and W_hat to the mean of W
## Python users: set model_t and model_y to random forests
## Do not worry about the "First stage... is not a classifier!" warning


## step 5.1: report CF prediction of the average treatment effect


## step 5.2 (R users only): report the test calibration - is there heterogeneity?

## step 5.3: identify most important predictors of treatment effect heterogeneity


## step 5.4: estimate treatment effects for the training data using OOB predictions


## step 5.5: plot a histogram of the estimated OOB treatment effects (tau)
## save your histogram as a pdf or png


## step 5.6: compare estimated treatment effects in high and low CATE groups



















