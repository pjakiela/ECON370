
## ECON 370 LAB 9: WEB SCRAPING AND REGULAR EXPRESSIONS 
## NAME:  
## DATE:  
    
    ## before you begin modifying this code, make sure it runs from start to finish!
    
# step 0 : preliminaries ------------------------------------------------------

## libraries

import numpy as np
import pandas as pd
import time
import requests
import bs4 as BeautifulSoup # you may need to install
import gender_guesser.detector as gender# you may need to install

## file path



# step 1 : scrape html from department web page -------------------------------

## this example shows how to implement this for the ENGLISH department
## replace with the department you have been assigned

url = "https://english.williams.edu/faculty-staff/"
response = requests.get(url)
english_html = BeautifulSoup.BeautifulSoup(response.content, "html.parser")


# step 2: extract professor names, profile page urls, and titles --------------

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

english_names = [element.get_text(strip=True) for element in english_html.select(".name")]
english_pages = [element["href"] for element in english_html.select(".name a") if "href" in element.attrs]

## Modify the code above to extract the titles of each faculty/staff member


## check that the vectors of names, titles, and webpages are the same length
assert len(english_names) == len(english_pages)



# step 3: combine names, titles, urls into a data frame; rename variables -----

english_profs = pd.DataFrame(
    {'dept': np.repeat("English", len(english_names)),
     'name': english_names,
     'url': english_pages
    })


# step 4: restrict attention to tenure track faculty --------------------------

## tenure track faculty will have "Professor" in their title
## filter out visiting faculty as well as retired (emeritus/emerita) faculty

#english_profs = english_profs[english_profs['title'].str.contains('Professor')]



# step 5: isolate first names, guess gender -----------------------------------

## split the name string into the first name and the rest_of_name

english_profs[['first', 'rest_of_name']] = english_profs['name'].str.split(' ', n=1, expand=True)
first_names = english_profs['first'].tolist()

## predict professor gender based social security data
## use gender() in R or gender.Detector() in Python
## (some alternatives use very vaguely sourced name data, may be unreliable)

gd = gender.Detector()

def predict_gender(names):
    genders = []
    for name in names:
        gender_prediction = gd.get_gender(name, country = "usa")
        if gender_prediction == 'male':
            genders.append('male')
        elif gender_prediction == 'mostly_male':
            genders.append('male')
        elif gender_prediction == 'female':
            genders.append('female')
        elif gender_prediction == 'mostly_female':
                genders.append('female')
        else:
            genders.append('unknown')
    return genders

## review your results for errors, add to rest of data

english_profs['gender'] = predict_gender(first_names)

## what proportion of the tenured/tenure track faculty are female? 
## you will be asked to enter this into gradescope


# step 6: collect data on schools professors attended --------------------------

## step 6a: use the code above to scrape and extract data on the schools attended 
##    by the 1st professor in your data (this code is most of the way there)

school = []
temp_url = english_profs.url[0]
response = requests.get(temp_url)
temp_html = BeautifulSoup.BeautifulSoup(response.content, "html.parser")
temp_content = temp_html.select(".profile-education")



## step 6b: write a loop that extracts this information for all profs in department
##    add a pause after every two professors to avoid overloading servers
##    R: one option is to use if(i %% 2 == 0) {Sys.sleep(20)}
##    Python: one option is to use time.sleep(20)



## step 6c: add the 'school' column to the data -------------------------------



## step 6d: create 'undergrad' column with undergraduate (first) school --------
## adapt code from step 5 to split the school string



# step 7: identify faculty who went to liberal arts colleges -------------------

## the simplest way is probably to create a dummy for undergraduate institutions 
##    with names that include 'College' and then manually correct any errors



## what proportion of the tenured/tenure track faculty attended liberal arts colleges? 
## you will be asked to enter this into gradescope



# step 8: export your data as a csv -------------------------------------------

## your data frame should now contain the columns dept, first, rest_of_name, 
##    title, url, gender, undergrad, other_education, school, lib_arts
## export this data frame as a csv for you to upload to gradescope



