#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct  1 15:11:40 2023

@author: jerry
"""


# %%

import pandas as pd



# %%

salary_data = pd.read_csv("./data/0104_exploratory_data_analysis/data_management/basic_salary.csv")

salary_data.shape
salary_data.columns
list(salary_data)
salary_data.info()



# %%

salary_data["Location"] = salary_data["Location"].astype('category')
salary_data["Location"]
salary_data["Location"].cat.categories



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

salary_data.describe(include = 'all')



# %%

salary_data = salary_data.rename(columns = {'ba': 'Basic_Allowance'})
list(salary_data)



# %%

salary_data = salary_data.assign(newvariable = salary_data['Basic_Allowance'] * 0.05)
salary_data.head()



# %%

salary_data.Location.replace(to_replace = ['MUMBAI', 'DELHI'], value = [1, 2], inplace = True)
salary_data.head()



# %%

ba_labels = ['LOW', 'MEDIUM', 'HIGH']
ba_bins = [0, 14000, 19000, 24000]
salary_data['Category'] = pd.cut(salary_data['Basic_Allowance'], ba_bins, labels = ba_labels)
salary_data.head()



# %%

ba_decile = salary_data['Basic_Allowance'].quantile(q = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9])
ba_decile



# %%

salary_data.drop('Last_Name', axis = 1, inplace = True)
salary_data.head()



# %%

salary_data.drop(salary_data.index[1:4], axis = 0, inplace = True)
salary_data.head()



# %%

salary_data.drop(salary_data[salary_data.Location == 1].index, inplace = True)
salary_data.head()
