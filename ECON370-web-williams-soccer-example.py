

# preliminaries ---------------------------------------------------------------

## libraries

import numpy as np
import pandas as pd
import time
import requests
import bs4 as BeautifulSoup 
from io import StringIO
import gender_guesser.detector as gender# you may need to install


# scrape the williams soccer team roster web page -----------------------------

url = "https://ephsports.williams.edu/sports/womens-soccer/roster"
response = requests.get(url)
soccer_html = BeautifulSoup.BeautifulSoup(response.content, "html.parser")


# get table containing data on players ----------------------------------------

table = soccer_html.select_one(".sidearm-table.sidearm-table-grid-template-1.sidearm-table-grid-template-1-breakdown-large")

player_table = pd.read_html(StringIO(str(table)))[0]
print(player_table.head())


# get names of players using selectorgadget -----------------------------------

player_names = [element.get_text(strip=True) for element in soccer_html.select(".sidearm-roster-player-name a")]


# guess play gender based on first names --------------------------------------

soccer_team = pd.DataFrame(
    {'name': player_names
    })

soccer_team[['first', 'last']] = soccer_team['name'].str.split(' ', n=1, expand=True)

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


soccer_team['gender'] = predict_gender(soccer_team['first'])