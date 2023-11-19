#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct  1 13:36:27 2023

Jerry Kiely
Data Science Institute
Programming Basics in Python
EDA T7 Assignment

@author: jerry
"""



# %%

import numpy as np
import pandas as pd
import math

from datetime import datetime, date



# %% 1

M = pd.DataFrame(np.array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2]).reshape(3, 4), index = ("A", "B", "C"), columns = ("Q", "W", "E", "R"))
M
#    Q   W  E  R
# A  1   2  3  4
# B  5   6  7  8
# C  9  10  1  2


M = pd.DataFrame(np.random.randint(1, 11, size = (3, 4)), index = ("A", "B", "C"), columns = ("Q", "W", "E", "R"))
M
#    Q   W  E  R
# A  1  10  1  9
# B  4   4  2  2
# C  9   5  2  2




# %% 2

x = 24
y = "Hello World"
z = 93.65

type(x)
# int
type(y)
# str
type(z)
# float

f1 = pd.Categorical([x])
f2 = pd.Categorical([y])
f3 = pd.Categorical([z])

f1.dtype
# CategoricalDtype(categories=[24], ordered=False)
f2.dtype
# CategoricalDtype(categories=['Hello World'], ordered=False)
f3.dtype
# CategoricalDtype(categories=[93.65], ordered=False)




# %% 3

q = 65.9836
round(math.sqrt(q), 3)
# 8.123
math.log10(q)
# 1.819436006533418
math.log10(q) < 2
# True




# %% 4

x = ["Intelligence", "Knowledge", "Wisdom", "Comprehension"]
y = "I am"
z = "intelligent"

[w[:4] for w in x]
# ['Inte', 'Know', 'Wisd', 'Comp']
y + " " + z
# 'I am intelligent'
[w.upper() for w in x]
# ['INTELLIGENCE', 'KNOWLEDGE', 'WISDOM', 'COMPREHENSION']




# %% 5

a = [3, 4, 14, 17, 3, 98, 66, 85, 44]

for i in a:
    if i % 3 == 0:
        print("Yes")
    else:
        print("No")
# Yes
# No
# No
# No
# Yes
# No
# Yes
# No
# No

for i in a:
    print("Yes" if i % 3 == 0 else "No")
# Yes
# No
# No
# No
# Yes
# No
# Yes
# No
# No

print(["Yes" if i % 3 == 0 else "No" for i in a])
# ['Yes', 'No', 'No', 'No', 'Yes', 'No', 'Yes', 'No', 'No']

print(", ".join(["Yes" if i % 3 == 0 else "No" for i in a]))
# Yes, No, No, No, Yes, No, Yes, No, No




# %% 6

b = [36, 3, 5, 19, 2, 16, 18, 41, 35, 28, 30, 31]

for i in b:
    if i < 30:
        print(i)
# 3
# 5
# 19
# 2
# 16
# 18
# 28


for i in filter(lambda v : v < 30, b):
    print(i)
# 3
# 5
# 19
# 2
# 16
# 18
# 28

print(list(filter(lambda v : v < 30, b)))
# [3, 5, 19, 2, 16, 18, 28]

print(", ".join(str(i) for i in filter(lambda v : v < 30, b)))
# 3, 5, 19, 2, 16, 18, 28




# %% 7

Date = "01/06/2018"
# as it is ambiguous whether the above date is formatted 
# using '%m/%d/%Y' or '%d/%m/%Y', I have provided both 
# cases below. Also, I provided cases for both datetime 
# and date.



# Datetime

Date1_new = datetime.strptime(Date, '%m/%d/%Y')
Date2_new = datetime.strptime(Date, '%d/%m/%Y')

Date1_new.strftime("%A")
# 'Saturday'
Date2_new.strftime("%A")
# 'Friday'

Date1_new.strftime("%B")
# 'January'
Date2_new.strftime("%B")
# 'June'

now = datetime.now()

now - Date1_new
# datetime.timedelta(days=2094, seconds=53040, microseconds=120716)
now - Date2_new
# datetime.timedelta(days=1948, seconds=53040, microseconds=120716)



# Date

Date1_new = datetime.date(datetime.strptime(Date, '%m/%d/%Y'))
Date2_new = datetime.date(datetime.strptime(Date, '%d/%m/%Y'))

Date1_new.strftime("%A")
# 'Saturday'
Date2_new.strftime("%A")
# 'Friday'

Date1_new.strftime("%B")
# 'January'
Date2_new.strftime("%B")
# 'June'

now = date.today()

now - Date1_new
# datetime.timedelta(days=2094)
now - Date2_new
# datetime.timedelta(days=1948)
