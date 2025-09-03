# Getting Started in Python  

<br>

## Download Python and Spyder

Download the Python distribution anaconda from the [anaconda](https://www.anaconda.com/download/success) website using the distribution installers links 
on the left. Once you've done this, you should be able to open spyder on your computer (it is installed as part of the anaconda distribution). You should 
see three panels within spyder. The one on the left is the script editor where you will write your python scripts, and the one on 
the bottom right is the IPython console, where you can enter commands interactively. For example, if you type 
```
x = 2 + 5
```
in the IPython console and hit enter, you will see `x` appear in the Variable Explorer tab in the upper right. The command above 
defined `x` as 7 (the sum of 2 and 5). Now, if you 
type `x` into the IPython console and hit enter, it will report the output 7 (the value of `x`).

<br>

## Loading Data

The Python code below loads the [numpy](https://numpy.org/) and [pandas](https://pandas.pydata.org/docs/index.html) 
libraries and then loads a Stata data set directly from the web. 
```
# ECON 370: GETTING STARTED IN R

# preliminaries ----------------------------------

## libraries
import numpy as np
import pandas as pd

## load data
urlfile = 'https://raw.githubusercontent.com/barrolee/BarroLeeDataSet/master/BLData/BL2013_MF1599_v2.2.dta'
bl = pd.read_stata(urlfile)
```

[numpy](https://numpy.org/) (short for numerical python) 
is Python's scientific computing library, which allows you to define numerical arrays and do a range of 
mathematical calculations. [pandas](https://pandas.pydata.org/docs/index.html) is the main data analysis library, 
and almost all of the data manipulation that we do in this class will involve pandas data frames.

Copy this example into a new python script on your computer and run the code. Once you run the code, you should see the data frame `bl` listed in the `Variable Explorer` tab 
in the upper right. If you enter `bl` in the IPython console in the lower right, Python will print the first and last rows of the data frame `bl`.  

The data you have loaded is part of the Barro-Lee Educational Attainment Data Set, which contains information on the education level 
of adults in over 140 countries. It is the most widely used data source documenting the rise in educational attainment that has taken place over 
the last century.  

<br>

## Familiarizing Yourself with the Data

Whenever you load data into Python, you should explore it enough to answer the following questions:
1. How many observations are in the data frame?
2. How many variables are in the data frame?
3. What are the names of the variables?
4. Which variables are numeric and which are strings?
5. Which variables are actually categorical, and how are they stored?
6. Is there missing data? Where?

You can read the number of rows and columns in the data frame `bl` from the `Variable Explorer` tab in the upper right. To familiarize yourself with any data frame `df`, 
the commands `df.shape`, `df.head`, `df.columns`, and `df.dtypes` 
are also useful. `df.shape` reports the the dimensions of `df`. `df.head` prints the first and last rows of `df`. `df.columns` lists the names of the columns (i.e. variables), and `df.dtypes` lists both the names of the columns and their associated data types (typically either `float`, which indicates that the column contains a numeric variable, or `object`, which indicates a string variable).  

Using only these tools, you should be able to answer questions 1 through 5, above.  

### Missing Values

The command `bl.describe()` will provide a summary of the numeric variables contained in the data frame `bl`, including the means, medians, minima, maxima, and counts of non-missing values. If you **just** want to check for missing values, you can also use the following:
```
bl.isna().sum()
```
`bl.isna()` generates an array with the same dimensions as the data frame `bl`, but each value in the data frame is an indicator equal to one (or TRUE) if the analogous position in `df` is a missing value. As you might expect, `.sum()` sums the columns in the data frame `bl`.

### Summarizing Numeric Variables 

One way to display the means of the numeric variables in the data frame `bl` is to use `bl.describe()`, as described above. This will print the means as well as the medians, minima, maxima, etc. Sometimes this is too much information. If you only want the mean of a single variable, for example the mean of `year` in the Barro-Lee data set, you can use:
```
bl['year'].mean()
```
To get the mean of any column `x` in data frame `df`, you can always use `df['x'].mean()`. This also works with other functions: for example, 
`min()`, `max()`, `median()`, `std()`, `var()`, `sum()`. `df['x']` is Python's way of pointing to the column named `x` in pandas data frame `df`.   

If you want to see the means of **all** the numeric variables in the `bl` data frame, you could use: 
```
bl.mean(axis=0, numeric_only=True)
```
Notice that you need to select the columns of that data frame `bl` that are numeric using the `numeric_only` argument, since Python can't calculate the mean of a string variable. The `axis` argument tells Python to calculate the average across rows (axis 0) rather than across columns (axis 1). (Python numbering 
more or less always starts from 0, which takes some getting used to.)

### Tabulating Values

It is often helpful to tabulate the most common values of a variable in a data set. One easy way to do this is to use the `value_counts()`. For example, to tabulate the values of the `region_code` variable in `bl`, you could type:
```
bl['region_code'].value_counts()
```
or, equivalently,
```
bl.region_code.value_counts()
```

<br>

## Next Steps

At this point, you should feel comfortable reading data sets into Python and exploring them. 

<br>

## Additional Readings  




<br>
