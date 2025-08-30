# Getting Started in R  

<br>

## Download R and RStudio

Download R and RStudio from the [posit](https://posit.co/download/rstudio-desktop/) website. Once you've done this, 
read the [Introduction to the 2nd edition of R for Data Science](https://r4ds.hadley.nz/intro.html#rstudio), focusing on the second half beginning with the part where 
they explain the different regions of the RStudio interface (the link takes you to the right place to start reading).  

Open RStudio on your computer. Install the [tidyverse](https://www.tidyverse.org/), [haven](https://haven.tidyverse.org/), and 
[fixest](https://lrberge.github.io/fixest/) packages, which we will use all the time. The Introduction to R for Data Science provides instructions 
on how to install packages and load libraries. The [tidyverse](https://www.tidyverse.org/) is a suite of tools for modern data analysis in R. It includes 
the packages and functions we'll use to clean data and define new variables ([dplyr](https://dplyr.tidyverse.org/)), 
make graphs ([ggplot2](https://ggplot2.tidyverse.org/)), and work with text data ([stringr](https://stringr.tidyverse.org/)). The [tidyverse](https://www.tidyverse.org/) 
website has a number of helpful cheatsheets that you may want to download. [Haven](https://haven.tidyverse.org/) is a tool for reading 
Stata (and SPSS and SAS) data sets into R, and [fixest](https://lrberge.github.io/fixest/) is a package that allows you to run 
economics-style regressions including fixed effects and robust or clustered standard errors.  

Before loading any data into R, read [Chapter 2 in R for Data Science](https://r4ds.hadley.nz/workflow-basics.html). Work through the examples in the reading. Make sure 
that you understand how to add comments to your code and how to define new objects using the assignment operator `<-`.  

<br>

## Loading Data

The R script below loads the tidyverse and haven libraries and loads a Stata data set directly from the web. 
```
# ECON 370: GETTING STARTED IN R

# preliminaries ----------------------------------

## libraries

## install these packages if needed
#install.packages("tidyverse")
#install.packages("haven") 

library(tidyverse)
library(haven)

## load data
urlfile <- "https://raw.githubusercontent.com/barrolee/BarroLeeDataSet/master/BLData/BL2013_MF1599_v2.2.dta"
bl <- read_dta(urlfile)
```

Copy this example into a new R script on your computer and run the code. The keyboard shortcut to open a new R script in RStudio is Ctrl + Shift + n. To run a piece of code, select it in the script editor and then hit Ctrl + Enter. Once you run the code, you should see the data frame `bl` listed in the `Environment` tab in the upper right. (`read_dta` loads the data as a tibble, which is the tidyverse version of a data frame.) If you enter `bl` in the console pane in the lower left part of your screen, R will print the first few rows of the data frame `bl`.  

The data you have loaded is part of the Barro-Lee Educational Attainment Data Set, which contains information on the education level 
of adults in over 140 countries. It is the most widely used data source documenting the rise in educational attainment that has taken place over 
the last century.  

<br>

## Familiarizing Yourself with the Data

Whenever you load data into R, you should explore it enough to answer the following questions:
1. How many observations are in the data frame?
2. How many variables are in the data frame?
3. What are the names of the variables?
4. Which variables are numeric and which are strings?
5. Which variables are actually categorical, and how are they stored?
6. Is there missing data? Where?

You can read the number of rows and columns in the data frame `bl` from the environment tab in the upper right. The number of observations is the number of rows, 
and the number of variables is the number of columns. To familiarize yourself with any data frame `df`, the commands `dim(df)`, `head(df)`, and `glimpse(df)` 
are also useful. `dim(df)` reports the the dimensions of `df`. `head(df)` prints a data frame containing the first six rows of `df`. `glimpse(df)` lists the names of the columns (i.e. variables) and their associated data types (typically either double, which indicates that the column contains a numeric variable, or character).  

Using only these functions, you should be able to answer questions 1 through 5, above.  

### Missing Values

The command `summary(bl)` will provide a summary of the numeric variables contained in the data frame `bl`, including the means, medians, minima, maxima, and counts of missing values. If you **just** want to check for missing values, you can also use the following:
```
colSums(is.na(bl))
```
`is.na(bl)` generates an array with the same dimensions as the data frame `bl`, but each value in the data frame is an indicator equal to one (or TRUE) if the analogous position in `df` is a missing value. (An array is a type of data frame where all the variables are of the same type, typically numeric.) As you might expect, `colSums(df)` sums the columns in the data frame `df`.

### Summarizing Numeric Variables 

One way to display the means of the numeric variables in the data frame `bl` is to use `summary(bl)`, as described above. This will print the means as well as the medians, minima, maxima, etc. Sometimes this is too much information. If you only want the mean of a single variable, for example the mean of `year` in the Barro-Lee data set, you can use:
```
mean(bl$year)
```
So, to get the mean of any column `x` in data frame `df`, you can always use `mean(df$x)`. This also works with other functions: for example, 
`min()`, `max()`, `sd()`, `sum()`. You can also use the `df$x` syntax in other ways - it always refers to the column named `x` in data frame `df`.  

If you want to see the means of **all** the numeric variables in the `bl` data frame, you could use the `colMeans()` function, which is closely related to the `colSums()` function described above:
```
colMeans(select_if(bl, is.numeric))
```
Notice that you need select the columns of that data frame `bl` that are numeric, since `colMeans()` can't calculate the mean of a string variable. Another approach is 
to use `summarize()`:
```
summarize(bl, across(where(is.numeric), mean, na.rm = TRUE))
```
You can find out more about the built-in functions described above by accessing RStudio's internal help files. For instance, to pull up the help file about `summarize()`, you can type `?summarize()` in the lower right panel of RStudio.

### Tabulating Values

It is often helpful to tabulate the most common values of a variable in a data set. One easy way to do this is to use the `count()` function. For example, to tabulate the values of the `region_code` variable in `bl`, you could type:
```
count(bl, region_code)
```
As you can see, `count()` takes two arguments: the first argument is the data frame and the second argument is the variable (or column). This is different than functions like `mean()` that take a single column (`df$column`) as the argument. When you use the code above

<br>

## Additional Readings  


[R for Data Science](https://r4ds.hadley.nz/): [7](https://r4ds.hadley.nz/data-import), [5](https://r4ds.hadley.nz/data-tidy), and [19](https://r4ds.hadley.nz/joins)  

[Intro to Data Science](https://rafalab.dfci.harvard.edu/dsbook-part-1/): [2](https://rafalab.dfci.harvard.edu/dsbook-part-1/R/R-basics.html), [4](https://rafalab.dfci.harvard.edu/dsbook-part-1/R/tidyverse.html), 
[6](https://rafalab.dfci.harvard.edu/dsbook-part-1/R/importing-data.html)  


<br>
