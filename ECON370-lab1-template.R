
## ECON 370 LAB 1:  EXPLORATORY DATA ANALYSIS 
## NAME:  
## DATE:  


# preliminaries ----------------------------------------------------------------

## libraries

## install these packages if needed
#install.packages("tidyverse")
#install.packages("haven") 

library(tidyverse)
library(haven)


# Step 1: load the Barro-Lee educational attainment data -----------------------

## download the Barro-Lee education attainment data set from github

urlfile <- "https://raw.githubusercontent.com/barrolee/BarroLeeDataSet/master/BLData/BL2013_MF1599_v2.2.dta"
bldata <- read_dta(urlfile)

# Step 2: familiarize yourself with the data -----------------------------------

## Insert code to answer these questions.
## Add comments providing any numeric answers requested.

## Check out the Getting Started labs for hints if you are new to R

## 1a. How many observations are in the data set?  
## 1b. How many variables?  
## 1c. which variables are string (or character) variables?


# Step 3: restrict the sample to 2010 ------------------------------------------

## define a new tibble called bl2010 which only contains BL data from 2010
## keep only the columns: BLcode, country, yr_sch, WBcode, region_code
## rename yr_sch as mean_edu, WBcode as isocode, and region_code as wb_region

## Hint:  use the pipe and the filter, select, and rename functions


## Step 4: make and print a data frame summarizing average education by region -

## Hint:  use group_by() and then pipe to summarize()


## Step 5: add a column to bl2010 that is a dummy variable high_income ---------
## where high_income is 1 for advanced economies and zero otherwise

## R suggestion:  use mutate(), if_else(), and str_detect()



## Step 6: create a tibble wdidata by reading in WDI data on GDP per capita ----

## the data is online at:
## https://github.com/pjakiela/ECON370/raw/refs/heads/gh-pages/ECON370-WDI-GDP-per-capita-2010.csv
## read the data in directly from github (without saving it to your computer)

## the data is from the World Bank's Development Indicators Database
## data covers all the countries for the year 2010
## the variable of interest is:  GDP per capita (constant 2015 US$)

## name the three variables country, isocode, and pc_gdp_2010
## convert pc_gdp_2010 to a numeric variable if necessary
## restrict the sample to valid country observations with non-missing data on GDP per capita

## how many countries are included in the final version of wdidata?

## Hint: use the read_csv() options col_names, col_select, and skip arguments



## Step 7: merge the Barro-Lee and WDI data into a single data frame lab1data --

## your goal is to correctly match as many countries as possible
## then drop any countries that are missing data for mean_edu or pc_gdp_2010

## how many countries are in the final data set? 

## Hint 1: use isocode as the merge key (not country) - why is this better?
## Hint 2: first try full_join(), fix countries that should merge but don't
## Hint 3: then use inner_join() 


## Step 8: make a table showing the mean schooling, GDP, and high_income by region



## Step 9: define a variable ln_gdp indicate the natural log of pc_gdp_2010,
## then make a histogram of GDP per capita using a log scale

## adapt the ggplot code below to make your histogram look like the example
## save your histogram as a pdf using ggsave, make sure the pdf looks good

## Hint: adapt this code

ggplot(lab1data, aes(pc_gdp_2010)) + 
  geom_histogram(aes(y = after_stat(density)), bins = 10, color="tomato", fill="tomato", alpha = 0.36) +
  geom_density(adjust = 0.8) + 
  scale_x_continuous()
  
  ) 


## Step 10: make a scatter plot with education on the y-axis and log GDP on the x-axis

## adapt the ggplot code below to make your scatter plot look like the example
## save your histogram as a pdf using ggsave, make sure the pdf looks good

## example to provide
ggplot(lab1data, aes(x = pc_gdp_2010, y = mean_edu)) + 
  geom_point() +
  geom_smooth(method = "loess") 
