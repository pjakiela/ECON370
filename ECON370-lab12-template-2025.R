
## ECON 370 LAB 12: CHARCTERIZING DOCUMENTS
## NAME:  
## DATE:  

# step 0: preliminaries --------------------------------------------------------

## libraries
# install.packages("tidyverse")
#install.packages("tidytext")
#install.packages("tm")

library(tidyverse)
library(tidytext)
library(tm)
library(lsa)
library(widyr)

## file path 



# step 1: load data ------------------------------------------------------------

## load the data set ECON370-NBER-data.csv directly from the course github






# step 2: document distance ----------------------------------------------------

# 2.1 select a program to focus on ---------------------------------------------

## create a data frame w/ only papers from that program, and only the variables 
##    wp_number, title, author, and abstract

## do not choose Development Economics because that is used in the example
## do not choose Corporate Finance or Environment and Energy Economics...
## .... because we talked about the two most similar papers in class


# 2.2 calculate TFIDF ----------------------------------------------------------

## tokenize the abstracts, calculate TFIDF, create a document-term matrix
# replace dashes with nothing in abstracts

## Hint: use unnest_tokens, the bind_tf_idf, then cast_dtm



# 2.3: calculate cosine similarity of documents in your chosen program ---------

## Hint: use cosine() from the lsa package
## Hint 2: do cosine similarity on the transpose of as.matrix(your_dtm)

dev_sim <- cosine(t(as.matrix(dev_dtm)))

# 2.4: convert to a long data frame with variables paper1, paper2, & cos_sim ---

## delete the rows where paper1 == paper2

dev_sim_long <- dev_sim %>%
  as.data.frame() %>%
  rownames_to_column(var = "paper1") %>%   
  pivot_longer(
    cols = -paper1,                         
    names_to = "paper2",
    values_to = "cos_sim"
  )



# 2.5: find the two most similar papers within your chosen program -------------

## have your code print the line of your df containing the most similar papers

## Hint: look back at your code from Lab 4



# 2.6: find the most original paper in terms of cosine similarity --------------

## calculate paper-level averages of cosine similarity
## identify the paper that is the least similar to other papers, on average


# 2.7: repeat steps 2.3, 2.4, 2.5, and 2.6 with Euclidean distance -------------

## find the two most similar papers by the Euclidean distance metric
## find the most unique paper by the Euclidean distance metric
## do your answers match those from 3.5 and 3.6?

## Hint: use dist()


# 2.8: merge cosine similarity and euclidean distance metrics -------------------

## make a scatter plot showing cosine similarity vs. euclidean distance
## how correlated are they? are there interesting outliers?


