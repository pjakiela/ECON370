
## ECON 370 LAB 10: TERM FREQUENCIES 
## NAME:  
## DATE:  
    
    
# step 0 : preliminaries ------------------------------------------------------

## you will probably need to install nltk

## libraries

import os
import numpy as np
import pandas as pd
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
import re
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.feature_extraction.text import TfidfTransformer


## file path



# step 1: load data -----------------------------------------------------------

## load the data set ECON370-lab10-data.csv

## familiarize yourself with the data set
## how many papers are included? how many in each program?

url = 'https://raw.githubusercontent.com/pjakiela/ECON370/refs/heads/gh-pages/ECON370-lab10-data.csv'
lab10_nber = pd.read_csv(url)

print(lab10_nber.columns)
print(lab10_nber.info)
print(lab10_nber.dtypes)
print(lab10_nber.describe())


# step 2: tokenize ------------------------------------------------------------

## step 2a: words -------------------------------------------------------------

## create a word-level data set containing all the words from the abstracts
## what are the 5 most common words in abstracts across all the papers?

abstracts = lab10_nber['abstract']
abstract_tokens = abstracts.apply(word_tokenize)
abstract_words = [word.lower() for sublist in abstract_tokens for word in sublist if re.search(r'[\w|\d]', word)]
abstract_words_df = pd.DataFrame(abstract_words)
print(abstract_words_df.value_counts())



## step 2b: remove stopwords --------------------------------------------------

## what are the 5 most common words after removing stopwords?

## Note: R and Python use different tokenizers, so the word counts are different

no_stop_words = [word for word in abstract_words if word not in stopwords.words('english')]
nsw_df = pd.DataFrame(no_stop_words)



# step 3: words by field ------------------------------------------------------

## step 3a: what are the 5 most common words in Asset Pricing abstracts?
##    (after removing stopwords)



## step 3b: what are the 5 most common words in Children & Families abstracts?
##    (after removing stopwords)



## step 3c: distinguishing words 

## combine your data frames containing words counts for each field


## use the code below to make a figure showing the top 50 words in each field
##    (or use your own code to make the graph, if you have a better version)

top_words = pooled_words.groupby('program').apply(lambda x: x.nlargest(50, 'n')).reset_index(drop=True)

g = sns.FacetGrid(top_words, col='program', hue='program',col_wrap=2, sharey=False, height=12)

g.map_dataframe(
    sns.barplot,
    x='n',
    y='word',
    alpha=0.9
)

g.set_axis_labels("Word Count", "")
g.set_titles(col_template="{col_name}")  # Use column names as titles for each subplot
g.despine(left=True)

plt.show()


## create a data frame containing the top 50 words in each field
## how many of the top 50 words are the same across fields?



# step 4: calculate tf-idf "by hand" ------------------------------------------

## to calculate tf-idf, we (of course) need to calculate tf and df

## create a data frame of words from abstracts that includes program and wp_number

lab10_words = lab10_nber[['program', 'wp_number', 'abstract']].copy()
lab10_words['word'] = lab10_words['abstract'].apply(lambda x: word_tokenize(x.lower()))  
lab10_words = lab10_words.explode('word').reset_index(drop=True)
lab10_words = lab10_words[lab10_words['word'].str.contains(r'[a-zA-Z0-9]', na=False)]

## generate a data frame lab10_tf that includes document-level term frequencies
##    (i.e. document-level word counts normalized by the # of words in the document)

lab10_tf = lab10_words.groupby(['wp_number', 'word']).size().reset_index(name='n')
lab10_tf['proportion'] = lab10_tf.groupby('wp_number')['n'].transform(lambda x: x / x.sum())
lab10_tf.head()

## calculate document frequency, i.e. the proportion of documents containing a given word
## this is at the word rather than the documentxword level
## the easiest way is to use ceiling()/np.ceil() on your lab10_tf data frame 
##    to create an indicator for whether a given word is in a given document


## join lab10_tf and lab10_df by word and create lab10_tfidf


## what are the 5 "words" (one is an acronym) with the highest tf-idf?



# step 5: calculate tf-idf using bind_tf_idf or scikit-learn ------------------

## R users: 
## an alternative is to use the bind_tf_idf function 
## confirm that your tdidf indices (above) match these

## Python users: 
## an alternative is to use scikit-learn's TfidfTransformer, but...
##    ... it does not use the standard formula for the tf-idf statistic
## the TfidfTransformer tfidf values should be correlated with the ones
##    that you calculated in step 4, but not identical 

lab10_tf = lab10_words.groupby(['wp_number', 'word']).size().reset_index(name='n')
lab10_tf['proportion'] = lab10_tf.groupby('wp_number')['n'].transform(lambda x: x / x.sum())
count_matrix = lab10_tf.pivot(index='wp_number', columns='word', values='proportion').fillna(0)

tfidf_transformer = TfidfTransformer(norm = None, smooth_idf = False)
tfidf_matrix = tfidf_transformer.fit_transform(count_matrix)
tfidf_df = pd.DataFrame(tfidf_matrix.toarray(), index=count_matrix.index, columns=count_matrix.columns)
tfidf_long = tfidf_df.reset_index().melt(id_vars=['wp_number'], var_name='word', value_name='tf_idf')
alt_tfidf = tfidf_long.sort_values(by='tf_idf', ascending=False).reset_index(drop=True)

print(alt_tfidf.head())

## the code below graphs that highest (average) tf-idf words by program

lab10_programs = lab10_nber[['wp_number', 'program']]
pooled_words = pd.merge(alt_tfidf, lab10_programs, on="wp_number", how="left")
pooled_words = pooled_words[pooled_words['tf_idf'] > 0.00001]
mean_tfidf = pooled_words.groupby(['program', 'word']).agg(
    mean=('tf_idf', 'mean')
).reset_index()
tfidf_words = mean_tfidf.groupby('program').apply(lambda x: x.nlargest(20, 'mean')).reset_index(drop=True)

g = sns.FacetGrid(tfidf_words, col='program', hue='program', col_wrap=2, sharey=False, height=12)

g.map_dataframe(
    sns.barplot,
    x='mean',
    y='word',
    alpha=0.9
)

g.set_axis_labels("tf_idf", "")
g.set_titles(col_template="{col_name}")  # Use column names as titles for each subplot
g.despine(left=True)

plt.show()


# step 6: words that distinguish fields ----------------------------

## the graph above isn't exactly what we want
## what is the highest tf-idf word in the data set?
## how many papers is it used in?

## to identify words that distinguish between fields (asset pricing vs. children)
##    we need to redo our tf-idf analysis using program in place of wp_number
##    (so it is really "term frequency inverse program frequency")
## with only two programs, how many values will idf (or df) take on?
## what are they?

## redo the tf-idf analysis above (step 5) using program instead of working paper number
## which words best distinguish between asset pricing papers and childrens papers?
## save your resulting graph as a pdf to upload to gradescope

## Python users: I suggest that you do this by hand and not using scikit learn 
##    if you want to get meaningful results


























