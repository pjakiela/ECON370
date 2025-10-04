
## ECON 370 LAB 5:  CROSS-VALIDATION 
## NAME:  
## DATE:  


# Step 0: load the data ---------------------------------------------------------

## The data set is available here: 'https://pjakiela.github.io/ECON523/exercises/E1-CohenEtAl-data.dta'
## Set up the script to load the data set from github.

# Step 1: familiarize yourself with the data ------------------------------------

# Step 2: one treatment dummy ---------------------------------------------------

## The variable act_any is a dummy for assignment to any treatment
## The variable c_act is a dummy for using ACT treatment during a malaria episode

## 2a: Calculate the mean of c_act in the treatment (act_any==1) and control (act_any==0) groups
## 2b: Calculate the SE of  the mean of c_act in the treatment and control groups
## 2c: Use a t-test to test the hypothesis that the mean is the same in T and C
## 2d: Regress c_act on act_any 
## 2e: How do the coefficients relate to the means above?

# Step 3: multiple treatments ---------------------------------------------------

## The variable coartemprice indicates the randomly-assigned ACT price
##  (and hence the subsidy levels)
## What price/subsidy levels are included in the experiment?

## 3a: Calculate the mean of c_act within the groups defined by subsidy level
## 3b: Regress c_act on the dummies for the three subsidy levels (act40, act60, act100).
## 3c: How do the regression results compare to the group-level means?
## 3d: Show that the beta from 2d is a weighted average of the betas from 3b.

# Step 4: treatment as a continuous variable ------------------------------------

## Create a variable equal to the level of the subsidy (between 0 and 1).
## What values does this variable take?

## 4a: Regress c_act on this continuous treatment variable.
## How do the results compare to those reported above?  

# Step 5: including controls ----------------------------------------------------

## Variables measured at baseline are prefixed with b_*
## Which baseline covariates predict c_act in the control group?

## 5a: Regress c_act on the treatment dummy (any_act) including b_h_edu as a control.
##	How do your results compare to your regression of c_act on any_act in 2?
##	How much does the control increase the R-squared?

## 5b: Regress c_act on b_h_edu and predict the residuals, creating a new variable yresid.  
## 5c: Regress act_any on b_h_edu and predict the residuals, creating variable xresid.
## 5d: Regress yresid on xresid, and compare the coefficient to the beta from 5a.







