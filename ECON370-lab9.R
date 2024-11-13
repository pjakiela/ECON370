
## ECON 370 LAB 9: WEB SCRAPING AND REGULAR EXPRESSIONS 
## NAME:  
## DATE:  

## before you begin modifying this code, make sure it runs from start to finish!

# step 0 : preliminaries -------------------------------------------------------

## libraries
#install.packages("tidyverse")
#install.packages("revest")
#install.packages("gender")

library(tidyverse)
library(rvest)
library(gender)

## file path 



# step 1 : scrape html from department web page --------------------------------

## this example shows how to implement this for the ENGLISH department
## replace with the department you have been assigned

english_html <- read_html("https://english.williams.edu/faculty-staff/")


# step 2: extract professor names, profile page urls, and titles ---------------

## review the code below carefully and make sure that you understand how it works

## R: html_elements(".name") extracts every element where the attribute class = name
## R: html_text2() gets the text content from the selected (class = "name") elements
## R: html_elements("a") extracts every element with the tag "a" 
##    (in this case, every child w/ the tag "a" of an elemet with class = "name")
## R: html_attr("href") extracts the value of the attribute "href"

## Python: .select(".name") extracts every element where the attribute class = name
## Python: .get_text(strip=True) gets the text from the selected elements
## Python: .select(".name a") extracts every child with tag "a" of an element
##    with class = "name"
## Python: element["href"] extracts the value of the attribute "href"

english_names <- english_html %>% 
  html_elements(".name") %>% 
  html_text2()

english_pages <- english_html %>% 
  html_elements(".name") %>% 
  html_elements("a") %>% 
  html_attr("href")

## Modify the code above to extract the titles of each faculty/staff member


## check that the vectors of names, titles, and webpages are the same length
stopifnot(length(english_names) == length(english_pages))


# step 3: combine names, titles, urls into a data frame; rename variables ------

english_profs <- tibble(dept = rep('English', each=length(english_names)), 
                        name = english_names, 
                        url = english_pages) 


# step 4: restrict attention to tenure track faculty ---------------------------

## tenure track faculty will have "Professor" in their title
## filter out visiting faculty as well as retired (emeritus/emerita) faculty

#english_profs <- english_profs %>% 
#  filter(str_detect(title, 'Professor')) 


# step 5: isolate first names, guess gender ------------------------------------

## split the name string into the first name and the rest_of_name

english_profs <- english_profs %>% 
  separate_wider_delim(
    cols = name,
    delim = " ",
    names = c("first", "rest_of_name"),
    too_many = "merge", 
    cols_remove = FALSE
  ) 

## predict professor gender based social security data
## use gender() in R or gender.Detector() in Python
## (some alternatives use very vaguely sourced name data, may be unreliable)

guess_gender <- gender(english_profs$first, years = c(1940, 2000)) %>% 
  select(name, proportion_male, gender) %>% 
  rename(first = name, 
         prop_male = proportion_male)

## review your results for errors, add to rest of data

english_profs <- left_join(english_profs, guess_gender, join_by(first))

## what proportion of the tenured/tenure track faculty are female? 
## you will be asked to enter this into gradescope


# step 6: collect data on schools professors attended --------------------------

## step 6a: use the code above to scrape and extract data on the schools attended 
##    by the 1st professor in your data (this code is most of the way there)

school <- rep(NA, nrow(english_profs))

temp_url <- english_profs$url[1]
temp_html <- read_html(temp_url)
temp_content <- temp_html %>% 
  html_nodes(".profile-education") 


## step 6b: write a loop that extracts this information for all profs in department
##    add a pause after every two professors to avoid overloading servers
##    R:  use if(i %% 2 == 0) {Sys.sleep(20)}



## step 6c: add the 'school' column to the data --------------------------------


## step 6d: create 'undergrad' column with undergraduate (first) school --------

## adapt code from step 5 to split the school string



# step 7: identify faculty who went to liberal arts colleges -------------------

## the simplest way is probably to create a dummy for undergraduate institutions 
##    with names that include 'College' and then manually correct any errors



## what proportion of the tenured/tenure track faculty attended liberal arts colleges? 
## you will be asked to enter this into gradescope



# step 8: export your data as a csv --------------------------------------------

## your data frame should now contain the columns dept, first, rest_of_name, 
##    title, url, gender, undergrad, other_education, school, lib_arts
## export this data frame as a csv for you to upload to gradescope


