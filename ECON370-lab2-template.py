
## ECON 370 LAB 2:  PCA & CLUSTERING 
## NAME:  
## DATE:  


# preliminaries ---------------------------------------------------------------

## libraries
import numpy as np # numerical python
import pandas as pd # data frames and statistical analysis
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans

# Step 1: load ECON370-lab2-WDI-data.csv from github ---------------------------

urlfile = 'https://github.com/pjakiela/ECON370/raw/refs/heads/gh-pages/ECON370-lab2-WDI-data.csv'
lab2data = pd.read_csv(urlfile)


# Step 2: familiarize yourself with the data -----------------------------------

## Insert code to answer these questions.
## Add comments providing any numeric answers requested.

## Check out the Getting Started labs for hints if you are new to R

## 1a. How many countries are in the data set?  
## 1b. How many variables are in the data set?  
## 1c. which variables are string (or character) variables?
## 1d. Make sure you understand what each of the variables represents


# Step 3: scale numeric variables ---------------------------------------------

## create a data frame lab2_num that contains all the numeric variables in lab2data
## rescale them so that they are mean 0, standard deviation 1

## Hint 1: set the index on lab2data to "short_name" or "isocode" 
## Hint 2: use that as the index for your data frame of rescale numeric variables
## Hint 3: use StandardScaler from sklearn


# Step 4: PCA -----------------------------------------------------------------

## implement PCA, saving your results as pca_results

## pca.components_.T contains the PC loadings from the estimation
## define a data frame pca_loadings that contains the loadings
## round the numbers to three places to the right of the decimal point
## add the variable names to the data frame as an additional column
## they are stored in rownames(pca_results$rotation)
## put that column first in your data frame 
## print your results using print() so they display as output

## how many variables receive positive loading in the first principal component

## Hint 1: use sklearn's PCA()



# Step 5: k-means clustering --------------------------------------------------

## the code below implements k-means clustering
## notice that it is quite robust: changing the seed does not alter the clusters (?)
## (run the code a few times with different seeds to see this)
## how high can you increase the number of clusters while preserving this stability?
## for the highest stable number of clusters that you identify this way, 
##     record 5 seeds that yield a set of identical cluster sizes

np.random.seed(314159)
num_clust = 3
km = KMeans(n_clusters=num_clust, n_init=20, random_state=8675309)
km.fit(lab2_num)  

cluster_sizes = np.bincount(km.labels_)
cluster_sizes.sort()

print(cluster_sizes)


# Step 6: characterizing the clusters ------------------------------------------

## 6a, 6b, 6c illustrate 3 different ways of characterizing clusters
## they use kmeans() outputs km_results$centers and km_results$cluster
## review the code to make you understand each approach
## pick one and use it to characterize the clusters you have created

## 6a. create a data frame with the centroids of the clusters ------------------
clust_centers = np.round(km.cluster_centers_.T, 3)  
df_centers = pd.DataFrame(
    clust_centers,
    index=lab2_num.columns,
    columns=[f"Cluster_{j}" for j in range(clust_centers.shape[1])]
)
print(df_centers)

## 6b. look at the lists of countries assigned to each cluster -----------------

clust_assignments = pd.DataFrame({
    "value": km.labels_,
    "short_name": lab2_num.index  # row names / country names
})

clust_dict = {}

for n in range(1, num_clust + 1):   
    print(n)
    country_matches = clust_assignments[clust_assignments["value"] == (n - 1)]
    members = country_matches["short_name"].tolist()
    clust_dict[f"Cluster_{n}"] = members

print(clust_dict)

## 6c. identify the variables most/least associated with each cluster ---------

centers = km.cluster_centers_

feature_names = lab2_num.columns

def var_diff(cluster_idx):
    other_idxs = [i for i in range(centers.shape[0]) if i != cluster_idx]
    diffs = centers[cluster_idx, :] - centers[other_idxs, :].mean(axis=0)
    return pd.Series(diffs, index=feature_names).sort_values(ascending=False)

vars_c1 = var_diff(0)
vars_c2 = var_diff(1)
vars_c3 = var_diff(2)

var_importance = pd.DataFrame({
    "Cluster1": vars_c1.index,
    "Cluster2": vars_c2.index,
    "Cluster3": vars_c3.index
})

print(var_importance)








