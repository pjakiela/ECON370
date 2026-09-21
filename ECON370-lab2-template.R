
## ECON 370 LAB 2:  PCA & CLUSTERING
## NAME:  
## DATE:  


# preliminaries ----------------------------------------------------------------

## libraries

## install these packages if needed
#install.packages("tidyverse")

library(tidyverse)


# Step 1: load ECON370-lab2-WDI-data.csv from github ---------------------------

wdi_url <- 'https://github.com/pjakiela/ECON370/raw/refs/heads/gh-pages/ECON370-lab2-WDI-data.csv'
lab2data <- read_csv(wdi_url)


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

## Hint 1: use columns_to_rownames to tag rows with short_name or isocode

lab2_num <- lab2data %>%
  column_to_rownames("short_name") %>%
  select(where(is.numeric)) %>%
  mutate(across(everything(), \(x) as.numeric(scale(x))))


# Step 4: PCA -----------------------------------------------------------------

## implement PCA, saving your results as pca_results

## pca_results$rotation contains the PC loadings from the estimation
## define a data frame pca_loadings that contains the loadings
## round the numbers to three places to the right of the decimal point
## add the variable names to the data frame as an additional column
## they are stored in rownames(pca_results$rotation)
## put that column first in your data frame 
## print your results using print() so they display as output

## how many variables receive positive loading in the first principal component?

## Hint 1: use prcomp()
## Hint 2: use biplot() to (quickly) graph the first two principal components


# Step 5: k-means clustering ---------------------------------------------------

## the code below implements k-means clustering
## notice that it is quite robust: changing the seed does not alter the clusters (?)
## (run the code a few times with different seeds to see this)
## how high can you increase the number of clusters while preserving this stability?
## for the highest stable number of clusters that you identify this way, 
##     record 5 seeds that yield a set of identical cluster sizes

set.seed(8675309)
num_clust <- 3
km_results <- kmeans(lab2_num, centers = num_clust, nstart = 20)
sort(km_results$size)


# Step 6: characterizing the clusters ------------------------------------------

## 6a, 6b, 6c illustrate 3 different ways of characterizing clusters
## they use kmeans() outputs km_results$centers and km_results$cluster
## review the code to make you understand each approach
## use these approaches to characterize the clusters you have created

## 6a. create a data frame with the centroids of the clusters ------------------
## how do locations of the centroids differ across clusters?
clust_centers <- round(t(km_results$centers), 3)
print(clust_centers)

## 6b. look at the lists of countries assigned to each cluster -----------------
## how would you characterize the countries in each cluster?

clust_assignments <- as_tibble(km_results$cluster)
clust_assignments$short_name <- names(km_results$cluster)
clust_list <- rep(NA, num_clust)

for (n in 1:num_clust) {
  country_matches <- clust_assignments %>%
    filter(value == n)
  clust_list[n] <- str_flatten(country_matches$short_name, collapse = "; ")
}
print(clust_list)

## 6c. identify the variables most/least associated with each cluster ----------
## which variables are most associated with specific clusters?

vars_c1 <- (km_results$centers[1,] - colMeans(km_results$centers[-1,])) %>% sort(decreasing = TRUE)
vars_c2 <- (km_results$centers[2,] - colMeans(km_results$centers[-2,])) %>% sort(decreasing = TRUE)
vars_c3 <- (km_results$centers[3,] - colMeans(km_results$centers[-3,])) %>% sort(decreasing = TRUE)

var_importance <- tibble(Cluster1 = names(vars_c1), 
                         Cluster2 = names(vars_c2),
                         Cluster3 = names(vars_c3)) 
print(var_importance) 


## Step 7: make a scatter plot -------------------------------------------------

## Make a scatter plot of the countries in terms of the first two PCs
## Illustrate the clusters on the plot using different colors
## What patterns do you observe?

## Hint 1: the country scores on each PC are stored in pca_results$x
## Hint 2: the cluster assignments are stored in km_results$cluster
## Hint 3: both are in the same order as the rows of lab2_num
