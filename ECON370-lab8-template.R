
## ECON 370 LAB 7:  REGRESSION TREES AND RANDOM FORESTS
## NAME:  
## DATE:  


# step 0: preliminaries -------------------------------------------------------

## libraries
# install.packages("tidyverse")
# install.packages("haven") 
# install.packages("fastDummies")
# install.packages("tree")
# install.packages("randomForest")
# install.packages("gbm")

library(tidyverse)
library(haven)
library(tree)
library(randomForest)
library(gbm)
library(fastDummies)

## file path
username <- Sys.getenv("USERNAME")
pjpath  <-  paste0("C:/Users/", username, "/Dropbox/ECON-370/archive/projects-2024/2-dhs/")


# step 1: load Kenya 2014 births recode ---------------------------------------

## load the 2014 Kenya DHS births recode stata file, KEBR72FL.dta
## select only living children under 5 years old whose mothers were interviewed

dhs <- read_dta(paste0(pjpath, "data/raw-dhs/KEBR72DT/KEBR72FL.dta")) %>% 
  filter(!is.na(midx)) %>% 
  filter(b5 == 1) %>% 
  filter(v135 == 1)

### check: at this point, you should have a data frame with 19,625 rows and 1,166 columns

dim(dhs)


# step 2: choose variables for tree/forest ------------------------------------

## this code selects, renames, and in some cases cleans some key predictors

## select the following variables for use in your trees:
##    hw70 (height-for age, the outcome of interest), 
##    whether the child is a single birth or a twin/triplet,
##    child age in months, birth order, month of birth, year of birth, 
##    mother's age, urban/rural, water source, sanitary facilities, 
##    electricity, mother's education in years (numeric), household size, 
##    sex of the household head, 
##    cooking fuel, wealth index, 
##    place of birth/delivery (e.g. hospital, home)

## Info on the variables is contained in KEBR72FL.do, KEBR72FL.frq, and KEBR72FL.map

treedata <- dhs %>% 
  select(hw70, 
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
         pob = m15)

## drop observations with missing height-for-age z-scores
treedata$haz <- as.numeric(treedata$haz)
treedata <- filter(treedata, !is.na(haz) & haz!=9996 & haz!=9997 & haz!= 9998)

## idiosyncratic cleaning

## change age at time of survey to age at birth
treedata$mom_age <- treedata$mom_age - (2014 - treedata$yob)

## twin dummy
treedata$twin = ifelse(treedata$b0 == 0, 0, 1)
treedata  <- select(treedata, !b0)

## birth interval cannot be NAN (first births), replace with median
treedata$interval[is.na(treedata$interval)] <- median(treedata$interval, na.rm=TRUE)

## EXTEND THIS CODE TO DO ANY ADDITIONAL CLEANING THAT YOU CHOOSE: 

## here is how the DHS recommends coding safe water sources:
## https://dhsprogram.com/data/Guide-to-DHS-Statistics/Household_Drinking_Water.htm

## here is how the DHS recommends coding improved sanitary facilities:
## https://dhsprogram.com/data/Guide-to-DHS-Statistics/Type_of_Sanitation_Facility.htm

## here is how the DHS recommends coding places of delivery:
## https://dhsprogram.com/data/Guide-to-DHS-Statistics/Place_of_Delivery.htm


# step 3: convert categorical variables to dummies ----------------------------

## Hint: identify the factor columns (which were not read into R as factors)
##    then convert them to factors and from there to strings
##    then use fastDummies and dummy_cols() to convert them to dummies

factor_cols <- c("mob", 
                 "yob", 
                 "sex",
                 "location", 
                 "water", 
                 "toilet", 
                 "power", 
                 "HH_head_sex",
                 "fuel", 
                 "wealth_index", 
                 "pob")

#treedata <- treedata %>%
#  mutate_if(is.labelled, ~ as_factor(.)) 
treedata[factor_cols] <- lapply(treedata[factor_cols], as.character)
treedata <- dummy_cols(treedata, select_columns = factor_cols, remove_selected_columns = TRUE)
treedata[is.na(treedata)] <- 0


# step 4: create test and training data sets  ----------------------------------

## assign 40 percent of the observations to the training data set

set.seed(8675309)
train <- sample(1:nrow(treedata), 0.4 * (nrow(treedata)))

# step 5: OLS benchmark -------------------------------------------------------

## calculate the test MSE for two OLS benchmarks:
##    1. using the mean of Y as the predictor (ie a tree with 0 splits)
##        (you can do this by regressing Y on a constant in the training data)
##    2. running OLS with all the X variables in the training data

ols_model <- lm(haz ~ ., treedata, subset = train)
yhat_ols <- predict(ols_model, newdata = treedata[-train, ])
haz_test <- unlist(treedata[-train, "haz"])
ks_mse = mean((yhat_ols - haz_test)^2)


# step 6: fitting a regression tree -------------------------------------------

## fit a simple regression tree using the training data and plot the output
## use the tree to predict Y in the test data and calculate the test MSE

mytree <- tree(haz ~ ., treedata, subset = train)
summary(mytree)
plot(mytree)
text(mytree, pretty = 0)

yhat <- predict(mytree, newdata = treedata[-train, ])
tree_mse = mean(as.numeric(unlist((yhat - haz_test)^2)))


# step 7: fit a random forest -------------------------------------------------

## update the # of Xs considered at each split to fit a random forest 
## the norm is to try about the square root of the # of Xs, 
##    but test out a few options to see what improves fit
## you can also try increasing the number of trees from 100 to 200 or 500

## how many variables do you consider at each split in your preferred RF?
## does your preferred RF outperform OLS?
## what is the test MSE of your preferred model?

set.seed(8675309)

dhs_rf <- randomForest(haz ~ ., 
                           data = treedata, 
                           subset = train,
                           mtry = 12, 
                           importance = FALSE)
dhs_rf
yhat_rf <- predict(dhs_rf, newdata = treedata[-train, ])
rf_mse = mean((yhat_rf - haz_test)^2)
rf_mse


# step 8: variable importance -------------------------------------------------

## use the code below to identify the 5 most important variables

var_importance <- as_tibble(dhs_rf$importance, rownames = "varname") %>%  
  arrange(desc(IncNodePurity))
print(var_importance, n = 20)


