
## ECON 370 LAB 1:  EXPLORATORY DATA ANALYSIS 
## NAME:  
## DATE:  


# preliminaries ---------------------------------------------------------------

## libraries
import os # set your file path
import numpy as np # numerical python
import pandas as pd # data frames and statistical analysis
import statsmodels.api as sm # calculate kernel densities
import matplotlib.pyplot as plt # plots



# Step 1: load the Barro-Lee educational attainment data ----------------------

## download the Barro-Lee education attainment data set from github

urlfile = 'https://raw.githubusercontent.com/barrolee/BarroLeeDataSet/master/BLData/BL2013_MF1599_v2.2.dta'
bldata = pd.read_stata(urlfile)


# Step 2: familiarize yourself with the data -----------------------------------

## Insert code to answer these questions.
## Add comments providing any numeric answers requested.

## Check out the Getting Started labs for hints if you are new to Python

## 1a. How many observations are in the data set?  
## 1b. How many variables?  
## 1c. which variables are string (or character) variables?


# Step 3: restrict the sample to 2010 -----------------------------------------

## define a new data frane called bl2010 which only contains BL data from 2010
## keep only the columns: BLcode, country, yr_sch, WBcode, region_code
## rename yr_sch as mean_edu, WBcode as isocode, and region_code as wb_region

## Hint 1:  df[df['x1'] == VALUE] selects a subset of the rows of dataframe df
## Hint 2:  df[['x1', 'x2', 'x3']] selects a subset of the columns of dataframe df
## Hint 3:  rename columns with
## df = df.rename(columns={
##    'old_var_name': 'new_var_name',
## })



## Step 4: make and print a data frame summarizing average education by region 

## Hint:  use df.groupby().agg()


## Step 5: add a column to bl2010 that is a dummy variable high_income --------
## where high_income is 1 for advanced economies and zero otherwise
## what is the mean of that dummy variable?

## Hint:  use np.where() and .str.contains()



## Step 6: create a tibble wdidata by reading in WDI data on GDP per capita ---

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

## Hint 1: use pd.read_csv() with the skiprows, usecols, and names arguments
## Hint 2: use pd.to_numeric with the errors argument to convern pc_gdp_2010 to numeric format



## Step 7: merge the Barro-Lee and WDI data into a single data frame lab1data -

## your goal is to correctly match as many countries as possible
## then drop any countries that are missing data for mean_edu or pc_gdp_2010

## how many countries are in the final data set? 

## Hint 1: use isocode as the merge key (not country) - why is this better?
## Hint 2: use pd.merge()
## Hint 3: first try "outer" merge, fix countries that should merge but don't
## Hint 4: the indicator argument to pd.merge() can help with this


## Step 8: make a table showing the mean schooling, GDP, and high_income by region


## Step 9: define a variable ln_gdp indicate the natural log of pc_gdp_2010,
## then make a histogram of GDP per capita using a log scale

## adapt the matplotlib code below to make your histogram look like the example
## save your histogram as a pdf, make sure the pdf looks good

## Hint: adapt this code

lab1data['ln_gdp'] = np.log(lab1data['pc_gdp_2010'])
ln_gdp = lab1data['ln_gdp'] 

kde = sm.nonparametric.KDEUnivariate(ln_gdp)
kde.fit()

plt.hist(ln_gdp, density = True)
plt.plot(kde.support, kde.density)



## Step 10: make a scatter plot with education on the y-axis and log GDP on the x-axis

## adapt the matplotlib code below to make your scatter plot look like the example
## save your histogram as a pdf, make sure the pdf looks good

plt.scatter(lab1data['mean_edu'], lab1data['ln_gdp'])
lowess = sm.nonparametric.lowess
z = lowess(lab1data['ln_gdp'], lab1data['mean_edu'], frac=0.4)  
plt.plot(z[:, 0], z[:, 1])




















