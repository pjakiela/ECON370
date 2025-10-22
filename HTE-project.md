# Treatment Effect Heterogeneity Project

Objective: to estimate the extent of treatment effect heterogeneity in a randomized trial

## Topic and Scope

The goal of this project is to replicate and extend the analysis presented in a published economics paper 
that reports the results of a randomized trial. Your analysis has two main parts. First, you will compare the authors' main results 
with results from a standard difference-in-means specification, an ancova specification, and a post double selection lasso 
specification. Second, you will test for treatment effect heterogeneity using a causal forest and identify the most important predictors 
of the heterogeneity that you find.  

## Data

To complete this project, you need to identify a published randomized trial for which replication data are available. An extensive list of published 
economics papers with replication data available is available [here](https://ejd.econ.mathematik.uni-ulm.de/), curated by Sebastian Kranz. Select a paper that is 
tagged as a randomized trial or a field experiment, download the replication data, and confirm that you are able to replicate the authors' main specification.  

## Steps

There are five steps to completing the project: 

1. Identify a published randomized trial with replication data available, and confirm that you are able to (at least approximately) replicate the authors' main specification. The main specification should be the test of the authors' primary hypothesis regarding the impact of treatment on their main outcome of interest.
2. Select a set of baseline (or unchanging) covariates to use in your analysis, possibly including interactions, and preprocess the data as needed.
3. Compare a PDS lasso specification to a standard difference-in-means specification, an ancova specification (where possible), and the authors' preferred specification. Discuss your findings.
4. Using the same set of covariates, assess the extent of treatment effect heterogeneity using a causal forest and identify the main predictors of the heterogeneity that you find.
5. Prepare a 15-18 minute talk summarizing your findings, supported by a complete set of replication files and an associated readme document.

## Roadmap

To receive full credit for the project, you need to choose your randomized trial and confirm that you are able to replicate the authors' main specification by October 24. Prior to your group's 
one-on-one meeting with Professor Jakiela, you need to prepare a two-page document, supported with replication files, that discusses the baseline covariates that you have selected and presents 
(a draft of) your PDS lasso comparison table. Final slides and replication files need to be uploaded by...
