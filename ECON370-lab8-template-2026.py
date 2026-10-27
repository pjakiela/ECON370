
## ECON 370 LAB 8:  REGRESSION TREES AND RANDOM FORESTS
## DATE:  


# step 0: preliminaries -------------------------------------------------------

# install packages (if you have not already) and then load associated libraries
# you are going to need:
##     numpy, pandas, statsmodels.api, and matplotlib.pyplot (just as in Lab 7)
##     train_test_split from sklearn.model_selection
##     DecisionTreeRegressor and plot_tree from sklearn.tree (for the single regression tree)
##     RandomForestRegressor from sklearn.ensemble (for the random forest)
##     permutation_importance from sklearn.inspection (for variable importance)


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

X = treedata.drop(columns = ['literacy'])
Y = treedata['literacy']

X_train, X_test, Y_train, Y_test = train_test_split(X, Y, 
                                                    train_size = 0.6, 
                                                    random_state = 8675309)

# step 4: OLS benchmark -------------------------------------------------------

## calculate the test MSE for two OLS benchmarks:

## 4a. using the mean of Y as the predictor (ie a tree with 0 splits)
## (you can do this by regressing Y on a constant in the training data)

null_model = sm.OLS(Y_train, np.ones(len(Y_train))).fit()
print(null_model.summary())
yhat_null = null_model.predict(np.ones(len(Y_test)))
null_mse = np.mean((yhat_null - Y_test)**2)
print("Null MSE:", round(null_mse, 3))

## 4b. running OLS with all the X variables in the training data


# step 5: fitting a single regression tree -------------------------------------

## 5a. fit a simple regression tree using the training data and plot the output

## Hint: use min_samples_leaf to change the minimum leaf size 

one_tree = DecisionTreeRegressor(max_depth = 5, 
                                 random_state = 8675309)
one_tree.fit(X_train, Y_train)

## 5b. plot the tree 
## which variable is used to make the first split?

plt.figure(figsize = (12, 8))
plot_tree(one_tree, 
          feature_names = list(X.columns), 
          filled = True, 
          precision = 2)
plt.show()

## 5c. use the tree to predict Y in the test data and calculate the test MSE
## How does the test MSE compare to OLS?

# Hint: predict() works the same with a tree as with an OLS model 
#    (but there is no need to add a constant)

## 5d. Play around with the code above to get the test MSE as low as possible

## save your image of the tree as a png file to upload to gradescope


# step 6: fit a random forest -------------------------------------------------

## fit a random forest and compare the test MSE to OLS

## the norm is to try about one third of the # of Xs at each split, 
##    but test out a few options to see what improves fit (max_features)
## you can change the number of trees, max depth, or min leaf size

## your preferred forest should have a test MSE that is below OLS

rf = RandomForestRegressor(min_samples_leaf = 100, 
                           n_estimators = 20, 
                           max_features = 50, 
                           max_depth = 2, 
                           random_state = 8675309)
rf.fit(X_train, Y_train)


# step 7: variable importance -------------------------------------------------

## use the code below to identify the most important variable in the forest

perm = permutation_importance(rf, X_test, Y_test, 
                              scoring = 'neg_mean_squared_error', 
                              random_state = 8675309)

var_importance = pd.DataFrame({'varname': X.columns, 
                               'mse_change': perm.importances_mean})
var_importance = var_importance.sort_values('mse_change', ascending = False)

print(var_importance.head(20))
