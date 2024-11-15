
## ECON 370 LAB 10: TERM FREQUENCIES 
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

## file path 



# step 1: load data ------------------------------------------------------------

## load the data set ECON370-lab10-data.csv

## familiarize yourself with the data set
## how many papers are included? how many in each program?

urlfile <- 'https://raw.githubusercontent.com/pjakiela/ECON370/refs/heads/gh-pages/ECON370-lab10-data.csv'
lab10_nber <- read_csv(urlfile)


# step 2: tokenize -------------------------------------------------------------

## step 2a: words --------------------------------------------------------------

## create a word-level data set containing all the words from the abstracts
## what are the 5 most common words in abstracts across all the papers?

## Note: R and Python use different tokenizers, so the word counts are different

abstract_words <- lab10_nber %>% 
  select(abstract) %>% 
  unnest_tokens(word, abstract) 



## step 2b: remove stopwords ---------------------------------------------------

## what are the 5 most common words after removing stopwords?

stopwords <- tibble(word = stopwords())

no_stop_words <- lab10_nber %>% 
  select(abstract) %>% 
  unnest_tokens(word, abstract) %>% 
  anti_join(stopwords)



# step 3: words by field -------------------------------------------------------

## step 3a: what are the 5 most common words in Asset Pricing abstracts?
##    (after removing stopwords)




## step 3b: what are the 5 most common words in Children & Families abstracts?
##    (after removing stopwords)


#### most common: effects, children, health, find, child

## step 3c: distinguishing words 

## combine your data frames containing words counts for each field


## use the code below to make a figure showing the top 50 words in each field

pooled_words %>%
  group_by(program) %>%
  slice_max(n, n = 50) %>%
  ungroup() %>%
  ggplot(aes(n, fct_reorder(word, n), fill = program)) +
  geom_col(show.legend = FALSE, alpha = 0.9) +
  facet_wrap(~program, ncol = 2, scales = "free_y") +
  labs(x = "Word Count", y = NULL)

## create a data frame containing the top 50 words in each field
## how many of the top 50 words are the same across fields?



# step 4: calculate tf-idf "by hand" --------------------------------------------

## to calculate tf-idf, we (of course) need to calculate tf and df

## create a data frame of words from abstracts that includes program and wp_number


## generate a data frame lab10_tf that includes document-level term frequencies
##    (i.e. document-level word counts normalized by the # of words in the document)


## calculate document frequency, i.e. the proportion of documents containing a given word
## this is at the word rather than the documentxword level
## the easiest way is to use ceiling() on your lab10_tf data frame 
##    to create an indicator for whether a given word is in a given document


## join lab10_tf and lab10_df by word and create lab10_tfidf


## what are the 5 "words" (one is an acronym) with the highest tf-idf?


# step 5: calculate tf-idf using bind_tf_idf or scikit-learn -------------------

## R users: 
## an alternative is to use the bind_tf_idf function 
## confirm that your tdidf indices (above) match these

## Python users: 
## an alternative is to use scikit-learn's TfidfTransformer, but...
##    ... it does not use the standard formula for the tf-idf statistic
## the TfidfTransformer tfidf values should be correlated with the ones
##    that you calculated in step 4, but not identical 

lab10_counts <- lab10_words %>%
  count(wp_number, word, sort = TRUE)

alt_tfidf <- bind_tf_idf(lab10_counts, word, wp_number, n) %>% 
  arrange(desc(tf_idf))

## the code below graphs that highest tf-idf words by program

papers_by_program <- lab10_nber %>% 
  select(wp_number, program)

alt_tfidf %>% 
  left_join(papers_by_program, join_by(wp_number)) %>% 
  group_by(program, word) %>%
  summarize(mean_tfidf = mean(tf_idf)) %>% 
  arrange(desc(mean_tfidf)) %>% 
  slice_max(mean_tfidf, n = 20) %>%
  ungroup() %>%
  ggplot(aes(mean_tfidf, fct_reorder(word, mean_tfidf), fill = program)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~program, ncol = 2, scales = "free_y") +
  labs(x = "tf-idf", y = NULL)


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


