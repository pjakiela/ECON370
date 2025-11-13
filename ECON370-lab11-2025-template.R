
## ECON 370 LAB 11: TEXT AS DATA 
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
username <- Sys.getenv("USERNAME")
pjpath <- paste0("C:/Users/", username, "/Dropbox/ECON-370/topics/11-text/lab/")
datapath <- paste0("C:/Users/", username, "/Dropbox/ECON-370/data/nber/")

oigreen <- "#009E73"
oiblue <- "#0072B2"
oiverm <- "#D55E00"
oipurple <- "#CC79A7"
oiyellow <- "#F0E442"
oiorange <- "#E69F00"
oisky <- "#56B4E9"


# step 1: load data ------------------------------------------------------------

## load the data set ECON370-NBER-data.csv directly from the course github

## familiarize yourself with the data set

urlfile <- 'https://raw.githubusercontent.com/pjakiela/ECON370/refs/heads/gh-pages/ECON370-NBER-data.csv'
lab11_nber <- read_csv(urlfile)


# step 2: select your two favorite NBER programs -------------------------------

## info on the different NBER pograms and their areas of focus is here:  
##    https://www.nber.org/programs-projects/programs-working-groups

## keep only papers associated with your two programs of choice, 
##    and drop the other program name columns

nber <- lab11_nber %>% 
  filter(Development_Economics == 1 | Labor_Studies == 1) %>% 
  select(wp_number, title, abstract, Development_Economics, Labor_Studies)

## how many papers are included in your analysis data set?


# step 3: preprocessing -------------------------------------------------------

## tokenize the text of the abstracts, remove stop words and non-words, 
##    calculate term frequency (count of word i / total words in abstract)

## do you want to do any additional context-specific preprocessing?
##    for example, removing final "s"s from the end of words? 
##    grouping important words together (eg child and children)

stopwords <- tibble(word = stopwords())

nber_tf <- nber %>% 
  ## tokenize
  select(wp_number, abstract) %>% 
  unnest_tokens(word, abstract) %>% 
  ## a small amount of manual preprocessing
  mutate(word = if_else(str_detect(word, "schools"), "school", word)) %>% 
  mutate(word = if_else(str_detect(word, "firms"), "firm", word)) %>% 
  mutate(word = if_else(str_detect(word, "jobs"), "job", word)) %>% 
  ## calculate term frequency instead of count
  count(wp_number, word) %>% 
  group_by(wp_number) %>% 
  mutate(proportion = n / sum(n)) %>% 
  ungroup() %>%
  ## remove words that do not include at least one letter
  filter(str_detect(word, "[a-zA-Z]")) %>% 
  ## remove stop words
  anti_join(stopwords) 

print(nber_tf)

# step 4: k-means clustering ---------------------------------------------------

## create a document term matrix

nber_dtm <- nber_tf %>% 
  cast_dtm(document = wp_number, term = word, value = proportion)

## implement k-means clustering for a given number of clusters

set.seed(867)
num_clusters <- 4
kmeans.data <- as.matrix(nber_dtm)
kfit <- kmeans(kmeans.data, num_clusters, nstart = 50)

### R: kfit$cluster is a vector indicating which cluster each paper is in

results <-  tibble(nber, kfit$cluster) %>% 
  rename(cluster = `kfit$cluster`) 

### do the clusters split papers along the same lines as the NBER programs?
### (note that this may or may not be a useful diagnostic)

look_at_clusters <- results %>% 
  select(!wp_number & !title & !abstract)
look_at_clusters <- 1 * look_at_clusters
look_at_clusters <- look_at_clusters %>% 
  group_by(cluster) %>% 
  summarize(n = n(), 
            mean_dev = mean(Development_Economics), 
            mean_labor = mean(Labor_Studies))
look_at_clusters

### are the clusters reasonably sized? are there tiny or very large clusters?

cluster_stats <- results %>% 
  group_by(cluster) %>% 
  summarize(n = n())
print(cluster_stats)

### which words are most associated with each cluster?

### kfit$centers is a num_clusters x length_of_dtm matrix
### indicating the mean value of each word/tf/feature/variable
### in the center of each cluster

### this code plots the words most strongly associated w/ each cluster
### do the groupings make sense?

## calculate differential likelihood of each word for each cluster
ws_c1 <- (kfit$centers[1,] - colMeans(kfit$centers[-1,])) 
ws_c2 <- (kfit$centers[2,] - colMeans(kfit$centers[-2,])) 
ws_c3 <- (kfit$centers[3,] - colMeans(kfit$centers[-3,])) 
ws_c4 <- (kfit$centers[4,] - colMeans(kfit$centers[-4,])) 

## combine these word scores into a data frame
word_scores <- tibble(word = names(ws_c1), 
                      ws_c1, ws_c2, ws_c3, ws_c4) %>% 
  pivot_longer(!word, names_to = "cluster", values_to = "score") %>% 
  mutate(cluster = if_else(cluster == "ws_c1", paste0("Cluster 1 (N = ", cluster_stats$n[1], ")"), cluster)) %>% 
  mutate(cluster = if_else(cluster == "ws_c2", paste0("Cluster 2 (N = ", cluster_stats$n[2], ")"), cluster)) %>% 
  mutate(cluster = if_else(cluster == "ws_c3", paste0("Cluster 3 (N = ", cluster_stats$n[3], ")"), cluster)) %>% 
  mutate(cluster = if_else(cluster == "ws_c4", paste0("Cluster 4 (N = ", cluster_stats$n[4], ")"), cluster))

## plot the words that identify each cluster
group.colors <- c(oiblue, oiyellow, oiverm, oigreen)
word_scores %>% 
  group_by(cluster) %>% 
  slice_max(score, n = 10) %>% 
  ungroup() %>%
  ggplot(aes(score, fct_reorder(word, score), fill = cluster)) +
  geom_col(show.legend = FALSE, alpha = 0.96) +
  facet_wrap(~cluster, ncol = 2, scales = "free_y") +
  scale_fill_manual(values=group.colors) + 
  labs(x = "Term Frequency", y = NULL) + 
  theme(
    axis.title.x = element_text(size = 16),
    axis.title.y = element_text(size = 16), 
    axis.text=element_text(size = 16), 
    strip.text = element_text(size = 20)
  )


## now that you understand how the code works, 
##    rerun it a few times with different seeds
## how stable is it across seeds?
## are there very large or small clusters?
## do the word groupings make sense?
## do you think this is the right number of clusters? 
## is there any additional preprocessing that might improve fit?

## tinker with the code until you have a (relatively) stable, 
##    reasonable set of clusters that you are happy with
## change the number of clusters as needed, or adjust the preprocessing, etc.
## fix a seed that generates a graph you like, and save that graph
