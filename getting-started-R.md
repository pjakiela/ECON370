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

##install these packages if needed
#install.packages("tidyverse")
#install.packages("haven") 

library(tidyverse)
library(haven)

## load data
urlfile <- "https://raw.githubusercontent.com/barrolee/BarroLeeDataSet/master/BLData/BL2013_MF1599_v2.2.dta"
bl <- read_dta(urlfile)
```

Copy this example into a new R script on your computer and run the code. The keyboard shortcut to open a new R script in RStudio is Ctrl + Shift + n. To run a piece of code, select it in the script editor and then hit Ctrl + Enter. Once you run the code, you should see the data frame `bl` listed in the `Environment` tab in the upper right. If you type the command `bl` into the console pane in the lower left, R will list the first few rows of the data frame `bl`.

## Additional Readings  

_These are useful references as opposed to required readings._

[R for Data Science](https://r4ds.hadley.nz/): [7](https://r4ds.hadley.nz/data-import), [5](https://r4ds.hadley.nz/data-tidy), and [19](https://r4ds.hadley.nz/joins)  

[Intro to Data Science](https://rafalab.dfci.harvard.edu/dsbook-part-1/): [2](https://rafalab.dfci.harvard.edu/dsbook-part-1/R/R-basics.html), [4](https://rafalab.dfci.harvard.edu/dsbook-part-1/R/tidyverse.html), 
[6](https://rafalab.dfci.harvard.edu/dsbook-part-1/R/importing-data.html)  


<br>
