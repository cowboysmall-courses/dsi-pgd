#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Oct  7 09:12:02 2023

@author: jerry
"""

# %% import...

import pandas as pd


# %% load data...

salary_data = pd.read_csv("./data/0104_exploratory_data_analysis/03_data_management/basic_salary.csv")


salary_data.shape
list(salary_data)
salary_data.info()


# %%

salary_data['Location'] = salary_data['Location'].astype('category')
salary_data['Location'].cat.categories


# %%

salary_data.memory_usage()


# %%

salary_data.isnull().sum()


# %%

salary_data.head()
salary_data.head(n = 2)

salary_data.tail()
salary_data.tail(n = 2)


# %%

salary_data.describe()
salary_data.describe(include = 'all')


# %%

salary_data = salary_data.rename(columns = {'ba': 'Basic_Allowance'})
list(salary_data)


# %%

salary_data = salary_data.assign(New_Variable = salary_data['Basic_Allowance'] * 0.05)
salary_data.head(n = 3)


# %%

salary_data.drop('Last_Name', axis = 1, inplace = True)
salary_data.head()


# %%

salary_data.drop(salary_data.index[1:4], axis = 0, inplace = True)
salary_data.head(n = 4)


# %%

salary_data.drop(salary_data[salary_data.Location == 'MUMBAI'].index, inplace = True)
salary_data
