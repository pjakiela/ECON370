
## ECON 370 LAB 1:  DATA CLEANING AND PREP 
## NAME:  
## DATE:  


# preliminaries --------------------------------------------------------------

## install packages / load libraries as needed and load libraries 
## you'll need at least tidyverse for R, numpy and pandas for Python

install.packages("tidyverse") # comment out this line after you've installed the package once

library(tidyverse)

## specify your file path by defining mypath as the path to your working directory for this lab

## R suggestion: mypath <- "[YOUR FILE PATH IN QUOTES]"
## Python suggestion: mypath = "[YOUR FILE PATH IN QUOTES]"

setwd("[YOUR FILE PATH]")
mypath <- "[YOUR FILE PATH]"

# get the barro-lee data on educational attainment ---------------------------

## load barro-lee educational attainment data set from a csv file
## the barro lee website is here:  http://barrolee.com/
## download the csv for the data set on Education Attainment for Population Aged 15 and Over (Total Population)
## the file should be called:  BL2013_MF1599_v2.2.csv
## load the data as a tibble or pandas dataframe called bldata

## R suggestion: read_csv()
## Python suggestion: mypath = pd.read_csv


bldata <- read_csv(paste0(mypath,"\\data\\BL2013_MF1599_v2.2.csv"))

## how many observations are in the data set?  how many variables?  
## which variables are string (or character) variables?

## R suggestions:  dim(), glimpse(), head(), summary() 
## Python suggestions: type(), df.info, df.shape, df.columns, df.dtypes



## define a new tibble called bl2010 which only contains BL data from 2010
## keep only the columns: BLcode, country, yr_sch, WBcode, region_code
## rename yr_sch as mean_edu, WBcode as isocode, and region_code as wb_region

## R suggestion:  use the pipe and the filter, select, and rename functions
## Python suggestion:  df[df['x1'] == VALUE] selects a subset of the rows of dataframe df
## Python suggestion:  df[['x1', 'x2', 'x3']] selects a subset of the columns of dataframe df
## Python suggestion:  rename columns with
## df = df.rename(columns={
##    'old_var_name': 'new_var_name',
## })



## make a table/tibble summarizing the average rate of educational attainment by region

## R suggestion:  use group_by() and pipe to summarize()
## Python suggestion:  use df.groupby().agg()



## add a column to bl2010 that is a dummy variable high_income for being in an advanced economy
## what is the mean of that dummy variable?

## R suggestion:  use mutate(), if_else(), and str_detect()
## Python suggestion:  use np.where() and .str.contains()



# get World Bank data on GDP per capita from the World Development Indicators ----

## dowload data on GDP per capita from the World Bank's World Development Indicators database
## url: https://databank.worldbank.org/source/world-development-indicators
## select all the countries
## under series look for:  GDP per capita (constant 2015 US$)
## under time choose 2010
## save as a csv WDI_2010_GDPPC.csv in your working directory
## load as a tibble/dataframe called wdidata



# merge the data sources ---------------------------------------------------------

## combine the data on educational attainment and GDP per capita into a single data frame using a merge or join
## call the final data frame lab1data
## how many countries are in the final data set? 

## R suggestion:  use inner_join() or left_join()
## Python suggestion:  use pd.merge()




## make a table showing the mean level of schooling, GDP per capita, and high_income by region




