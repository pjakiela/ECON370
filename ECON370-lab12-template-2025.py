

## ECON 370 LAB 12: CHARACTERIZING DOCUMENTS
## NAME:  
## DATE:  


# step 0: preliminaries -------------------------------------------------------

import os
import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.metrics.pairwise import euclidean_distances
import matplotlib.pyplot as plt


## file path


# step 1: load data -----------------------------------------------------------

## load the data set ECON370-NBER-data.csv directly from the course github




# step 2: document distance ---------------------------------------------------

# 2.1 select a program to focus on --------------------------------------------

## create a data frame w/ only papers from that program, and only the variables 
##    wp_number, title, author, and abstract

## do not choose Development Economics because that is used in the example
## do not choose Corporate Finance or Environment and Energy Economics...
## .... because we talked about the two most similar papers in class




# 2.2 calculate TFIDF ---------------------------------------------------------

## tokenize the abstracts, calculate TFIDF, create a document-term matrix
# replace dashes with nothing in abstracts

# Hint: use TfidfVectorizer from sklearn to do this in one step



# 2.3: calculate cosine similarity of documents in your chosen program --------

## Hint: use sklearn cosine_similarity() 
## Hint 2: create a pandas data frame with your results, indexed by paper #

dev_sim = cosine_similarity(dev_dtm)

dev_sim_df = pd.DataFrame(
    dev_sim,
    index=dev['wp_number'],
    columns=dev['wp_number']
)

dev_sim_df.index.name = 'paper1'
dev_sim_df.columns.name = 'paper2'

# 2.4: convert to a long data frame with variables paper1, paper2, & cos_sim --

dev_sim_long = (
    dev_sim_df
    .stack()
    .reset_index()
)
dev_sim_long.columns = ['paper1', 'paper2', 'cos_sim']

# 2.5: find the two most similar papers within your chosen program ------------

## have your code print the line of your df containing the most similar papers

## Hint: look back at your code from Lab 4


# 2.6: find the most original paper in terms of cosine similarity -------------

## calculate paper-level averages of cosine similarity
## identify the paper that is the least similar to other papers, on average

# 2.7: repeat steps 2.3, 2.4, 2.5, and 2.6 with Euclidean distance ------------

## find the two most similar papers by the Euclidean distance metric
## find the most unique paper by the Euclidean distance metric
## do your answers match those from 3.5 and 3.6?

## Hint: use sklearn euclidean_distances()



# 2.8: merge cosine similarity and euclidean distance metrics -----------------

## make a scatter plot showing cosine similarity vs. euclidean distance
## how correlated are they? are there interesting outliers?



