
## ECON 370 LAB 9: CAUSAL FORESTS 
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

## set your file path


# step 1: load Kenya 2014 births recode ---------------------------------------

## the code below will:
##    - load the Kenya 2014 DHS birtsh recode data file
##    - keep only living children born in the last 5 years (before the survey)
##    - follow DHS instructions to create a child-level unique ID, kidid
##    - keep a subset of the variables

## load the 2014 Kenya DHS births recode stata file, KEBR72FL.dta

dhs = pd.read_stata(datapath + "data/KEBR72FL.dta")
dhs = dhs[dhs['midx'].notna()] ## keep only kids born in last 5 yrs
dhs = dhs[dhs['b5'] == 'yes'] ## keep only kids who are still alive
dhs = dhs[dhs['v135'] == 'usual resident'] ## drop moms who are visiting interview HH

### check: at this point, you should have a data frame with 19,625 observations

print(dhs.shape)


# step 2: generate a unique ID following DHS instructions ---------------------
## the variables caseid and bidx (birth index) uniquely identify observations

dhs['kidid'] = dhs.caseid.str.replace(" ", "", regex=True)
dhs['birthid'] = dhs.bidx.astype(str)
dhs['kidid'] = "1" + dhs['kidid'] + "0" + dhs['birthid']
check_length = dhs.kidid.str.len()
    
print(dhs.kidid.nunique())


# step 3: keep relevant variables, preprocessing ------------------------------

## this code selects, renames, and in some cases cleans X variables for trees

## Info on the variables is contained in KEBR72FL.do, KEBR72FL.frq, and KEBR72FL.map

Xvars = dhs[['kidid','hw70', 
                'hw1', 'bord', 'b0', 'b1', 'b2', 'b4', 
                'v012', 'v025', 'v133', 'v113', 'v116', 'v119', 'v136', 
                'v151', 'v161', 'v190', 'm15']].copy()
Xvars = Xvars.rename(columns={
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

Xvars =Xvars.dropna()

## idiosyncratic cleaning

## drop observations with missing height-for-age z-scores
Xvars['haz'] = pd.to_numeric(Xvars['haz'], errors='coerce')
Xvars = Xvars.dropna(subset=['haz'])

## change age at time of survey to age at birth
Xvars['mom_age'] = Xvars['mom_age'] - (2014 - Xvars['yob'])

## twin dummy
Xvars['twin'] = np.where(Xvars['b0'] == "single birth", 0, 1)
Xvars = Xvars.drop(columns={'b0'})

Xvars['mom_edu'] = pd.to_numeric(Xvars['mom_edu'])

Xvars['wealth_index'] = np.where(Xvars['wealth_index'] == "poorest", "1", Xvars['wealth_index'])
Xvars['wealth_index'] = np.where(Xvars['wealth_index'] == "poorer", "2", Xvars['wealth_index'])
Xvars['wealth_index'] = np.where(Xvars['wealth_index'] == "middle", "3", Xvars['wealth_index'])
Xvars['wealth_index'] = np.where(Xvars['wealth_index'] == "richer", "4", Xvars['wealth_index'])
Xvars['wealth_index'] = np.where(Xvars['wealth_index'] == "richest", "5", Xvars['wealth_index'])
Xvars['wealth_index'] = pd.to_numeric(Xvars['wealth_index'])

# step 4: convert categorical variables to dummies ----------------------------

## convert the variables capturing month of birth, year of birth, child sex, 
##    urban/rural location, water source, sanitary facilities (i.e. toilets), 
##    electricity, sex of the household head, fuel source, and 
##    place of birth to dummy variables 

## Hint: use get_dummies



## Additional hint: drop any dummies that do not vary across obsvervations (see below)

unique_counts = Xvars.nunique()
cols_to_drop = unique_counts[unique_counts == 1].index
Xvars = Xvars.drop(columns=cols_to_drop, axis=1)


## at this point, you should have 18216 observations and 85 variables


# step 5: load the outcome data, merge with DHS births data -------------------

## ECON370-lab9-data.csv contains 3 variables: kidid, Y, and W
##    - Y is the outcome 
##    - W is the treatment dummy
##    - kidid will allow you to merge this data to your X variables

url = 'https://raw.githubusercontent.com/pjakiela/ECON370/refs/heads/gh-pages/ECON370-lab9-data.csv'


# step 5: estimate a causal forest ---------------------------------------------

## adapt the code from the CF example to train a causal forest, 
##    and then follow the additional steps below

## Do not worry about the "First stage... is not a classifier!" warning



## step 5.1: report the CF prediction of the average treatment effect


## step 5.2 (R users only): report the test calibration - is there heterogeneity?

## step 5.3: identify most important predictors of treatment effect heterogeneity

## step 5.4: estimate treatment effects for the training data using OOB predictions


## step 5.5: plot a histogram of the estimated OOB treatment effects (tau)
## save your histogram as a pdf or png


## step 5.6: compare estimated treatment effects in high and low CATE groups



















