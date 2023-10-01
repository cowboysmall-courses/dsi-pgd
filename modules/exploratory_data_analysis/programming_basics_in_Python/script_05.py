#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct  1 13:01:37 2023

@author: jerry
"""


from datetime import datetime

x = '5 jan 2010'
type(x)



ndate1 = datetime.strftime(datetime.strptime(x, '%d %b %Y'), '%d %b %Y')
ndate1
type(ndate1)



ndate2 = datetime.strptime(x, '%d %b %Y')
ndate2
type(ndate2)



datetime.strptime(x, '%d %b %Y').strftime('%Y%B')
datetime.strptime(x, '%d %b %Y').strftime('%A')
datetime.strptime(x, '%d %b %Y').strftime('%B')



import pandas as pd

pd.Timestamp(x).quarter



datetime.strptime("12-01-2015", '%m-%d-%Y').strftime('%Y-%m-%d')

date = datetime.now()
date
date.hour
date.minute
date.second



from datetime import date

today = date.today()
today



d1 = datetime.date(datetime.strptime("20101201", "%Y%m%d"))
d2 = datetime.date(datetime.strptime("10/7/04", "%m/%d/%y"))
d1 - d2




d3 = { 
    'EmpID': [101, 102, 103, 104, 105], 
    'year': [1977, 1989, 2000, 2012, 2015], 
    'month': [2, 5, 10, 1, 11], 
    'day': [2, 3, 1, 1, 5] 
}

df = pd.DataFrame(d3)
df

df['Date'] = pd.to_datetime(df[['year', 'month', 'day']])
df



