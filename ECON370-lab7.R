
## ECON 370 LAB 7:  TREES 
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


# step 1: load Kenya 2014 births recode ----------------------------------------

## load the 2014 Kenya DHS births recode stata file, KEBR72FL.dta

dhs <- read_dta(paste0(pjpath, "data/raw-dhs/KEBR72DT/KEBR72FL.dta")) %>% 
  filter(!is.na(midx)) %>% 
  filter(b5 == 1) %>% 
  filter(v135 == 1)

### check: at this point, you should have a data frame with 19,625 rows and 1,166 columns

dim(dhs)


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

treedata <- dhs %>% 
  select(hw70, hw1, bord, b0, b1, b2, b4, b11, 
         v012) %>% 
  rename(haz = hw70, 
         age_months = hw1, 
         mob = b1, 
         yob = b2, 
         sex = b4, 
         interval = b11, 
         mom_age = v012)

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


# step 3: convert categorical variables to dummies ----------------------------

## python: use get_dummies

## R: identify the factor columns (which were not read into R as factors)
##    then convert them to factors and from there to strings
##    then use fastDummies and dummy_cols() to convert them to dummies

factor_cols <- c("mob", 
                 "yob", 
                 "sex")

treedata[factor_cols] <- lapply(treedata[factor_cols], as.character)
treedata <- dummy_cols(treedata, select_columns = factor_cols, remove_selected_columns = TRUE)
treedata[is.na(treedata)] <- 0


# step 3: create test and training data sets  ----------------------------------

## assign 40 percent of the observations to the training data set

set.seed(8675309)
train <- sample(1:nrow(treedata), 0.4 * (nrow(treedata)))

# step 4: OLS benchmark -------------------------------------------------------

## calculate the test MSE for two OLS benchmarks:
##    1. using the mean of Y as the predictor (ie a tree with 0 splits)
##        (you can do this by regressing Y on a constant in the training data)
##    2. running OLS with all the X variables in the training data




# step 5: fitting a regression tree -------------------------------------------

## fit a simple regression tree using the training data and plot the output
## use the tree to predict Y in the test data and calculate the test MSE

### python users:  explore changing the max_depth parameter to 1, 3, or 4
### how does this change the test mse?

### R users: the tree package doesn't allow you to control the depth of the tree
### you can try doing this with the rpart package if you want...

mytree <- tree(haz ~ ., treedata, subset = train)
summary(mytree)
plot(mytree)
text(mytree, pretty = 0)

yhat <- predict(mytree, newdata = treedata[-train, ])
haz_test <- unlist(treedata[-train, "haz"])
tree_mse = mean(as.numeric(unlist((yhat - haz_test)^2)))


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

set.seed(8675309)
emerge_bag <- randomForest(haz ~ ., 
                           data = treedata, 
                           subset = train,
                           mtry = 12, 
                           importance = TRUE)
emerge_bag
yhat_bag <- predict(emerge_bag, newdata = treedata[-train, ])
bag_mse = mean((yhat_bag - haz_test)^2)
bag_mse


# step 8: fit gradient-boosted trees ------------------------------------------

## how does the test MSE of gradient-boosted trees compare to that of a RF?

set.seed(8675309)
emerge_boost <- gbm(haz ~ ., data = treedata[train, ], 
                    distribution = "gaussian", 
                    n.trees = 5000, 
                    interaction.depth = 2, 
                    shrinkage = 0.001, 
                    verbose = F)
summary(emerge_boost)

yhat_boost <- predict(emerge_boost, 
                      newdata = treedata[-train, ], 
                      n.trees = 5000)
boost_mse = mean((yhat_boost - haz_test)^2)
