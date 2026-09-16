# EDA Project

Objective: to explore cross-country differences in outcomes or changes in countries over time using data from a range of sources  

## Topic and Scope

The goal of this project is to use (cross-country) data to explore a research question, either about how countries differ from one another 
or about how they are changing over time. Your focus can be on any economic, political, social, or business topic: trade policy, 
support for democracy, child health, gender norms, tourismy - it is entirely up to you (and your group).  

You are free to analyze data from around the world or to focus on a particular region (e.g. Eastern Europe, Latin America) or set of countries 
(e.g. low-income countries or former French colonies). You can also choose to look at data from a single point in time 
or to look at changes over time. 

## Data

You need to use at least two sources of data. 

One of these should be 
the [World Development Indicators](https://databank.worldbank.org/source/world-development-indicators). You should select 
at least five WDI indicators, including at least two that we did not analyze in Lab 2. Download the WDI data that you are going to use 
and save it as a CSV file. You will upload this raw data file together with your project.

Your second source of data can be anything, as long as the data are publicly-available. A few possibilities are:

- [European Social Survey](https://www.europeansocialsurvey.org/)
- [World Values Survey](https://www.worldvaluessurvey.org/wvs.jsp)
- [Afrobarometer](https://www.afrobarometer.org/)
- [CEPII Trade Data](https://www.cepii.fr/CEPII/en/bdd_modele/bdd_modele.asp)

For many of these sources, you will want to collapse the raw data into a country or country-year level data set.

## Analysis

Your analysis should proceed in three steps.   

First, you need to define a topic and a data set. You will identify a set of variables and a set of countries 
that you will focus on. Variables must be non-missing for all the countries in your data set. You should 
provide details on the prepocessing decisions you made: how you chose your data sources, which countries 
and/or variables were dropped because of missing data, whether you chose to impute missing values (and, if so, how), etc. 

Second, you should explore your variables individually and in relation to each other. What patterns do you observe? 
Which variables are correlated? The patterns that you observe in the raw data should motivate your use of dimension reduction 
and clustering techniques.

Third, you will use principal components and clustering to explore the hidden patterns in your cross-country data. You sould use 
PCA to reduce your large set of variables into a few key summary indices capturing the 
variation in the data. You may choose to feed all of your variables into PCA or to focus on a subset, as appropriate. You may 
choose to rescale your variables or not, as appropriate. Your goal is to produce a visualization of your principal component scores 
that highlights important dimensions of variation (likely grouping your countries in terms of some salient category visually). You 
should also use clustering, either based on the raw data or the principal components, to identify groups of countries that are 
similar in terms of the variables you have analyzed.

## Elements of the Poster

You will present your results in the form of a poster (48"X36"), together with replication files that generate your tables and figures 
from the raw, publicly-available data sources. Your finished poster should include:  

1. A statement of your research questions, your country sample, together with a brief motivation
2. A description of your data sources including a (nicely formatted) list of the variables you analyze
3. A histogram or kernel density plot
4. A scatter plot or bar graph showing the relationship between two variables
5. At least one visualization representing either principal components analysis or k-means clustering
6. A statement of your conclusions

Your goal is to articulate a clear research question and provide a compeling answer to it using data. I will be 
evaluating both the quality of your question and the quality of your answer.  

## Timeline

- Email me by Friday 9/18 if you would like to form your own group
- Email me no later than midnight on Tuesday 9/22 informing me of your topic
- We will have short meetings finalizing data sources on 9/23
- We will have longer group meetings 9/30. Drafts of all of your figures must be completed prior to these meetings.
- Posters must be submitted to me and to [print services](https://service.williams.edu/TDClient/174/Portal/KB/Article/5129/Academic-Poster-Printing) by midnight on 10/1. Replication materials are also due at that time.
- Bring your final poster to class on 10/7 for our poster session


