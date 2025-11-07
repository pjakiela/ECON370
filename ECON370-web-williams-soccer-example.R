
# preliminaries ----------------------------------------------------------------

## libraries
#install.packages("tidyverse")
#install.packages("rvest")
#install.packages("gender")

library(tidyverse)
library(rvest)
library(gender)


# scrape the williams soccer team roster web page ------------------------------

soccer_html <- read_html("https://ephsports.williams.edu/sports/womens-soccer/roster")


# get table containing data on players -----------------------------------------

player_table <- soccer_html %>% 
  html_element(".sidearm-table.sidearm-table-grid-template-1.sidearm-table-grid-template-1-breakdown-large") %>% 
  html_table()

# get names of players using selectorgadget ------------------------------------

player_names <- soccer_html %>% 
  html_elements(".sidearm-roster-player-name a") %>% 
  html_text2()

# guess play gender based on first names ---------------------------------------

first_names <- tibble(player_names) %>% 
  separate_wider_delim(player_names, " ", names = c("first", "last")) %>% 
  select(first)

guess_gender <- gender(first_names$first, years = c(2000)) %>% 
  select(name, proportion_male, gender) %>% 
  rename(first = name, 
         prop_male = proportion_male)
print(guess_gender, n=27)
