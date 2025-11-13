
## ECON 370 LAB 11: TEXT AS DATA 
## NAME:  
## DATE:  


# step 0: preliminaries -------------------------------------------------------

import os
import numpy as np
import pandas as pd
from nltk.corpus import stopwords
from sklearn.feature_extraction.text import CountVectorizer
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans


## file path
username = os.getenv("USERNAME")
pjpath = f"C:/Users/{username}/Dropbox/ECON-370/topics/11-text/lab/"  
datapath = f"C:/Users/{username}/Dropbox/ECON-370/data/nber/"  


# step 1: load data -----------------------------------------------------------

## load the data set ECON370-NBER-data.csv directly from the course github

#nber = pd.read_csv(datapath + "ECON370-NBER-data.csv")

urlfile = 'https://raw.githubusercontent.com/pjakiela/ECON370/refs/heads/gh-pages/ECON370-NBER-data.csv'
nber = pd.read_csv(urlfile)


# step 2: select your two favorite NBER programs ------------------------------

## info on the different NBER pograms and their areas of focus is here:  
##    https://www.nber.org/programs-projects/programs-working-groups

## keep only papers associated with your programs of choice, 
##    and drop the other program name columns

nber = nber[(nber['Development_Economics'] == 1) | (nber['Labor_Studies'] == 1)] 
nber = nber[['wp_number', 'title', 'abstract', 'Development_Economics', 'Labor_Studies']]

## how many papers are included in your analysis data set?

# step 3: preprocessing -------------------------------------------------------

## tokenize the text of the abstracts, remove stop words and non-words, 
##    calculate term frequency (count of word i / total words in abstract)

## get stop word list
nltk_stopwords = set(stopwords.words('english'))  # List of English stopwords from NLTK

nber_abstracts = nber[['wp_number', 'abstract']].copy()

## a small amount of manual preprocessing
nber_abstracts['abstract'] = nber_abstracts['abstract'].str.replace('[Ss]chools ', 'school ', regex=True)
nber_abstracts['abstract'] = nber_abstracts['abstract'].str.replace('[Ff]irms ', 'firm ', regex=True)
nber_abstracts['abstract'] = nber_abstracts['abstract'].str.replace('[Jj]obs ', 'job ', regex=True)

## tokenize
vectorizer = CountVectorizer(token_pattern=r'\b\w+\b', lowercase=True)  
dtm = vectorizer.fit_transform(nber_abstracts['abstract']) 
words = vectorizer.get_feature_names_out()  
nber_tf = pd.DataFrame(dtm.toarray(), index=nber_abstracts['wp_number'], columns=words).stack()
nber_tf = nber_tf.reset_index()
nber_tf.columns = ['wp_number', 'word', 'n']  

## calculate term frequency instead of count
nber_tf['proportion'] = nber_tf.groupby('wp_number')['n'].transform(lambda x: x / x.sum())

## remove words that do not include at least one letter
nber_tf = nber_tf[nber_tf['word'].str.contains(r'[a-zA-Z]', na=False)]

## remove stop words
nber_tf = nber_tf[~nber_tf['word'].isin(nltk_stopwords)]

print(nber_tf.sort_values(by='proportion'))


# step 4: k-means clustering --------------------------------------------------

## create a document term matrix
dtm = nber_tf.pivot(index='wp_number', columns='word', values='proportion').fillna(0)

## implement k-means clustering for a given number of clusters

num_clusters = 4
kmeans = KMeans(n_clusters=num_clusters, random_state=8, n_init = 50)
kmeans.fit(dtm)

### Python: kmeans.labels_ is an array indicating which cluster each paper is in

results = nber.copy()  
results['cluster'] = kmeans.labels_
results['cluster'] = results['cluster'] + 1

### do the clusters split papers along the same lines as the NBER programs?
### (note that this may or may not be a useful diagnostic)

look_at_clusters = results.groupby(['cluster']).agg(
    mean_dev=('Development_Economics', 'mean'), 
    mean_childrens=('Labor_Studies', 'mean')
).reset_index()
print(look_at_clusters)

### are the clusters reasonably sized, or are there tiny or very large clusters?

cluster_stats = results.groupby('cluster')['wp_number'].count()
print(cluster_stats)


### which words are most associated with each cluster?

## Python: kmeans.cluster_centers_ is the analog of kfit$centers in R

### this code plots the words most strongly associated w/ each cluster
### do the groupings make sense?

# calculate differential likelihood of each word for each cluster
## combine these word scores into a data frame

cluster_centers = kmeans.cluster_centers_
num_clusters = cluster_centers.shape[0]

word_scores = {}
for i in range(num_clusters):
    # Calculate the difference between the current cluster center and the mean of others
    other_means = np.mean(np.delete(cluster_centers, i, axis=0), axis=0)
    word_scores[f"ws_c{i+1}"] = cluster_centers[i] - other_means


words = dtm.columns  
word_scores_df = pd.DataFrame(word_scores, index=words).reset_index()
word_scores_df = word_scores_df.melt(id_vars='word', 
                                     var_name='cluster', 
                                     value_name='score')

cluster_counts = pd.Series(kmeans.labels_).value_counts().sort_index()
for i in range(num_clusters):
    cluster_name = f"Cluster {i+1} (N = {cluster_counts[i]})"
    word_scores_df['cluster'] = word_scores_df['cluster'].replace(f"ws_c{i+1}", cluster_name)

top_words = (word_scores_df.groupby('cluster')
             .apply(lambda x: x.nlargest(10, 'score'))
             .reset_index(drop=True))

## plot the words that identify each cluster

plt.figure(figsize=(14, 10))
g = sns.FacetGrid(
    data=top_words,
    col="cluster",
    hue='cluster',
    col_wrap=2,  
    sharey=False,
    height=6,
    aspect=1.2
)

g.map_dataframe(
    sns.barplot,
    x='score',
    y='word',
    alpha=0.84
)
g.set_titles("{col_name}", size=20)
g.set_axis_labels("Term Frequency", " ")
g.set_xticklabels(fontsize=14)
g.set_yticklabels(fontsize=14)
g.despine(left=True)


plt.show()

## now that you understand how the code works, 
##    rerun it a few times after changing the random state setting
## how stable is it across seeds?
## are there very large or small clusters?
## do the word groupings make sense?
## do you think this is the right number of clusters? 
## is there any additional preprocessing that might improve fit?

## tinker with the code until you have a (relatively) stable, 
##    reasonable set of clusters that you are happy with
## change the number of clusters as needed, or adjust the preprocessing, etc.
## fix a seed that generates a graph you like, and save that graph

