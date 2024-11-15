#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct  2 15:49:23 2023

@author: jerry
"""


# %%

import pandas as pd



# %%

salary_data = pd.read_csv("./data/0104_exploratory_data_analysis/03_data_management/basic_salary.csv")



# %%

salary_data.loc[4:9]
salary_data.loc[[0, 2, 4]]
salary_data.loc[[0, 4, 7], ['First_Name', 'Last_Name']]



# %%

salary_data.iloc[:, 0:4]
salary_data.iloc[[0, 4, 7], [0, 1]]



# %%

salary_data[(salary_data.Location == 'MUMBAI') & (salary_data.ba > 15000)]
salary_data[(salary_data.Grade != 'GR1') & (salary_data.Location != 'MUMBAI')]



# %%

salary_data.loc[(salary_data.Grade == 'GR1') & (salary_data.ba > 15000), ['First_Name', 'Grade', 'Location']]



# %%

sorted_sd = salary_data.sort_values(by = ['ba'])
sorted_sd.head()



# %%

sorted_sd = salary_data.sort_values(by = ['ba'], ascending = [0])
sorted_sd.head()



# %%

sorted_sd = salary_data.sort_values(by = ['Grade'])
sorted_sd.head()



# %%

sorted_sd = salary_data.sort_values(by = ['Grade'], ascending = [0])
sorted_sd.head()



# %%

sorted_sd = salary_data.sort_values(by = ['Grade', 'ba'])
sorted_sd.head(10)



# %%

sorted_sd = salary_data.sort_values(by = ['Grade', 'ms'], ascending = [0, 1])
sorted_sd.head(10)
