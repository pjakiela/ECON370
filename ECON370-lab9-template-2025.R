
## ECON 370 LAB 9: CAUSAL FORESTS 
## NAME:  
## DATE:  


# step 0: preliminaries -------------------------------------------------------

## libraries
# install.packages("tidyverse")
# install.packages("haven") 
# install.packages("fastDummies")
# install.packages("grf")

library(tidyverse)
library(haven)
library(fastDummies)
library(grf)

## file path

# set your file path


# step 1: load Kenya 2014 births recode ----------------------------------------

## the code below will:
##    - load the Kenya 2014 DHS birtsh recode data file
##    - keep only living children born in the last 5 years (before the survey)
##    - follow DHS instructions to create a child-level unique ID, kidid
##    - keep a subset of the variables

## load the 2014 Kenya DHS births recode stata file, KEBR72FL.dta

dhs <- read_dta(paste0(pjpath, "data/KEBR72FL.dta")) %>% 
  filter(!is.na(midx)) %>% 
  filter(b5 == 1) %>% 
  filter(v135 == 1)

### check: at this point, you should have a data frame with 19,625 observations

dim(dhs)

# step 2: generate a unique ID following DHS instructions ----------------------

## the variables caseid and bidx (birth index) uniquely identify observations

dhs$kidid = str_replace_all(dhs$caseid, " ", "")
dhs$birthid = as.character(dhs$bidx)
dhs$kidid = str_c("1", dhs$kidid, "0", dhs$birthid)
check_length = str_length(dhs$kidid)
check_length

### check: kidid should be a unique indentifier for rows in the data frame
###    so there should be as many values of kidid as observations

length(unique(dhs[["kidid"]]))


# step 3: keep relevant variables, preprocessing -------------------------------

## this code selects, renames, and in some cases cleans X variables for trees

## Info on the variables is contained in KEBR72FL.do, KEBR72FL.frq, and KEBR72FL.map

Xvars <- dhs %>% 
  select(kidid, hw70, 
         hw1, bord, b0, b1, b2, b4, 
         v012, v025, v133, v113, v116, v119, v136, 
         v151, v161, v190, m15) %>% 
  rename(haz = hw70, 
         age_months = hw1, 
         mob = b1, 
         yob = b2, 
         sex = b4, 
         mom_age = v012, 
         location = v025,
         water = v113,
         toilet = v116, 
         power = v119,
         mom_edu = v133, 
         hh_size = v136, 
         HH_head_sex = v151,
         fuel = v161, 
         wealth_index = v190,
         pob = m15) %>% 
  na.omit()

## drop observations with missing height-for-age z-scores
Xvars$haz <- as.numeric(Xvars$haz)
Xvars <- filter(Xvars, !is.na(haz) & haz!=9996 & haz!=9997 & haz!= 9998)

## idiosyncratic cleaning

## change age at time of survey to age at birth
Xvars$mom_age <- Xvars$mom_age - (2014 - Xvars$yob)

## twin dummy
Xvars$twin = ifelse(Xvars$b0 == 0, 0, 1)
Xvars  <- select(Xvars, !b0)


# step 4: convert categorical variables to dummies -----------------------------

## convert the variables capturing month of birth, year of birth, child sex, 
##    urban/rural location, water source, sanitary facilities (i.e. toilets), 
##    electricity, sex of the household head, fuel source, and 
##    place of birth to dummy variables 

## Hint: use fastDummies as you did in Lab #8


## at this point, you should have 18216 observations and 85 variables


# step 5: load the outcome data, merge with DHS births data --------------------

## ECON370-lab9-data.csv contains 3 variables: kidid, Y, and W
##    - Y is the outcome 
##    - W is the treatment dummy
##    - kidid will allow you to merge this data to your X variables

urlfile <- 'https://raw.githubusercontent.com/pjakiela/ECON370/refs/heads/gh-pages/ECON370-lab9-data.csv'



# step 5: estimate a causal forest ---------------------------------------------

## adapt the code from the CF example to train a causal forest, 
##    and then follow the additional steps below




## step 5.1: report the CF prediction of the average treatment effect



## step 5.2 (R users only): report the test calibration - is there heterogeneity?



## step 5.3: identify most important predictors of treatment effect heterogeneity



## step 5.4: estimate treatment effects for the training data using OOB predictions



## step 5.5: plot a histogram of the estimated OOB treatment effects (tau)
## save your histogram as a pdf or png



## step 5.6: compare estimated treatment effects in high and low CATE groups


