
## ECON 370 LAB 8:  REGRESSION TREES AND RANDOM FORESTS
## DATE:  


# step 0: preliminaries -------------------------------------------------------

# install packages (if you have not already) and then load associated libraries
# you are going to need:
##     tidyverse, fastDummies (just as in Lab 7)
##     rpart and rpart.plot (for the single regression tree)
##     ranger (for the random forest)


# step 1: load EMERGE data from the web ----------------------------------------

## load ECON370-lab8-forest-data.csv directly from the course github page
## (adapt the code from Lab 7 as needed)

# step 2: clean data, generate treedata data frame to use in your tree ---------

## 2a. impute missing values

## drop any observations that are missing the outcome variable, literacy

## replace missing values of variables other than literacy with the mean
## (or the mean among children of the same age and gender, if you prefer)
## create dummies indicating when values of variables are imputed

## 2b. convert categorical variables to dummies 

## drop the original categorical variable...
## ... as well as one category per variable (the omitted category)


# step 3: create test and training data sets  ----------------------------------

## assign 60 percent of the observations (at random) to the training data set
## make sure to set the seed so this is replicable

set.seed(8675309)
train <- sample(1:nrow(treedata), 0.6 * (nrow(treedata)))

# step 4: OLS benchmark -------------------------------------------------------

## calculate the test MSE for two OLS benchmarks:

## 4a. using the mean of Y as the predictor (ie a tree with 0 splits)
## (you can do this by regressing Y on a constant in the training data)

null_model <- lm(literacy ~ 1, treedata, subset = train)
summary(null_model)
yhat_null <- predict(null_model, newdata = treedata[-train, ])
Y_test <- unlist(treedata[-train, "literacy"])
null_mse <- mean((yhat_null - Y_test)^2)
print(paste0("Null MSE: ", round(null_mse, 3)))

## 4b. running OLS with all the X variables in the training data


# step 5: fitting a single regression tree -------------------------------------

## 5a. fit a simple regression tree using the training data and plot the output

## Hint: use rpart.control's minbucket to change the minimum leaf size 

set.seed(8675309)

one_tree <- rpart(
  formula = literacy ~ .,        
  data = treedata,
  subset = train,
  method = "anova",  # parameter indicates that this is a regression tree       
  control = rpart.control(maxdepth = 5, cp = 0) 
  )

## 5b. plot the tree 
## which variable is used to make the first split?

rpart.plot(
  one_tree, 
  type = 2,                 
  box.palette = "YlGnBl",   
  digits = 2
)

## 5c. use the tree to predict Y in the test data and calculate the test MSE
## How does the test MSE compare to OLS?

# Hint: predict() works the same with a tree as with an OLS model

## 5d. Play around with the code above to get the test MSE as low as possible

## save your image of the tree as a png file to upload to gradescope


# step 6: fit a random forest -------------------------------------------------

## fit a random forest and compare the test MSE to OLS

## the norm is to try about one third of the # of Xs at each split, 
##    but test out a few options to see what improves fit (mtry)
## you can change the number of trees, max depth, or min node size

## your preferred forest should have a test MSE that is below OLS

set.seed(8675309)

rf <- ranger(literacy ~ .,
             data = treedata[train, ],
             min.node.size = 100,
             num.trees = 20,
             mtry = 50,
             max.depth = 2,
             importance = "permutation")

## Hint: ranger's predict() takes data = rather than newdata =, 
##    and the predictions are in $predictions


# step 7: variable importance -------------------------------------------------

## use the code below to identify the most important variable in the forest

var_importance <- tibble(
  varname = names(rf$variable.importance),
  mse_change = rf$variable.importance
) %>%
  arrange(desc(mse_change))

print(var_importance, n = 20)

