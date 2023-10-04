#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  3 10:59:13 2023

@author: jerry
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.formula.api as smf

job_data = pd.read_csv("../../../data/descriptive_statistics/Job_Proficiency.csv")
job_data.describe(include = 'all')

plt.scatter(job_data.aptitude, job_data.job_prof, color = 'red')
plt.xlabel('Aptitude')
plt.ylabel('Job Proficiency')
# plt.show()

np.corrcoef(job_data.aptitude, job_data.job_prof)

model = smf.ols("job_prof ~ aptitude", data = job_data).fit()
model.summary()




retail_data = pd.read_csv("../../../data/descriptive_statistics/Retail_Data.csv")
retail_data.describe(include = 'all')

freq1 = pd.crosstab(index = retail_data.Zone, columns = retail_data.NPS_Category)
freq1

freq2 = pd.crosstab(index = retail_data.Zone, columns = retail_data.NPS_Category, normalize = True)
freq2

freq3 = pd.crosstab(index = retail_data.Zone, columns = retail_data.NPS_Category, normalize = 'index')
freq3

freq4 = pd.crosstab(index = retail_data.Zone, columns = retail_data.NPS_Category, normalize = 'columns')
freq4


table = pd.crosstab([retail_data.Zone, retail_data.NPS_Category], retail_data.Retailer_Age, margins = False)
table
