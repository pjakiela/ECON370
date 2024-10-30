
## ECON 370 LAB 8: CAUSAL FORESTS 
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


# step 1: load Kenya 2014 births recode ----------------------------------------

## load the 2014 Kenya DHS births recode stata file, KEBR72FL.dta

dhs <- read_dta(paste0(datapath, "data/raw-dhs/KEBR72DT/KEBR72FL.dta")) %>% 
  filter(!is.na(midx)) %>% 
  filter(b5 == 1) %>% 
  filter(v135 == 1)

### check: at this point, you should have a data frame with 19,625 rows and 1,166 columns

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

treedata <- dhs %>% 
  select(kidid, hw70, hw1, bord, 
         v012, v025, v133, v136, 
         v151, v190, v212) %>% 
  rename(haz = hw70, 
         age_months = hw1, 
         birth_order = bord, 
         mom_age = v012, 
         loc = v025,
         mom_edu = v133, 
         hh_size = v136, 
         HH_head_sex = v151,
         wealth_index = v190,
         age_1st_birth = v212)

## idiosyncratic cleaning

## drop observations with missing height-for-age z-scores
treedata$haz <- as.numeric(treedata$haz)
treedata <- filter(treedata, !is.na(haz) & haz!=9996 & haz!=9997 & haz!= 9998)

factor_cols <- c("loc", 
                 "HH_head_sex",
                 "wealth_index")

treedata[factor_cols] <- lapply(treedata[factor_cols], as.character)
treedata <- dummy_cols(treedata, select_columns = factor_cols, remove_selected_columns = TRUE)
treedata[is.na(treedata)] <- 0


# step 4: load the outcome data, merge with DHS births data --------------------
## make sure you end up with 18,302 observations

urlfile <- 'https://raw.githubusercontent.com/pjakiela/ECON370/refs/heads/gh-pages/ECON370-lab8-data.csv'
outcomes <- read_csv(urlfile,
                    col_types = cols(
                      Y = col_double(),
                      W = col_double(),
                      kidid = col_character()
                    ))


# step 5: estimate a causal forest ---------------------------------------------

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

