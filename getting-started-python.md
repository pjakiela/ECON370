# Getting Started in Python  

<br>

## Download Python and Spyder

Download the Python distribution anaconda from the [anaconda](https://www.anaconda.com/download/success) website using the distribution installers links 
on the left. Once you've done this, you should be able to open spyder on your computer (it is installed as part of the anaconda distribution).  

Now stop and read sections 1.1 and 1.2 of [Using Python for Introductory Economics](https://www.urfie.net/downloads/PDF/UPfIE_web.pdf). The reading will explain 
the setup of the spyder interface, which has a script editor window on the left and an interactive IPython window in the lower right. It will also introduce 
[numpy](https://numpy.org/) and [pandas](https://pandas.pydata.org/docs/index.html), the two main libraries that we will be working with throughout the 
semester. [numpy](https://numpy.org/) (short for numerical Python) 
is Python's scientific computing library, which allows you to define numerical arrays and do a range of 
mathematical calculations. [pandas](https://pandas.pydata.org/docs/index.html) is the main data analysis library, 
and almost all of the data manipulation that we do in this class will involve pandas data frames.

<br>

## Loading Data

The Python script below imports [numpy](https://numpy.org/) and [pandas](https://pandas.pydata.org/docs/index.html) 
and then loads a Stata data set directly from the web. 
```
# ECON 370: GETTING STARTED IN Python

# preliminaries ----------------------------------

## libraries
import numpy as np
import pandas as pd

## load data
urlfile = 'https://raw.githubusercontent.com/barrolee/BarroLeeDataSet/master/BLData/BL2013_MF1599_v2.2.dta'
bl = pd.read_stata(urlfile)
```

Copy this example into a new python script on your computer and run the code. Once you run the code, you should see the data frame `bl` listed in the `Variable Explorer` tab 
in the upper right. If you enter `bl` in the IPython console in the lower right, Python will print the first and last rows of the data frame `bl`.  

The data you have loaded is part of the [Barro-Lee Educational Attainment Data Set](http://barrolee.com/?page_id=99), which contains information on the education level 
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
are also useful. `df.shape` reports the the dimensions of `df`. `df.head` prints the first rows of `df`. `df.columns` lists the names of the columns (i.e. variables), and `df.dtypes` lists both the names of the columns and their associated data types (typically either `float`, which indicates that the column contains a numeric variable, or `object`, which indicates a string variable).  

Using only these tools, you should be able to answer questions 1 through 5, above.  

### Missing Values

The command `bl.describe()` will provide a summary of the numeric variables contained in the data frame `bl`, including the means, medians, minima, maxima, and counts of non-missing values. If you **just** want to check for missing values, you can also use the following:
```
bl.isna().sum()
```
`bl.isna()` generates an array with the same dimensions as the data frame `bl`, but each value in the data frame is an indicator equal to one (or TRUE) if the analogous position in `df` is a missing value. As you might expect, `sum()` sums the columns in the data frame `bl`.

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

It is often helpful to tabulate the most common values of a variable in a data set. One easy way to do this is to use `value_counts()`. For example, to tabulate the values of the `region_code` variable in `bl`, you could type:
```
bl['region_code'].value_counts()
```
or, equivalently,
```
bl.region_code.value_counts()
```

<br>

## Next Steps

At this point, you should feel comfortable reading data sets into Python and exploring them. Before moving on to the first lab, 
it is worth reading (or at least skimming) sections 1.3, 1.4, and 1.8 of 
[Using Python for Introductory Economics](https://www.urfie.net/downloads/PDF/UPfIE_web.pdf). 1.3 explains how to load data into Python, 
1.4 introduces [matplotlib](https://matplotlib.org/), the most widely used data visualization library. 1.8 introduces some more advanced concepts 
like functions and loops.

<br>

## Additional Readings  

[Data Analysis Using Python](https://wesmckinney.com/book/)


<br>
