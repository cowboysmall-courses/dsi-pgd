#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct  2 16:39:01 2023

@author: jerry
"""



# %%

import pandas as pd



# %%

salary_data = pd.read_csv("./data/0104_exploratory_data_analysis/03_data_management/sal_data.csv")
bonus_data = pd.read_csv("./data/0104_exploratory_data_analysis/03_data_management/bonus_data.csv")



# %%

left_join = pd.merge(salary_data, bonus_data, how = 'left')
left_join



# %%

right_join = pd.merge(salary_data, bonus_data, how = 'right')
right_join



# %%

inner_join = pd.merge(salary_data, bonus_data)
inner_join



# %%

outer_join = pd.merge(salary_data, bonus_data, how = 'outer')
outer_join



# %%

salary_1 = pd.read_csv("./data/data_management/basic_salary - 1.csv")
salary_2 = pd.read_csv("./data/data_management/basic_salary - 2.csv")

pd.concat([salary_1, salary_2])



# %%

salary_data = pd.read_csv("./data/data_management/basic_salary.csv")

salary_data.groupby('Location')['ms'].sum()
salary_data.groupby('Location')['ba', 'ms'].sum()
salary_data.groupby(['Location', 'Grade'])[['ba', 'ms']].sum()
