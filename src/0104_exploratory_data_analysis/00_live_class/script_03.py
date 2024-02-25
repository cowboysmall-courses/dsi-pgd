#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Oct  7 10:14:26 2023

@author: jerry
"""


# %%

import pandas as pd


# %%

salary_data = pd.read_csv("./data/0104_exploratory_data_analysis/data_management/basic_salary.csv")


# %%

sorted_ba = salary_data.sort_values(by = ['ba'])
sorted_ba.head()


# %%

sorted_ba = salary_data.sort_values(by = ['ba'], ascending = [0])
sorted_ba.head()


# %%

sorted_grade = salary_data.sort_values(by = ['Grade'])
sorted_grade.head()


# %%

sorted_grade_ba = salary_data.sort_values(by = ['Grade', 'ba'])
sorted_grade_ba.head(n = 10)


# %%

sorted_grade_ba = salary_data.sort_values(by = ['Grade', 'ms'], ascending = [0, 1])
sorted_grade_ba.head(n = 10)
