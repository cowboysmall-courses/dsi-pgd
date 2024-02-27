#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct  5 13:58:53 2023

@author: jerry
"""


# %%

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns



# %%

employee_data = pd.read_csv("./data/0104_exploratory_data_analysis/05_data_visualisation/JOB PROFICIENCY DATA.csv", index_col = 0)
employee_data.info()



# %%

plt.figure()
sns.lmplot('aptitude', 'job_prof', data = employee_data)
plt.title('Scatter Plot with Regression Line')
plt.xlabel('Aptitude')
plt.ylabel('Job Proficiency')



# %%

plt.figure()
sns.pairplot(employee_data)
plt.title('Scatter Plot Matrix')



# %%

plt.figure()
sns.scatterplot('tech_', 'job_prof', data = employee_data, hue = 'aptitude', size = 'aptitude')
plt.title('Bubble Chart')
plt.xlabel('Technical')
plt.ylabel('Job Proficiency')
