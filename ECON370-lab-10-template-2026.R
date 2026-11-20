

## ECON 370 LAB 10: TEXT AS DATA 
## NAME:  
## DATE:  

# preprocessing ----------------------------------------------------------------
# preprocessing ----------------------------------------------------------------

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

urlfile <- 'https://raw.githubusercontent.com/pjakiela/ECON370/refs/heads/gh-pages/lab10NBERdata.csv'
df <- read_csv(urlfile)

## separate the data into the training sample and the test sample

## how many papers are in the test data?
## how many labor papers are in the test data?
## how many non-labor papers are in the test data?

train_df <- df %>% 
  filter(train == 1) %>% 
  select(!train)

test_df <- df %>% 
  filter(train == 0) %>% 
  select(!train)


# step 2: tokenize -------------------------------------------------------------

## 2a. the template below separates the abstracts into single-word tokens

## what is the most common word in paper abstracts?
## what is the most common word in *labor* paper abstracts?
## what is the most common word in *non-labor* paper abstracts?

## modify the code to remove stop-words using an anti-join
## what is the most common word in labor and non-labor papers now?

stopwords <- tibble(word = stopwords())

train_words <- train_df %>% 
  select(paper_id, abstract) %>% 
  unnest_tokens(word, abstract) %>% # tokenize
  filter(str_detect(word, "[a-zA-Z]")) # remove tokens containing no letters

count(train_words, word) %>% 
  arrange(desc(n))

## 2b. the template below separates the abstracts into bigrams

## what are the most common bigrams?
## how might you remove bigrams that include stop words?
## when should you do so?

train_bigrams <- train_df %>% 
  select(paper_id, abstract) %>% 
  unnest_tokens(bigram, abstract, token = "ngrams", n = 2) %>% 
  filter(str_detect(bigram, "[a-zA-Z]")) # remove tokens containing no letters

count(train_bigrams, bigram) %>% 
  arrange(desc(n))


# step 3: term frequencies and tf-idf ------------------------------------------

## the template below calculates term frequencies and tf-idf
## which words have the highest tf and tf-idf values?
## which words have the *lowest* tf and idf values? what does this indicate?

## extend the code below to filter out words that only appear in one paper
## how does this change your answers (to the questions above)?

## how do your results change if you adjust step 2 to remove stopwords?

train_tf <- train_df %>% 
  select(paper_id, abstract) %>% 
  ## tokenize
  unnest_tokens(word, abstract) %>% 
  ## term frequencies
  count(paper_id, word) %>% 
  group_by(paper_id) %>% 
  mutate(tf = n / sum(n)) %>% 
  ungroup() %>%
  ## remove words that do not include at least one letter
  filter(str_detect(word, "[a-zA-Z]")) %>% 
  ## document frequencies and tfidf
  add_count(word, name = "n_docs") %>% 
  mutate(df = n_docs / nrow(train_df), 
         idf = log(1 / df), 
         tf_idf = tf * idf) 
 

# step 4: creating a document term matrix --------------------------------------

## the template below pivots the data to a document term matrix (dtm)
## how many variables (unique words) does it contain?

## we have used tf_idf; tf or word indicators also work

train_dtm <- train_tf %>% 
  select(paper_id, word, tf_idf, n_docs) %>% 
  filter(n_docs >= 1) %>% 
  select(!n_docs) %>% 
  pivot_wider(names_from = word, values_from = tf_idf, values_fill = 0)


# pause and reflect ------------------------------------------------------------

## how could you improve the preprocessing pipeline above?
## what should be added or modified to better capture paper topics?


# predicting labor studies papers ----------------------------------------------
# predicting labor studies papers ----------------------------------------------

## now we are going to identify labor papers using the text of the abstracts
## i've provided some templates and suggestions below. 

## in step 5, we predict labor papers with an indicator for the most common word
## in step 6, we build a richer dictionary of words that distinguish labor from macro
## in step 7, we use ols to identify words (or tf, etc) that predict labor studies
## step 8 is a suggestion: you could also do this with lasso, or a forest

## go through these approachs to see how they do at predicting labor studies
## make sure you understand what each approach is doing
## then refine your pipeline to build the best predictive model you can

## step 5: most common labor words ---------------------------------------------

## five most common words in labor paper abstracts
top_labor <- train_df %>% 
  filter(labor_studies == 1) %>% 
  select(paper_id, abstract) %>% 
  unnest_tokens(word, abstract) %>% 
  filter(str_detect(word, "[a-zA-Z]")) %>% 
  anti_join(stopwords, join_by(word)) %>% 
  count(word) %>% 
  arrange(desc(n)) %>% 
  slice(1:5)
top_labor

## simple predictive model: does the abstract contain most common labor word?

word_match_df <- test_df %>% 
  mutate(predict_labor = if_else(str_detect(abstract, "[Ww]orker"), 1, 0), 
         correct_match = 1 * (labor_studies == predict_labor)) 
mean(word_match_df$correct_match)
word_match_df %>% filter(labor_studies == 0) %>% count(predict_labor)
word_match_df %>% filter(labor_studies == 1) %>% count(predict_labor)

ols_5a <- lm(labor_studies ~ predict_labor, data = word_match_df)
summary(ols_5a)

## step 6: a dictionary of labor and non-labor (macro) words -------------------

## five most common words in labor paper abstracts
top_labor <- train_df %>% 
  filter(labor_studies == 1) %>% 
  select(paper_id, abstract) %>% 
  unnest_tokens(word, abstract) %>% 
  filter(str_detect(word, "[a-zA-Z]")) %>% 
  anti_join(stopwords, join_by(word)) %>% 
  count(word) %>% 
  arrange(desc(n)) %>% 
  slice(1:5)
top_labor

## five most common words in non-labor (macro) paper abstracts
top_macro <- train_df %>% 
  filter(labor_studies == 0) %>% 
  select(paper_id, abstract) %>% 
  unnest_tokens(word, abstract) %>% 
  filter(str_detect(word, "[a-zA-Z]")) %>% 
  anti_join(stopwords, join_by(word)) %>% 
  count(word) %>% 
  arrange(desc(n)) %>% 
  slice(1:5)
top_macro

## score each paper: how many of the five labor (macro) words appear in its abstract?
train_scores <- train_tf %>% 
  mutate(labor_word = word %in% top_labor$word, 
         macro_word = word %in% top_macro$word) %>% 
  group_by(paper_id) %>% 
  summarize(labor_score = sum(labor_word), 
            macro_score = sum(macro_word))
## alternatives: sum(tf * labor_word) or sum(tf_idf * labor_word)

## attach the scores to the papers (a paper with none of the words gets 0, not NA)
train_scored <- train_df %>% 
  left_join(train_scores, by = "paper_id") %>% 
  replace_na(list(labor_score = 0, macro_score = 0)) %>% 
  mutate(net_score = labor_score - macro_score)

## do the scores separate labor studies papers from non-labor papers?
train_scored %>% 
  group_by(labor_studies) %>% 
  summarize(n = n(), 
            mean_labor_score = mean(labor_score), 
            mean_macro_score = mean(macro_score), 
            mean_net_score = mean(net_score))

## how well do these scores do? 

## adapt code from above tokenize test abstracts, calculate scores

test_scores <- test_df %>% 
  select(paper_id, abstract) %>% 
  ## tokenize
  unnest_tokens(word, abstract) %>% 
  ## remove words that do not include at least one letter
  filter(str_detect(word, "[a-zA-Z]")) %>% 
  ## remove stop words
  anti_join(stopwords, join_by(word)) %>% 
  mutate(labor_word = word %in% top_labor$word, 
         macro_word = word %in% top_macro$word) %>% 
  group_by(paper_id) %>% 
  summarize(labor_score = sum(labor_word), 
            macro_score = sum(macro_word)) 

## attach the scores to the papers (a paper with none of the ten words gets 0, not NA)
test_scored <- test_df %>% 
  left_join(test_scores, by = "paper_id") %>% 
  replace_na(list(labor_score = 0, macro_score = 0)) %>% 
  mutate(net_score = labor_score - macro_score) %>% 
  mutate(predict_labor = if_else(net_score >= median(net_score), 1, 0),
         correct_match = 1 * (labor_studies == predict_labor)) 
summary(test_scored$correct_match)

## do the scores separate labor from non-labor papers?
test_scored %>% 
  group_by(labor_studies) %>% 
  summarize(n = n(), 
            mean_labor_score = mean(labor_score), 
            mean_macro_score = mean(macro_score), 
            mean_net_score = mean(net_score))

## step 7: regression ----------------------------------------------------------

## modify train_dtm to identify the most common or highest tf or tf-idf words
## regress labor_studies on each of these, individually, in the training data
## OR
## regress labor_studies on the most common words
## which words are the most predictive of labor papers?
## build a predictive model or dictionary based on these words

freq_cutoff <- 36

ols_dtm <- train_tf %>% 
  select(paper_id, word, tf_idf, n_docs) %>% 
  filter(n_docs >= freq_cutoff) %>% 
  select(!n_docs) %>% 
  pivot_wider(names_from = word, values_from = tf_idf, values_fill = 0) %>% 
  left_join(select(train_df, paper_id, labor_studies), join_by(paper_id)) %>% 
  select(!paper_id)

ols_words <- lm(labor_studies ~ ., data = ols_dtm)
summary(ols_words)

## optional step 8: lasso ------------------------------------------------------

## adapt the lasso or rlasso syntax from lab 7

## note that the variables/words in test_dtm and train_dtm will need to be identical
## ... if you want to use lasso to predict whether a paper is in labor studies

## alternatively, you can use rlasso to choose a set of predictor words,
## ... and then run OLS on those words to build your predictive model

## you will need library(hdm) for rlasso and library(glmnet) for cv.glmnet

## 8a. use rlasso to choose the words (as in Lab 7, step 7)

## Hint: rlasso() needs a matrix X and a vector Y whose rows line up;
## ... train_dtm is not in the same row order as train_df, so join on paper_id

X <- train_dtm %>% 
  select(!paper_id) %>% 
  as.matrix()

Y <- train_dtm %>% 
  select(paper_id) %>% 
  left_join(select(train_df, paper_id, labor_studies), join_by(paper_id)) %>% 
  pull(labor_studies)

## which words does rlasso select? how many?
## Hint: the names in lasso.reg$index carry an X prefix, as in Lab 7



## 8b. run OLS on the selected words in the training data

## Hint: train_tf has the tf and tf_idf of every word in every paper;
## ... filter it to the selected words and pivot_wider, as in step 7



## 8c. predict labor studies papers in the test data

## Hint: this works like step 6: tokenize the test abstracts, keep only the
## ... selected words, and pivot to one row per paper (a paper with none of the
## ... words gets zeros); then predict() with your OLS model and classify at 0.5

## how does the test accuracy compare to the dictionary in step 6? to step 7?



## 8d. (even more optional) compare to a straight cv.glmnet lasso prediction

## Hint: predict() needs a test dtm with exactly the same columns as train_dtm,
## ... in the same order: setdiff() finds the missing words, select(all_of()) orders them

## why might OLS on the words rlasso selects predict about as well as cv.glmnet,
## ... with far fewer words?
## what happens if you run OLS on the words cv.glmnet selects at lambda.min? why?

