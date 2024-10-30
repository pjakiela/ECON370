
## ECON 370: CAUSAL FOREST EXAMPLE
## ECON 370: CAUSAL FOREST EXAMPLE


# step 0: preliminaries -------------------------------------------------------

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from econml.dml import CausalForestDML
from sklearn.ensemble import (RandomForestRegressor as RF)
from sklearn.linear_model import LassoCV
from econml.cate_interpreter import SingleTreeCateInterpreter


# generate data ---------------------------------------------------------------

## set seed
np.random.seed(8675309)

## define parameters
N = 2000  # number of observations
p = 6     # number of variables

## generate covariates X and binary treatment W
X = np.random.randn(N, p)  # matrix of covariates (N x p)
W = np.random.choice([0, 1], size=N)  # treatment assignment
W_hat = np.mean(W)  # average of treatment (propensity score)
Y_hat = 0  # initial outcome prediction

## treatment effect varies with X1 (in column 0)
Y = W + np.maximum(X[:, 0], 0) * W + X[:, 1] - np.minimum(X[:, 2], 0) + np.random.randn(N)

## true individual-level treatment effect (based on formula above)
tau = 1 + np.maximum(X[:, 0], 0) * 1 
mean_tau = np.mean(tau)

# plot a histogram of the actual taus / conditional average treatment effects 
plt.hist(tau, bins=28, color='skyblue', edgecolor='black')
plt.title('Actual Treatment Effects')
plt.xlabel('Individual Treatment Effects')
plt.ylabel('Frequency')
plt.show()

# estimate a causal forest ----------------------------------------------------

## R users: here we shut down the double ML aspect (predicted Y is 0, predicted W is mean)
## removing Y.hat and W.hat arguments will default to using random forests to predict Y, W

## Python users: 'auto' tries a range of different ML approaches and chooses
##    the one that minimizes CV MSE to predict treatment and outcome Y
## I recommend setting model_t and model_y equal to 
##    RF(n_estimators=200, random_state=8675309)
##    to avoid errors when you move to the DHS data

cf = CausalForestDML(
    model_t='auto',
    model_y='auto',
    discrete_treatment=True,
    n_estimators=200,  # Number of trees in the forest
    random_state=8675309
)

cf.fit(Y, W, X=X)


# results from a causal forest ------------------------------------------------

## CF prediction of the average treatment effect
## made using some obscure double ML technique so take with a grain of salt
cf_ate = cf.ate(X=X)
print("Estimated Average Treatment Effect (ATE):", cf_ate)

## R users: assess whether the causal forest succeeded in capturing heterogeneity

## identify most important predictors of treatment effect heterogeneity
cf_importance = cf.feature_importances_
cf_importance_df = pd.DataFrame({
    'Feature': [f'X{i+1}' for i in range(p)],
    'Importance': cf_importance
}).sort_values(by='Importance', ascending=False)
print("\nVariable Importance:")
print(cf_importance_df)

## there is no hard and fast rule for choosing important predictors...
cf_select_vars = cf_importance_df[cf_importance_df['Importance'] > np.mean(cf_importance_df['Importance'])]
print(cf_select_vars)

## estimate treatment effects for the training data using out-of-bag predictions
tau_hat_oob = cf.effect(X=X)

# plot a histogram of the estimated OOB conditional average treatment effects (tau)
plt.hist(tau_hat_oob, bins=28, color='tomato', edgecolor='black')
plt.title('Out-of-Bag Predicted Treatment Effects')
plt.xlabel('Estimated Treatment Effect')
plt.ylabel('Frequency')
plt.show()

## compare the estimate treatment effect in high and low CATE groups (OOB estimates)
high_effect = tau_hat_oob > np.median(tau_hat_oob)
cate_high = cf.ate(X=X[high_effect])
cate_low = cf.ate(X=X[~high_effect])
print("\nEstimated ATE for High-Effect Group:", cate_high)
print("Estimated ATE for Low-Effect Group:", cate_low)


## Python users: plot a single tree based on the causal forest
cate_interpreter = SingleTreeCateInterpreter(include_model_uncertainty=False, max_depth=3)
cate_interpreter.interpret(cf, X)
plt.figure(figsize=(12, 8))
cate_interpreter.plot(feature_names=["Feature " + str(i) for i in range(X.shape[1])])
plt.rcParams.update({'font.size': 12})  # Set to your preferred font size
plt.show()





