#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  3 10:59:13 2023

@author: jerry
"""


# %%

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.formula.api as smf



# %%

job_data = pd.read_csv("./data/0104_exploratory_data_analysis/descriptive_statistics/Job_Proficiency.csv")
job_data.describe(include = 'all')



# %%

plt.scatter(job_data.aptitude, job_data.job_prof, color = 'red')
plt.xlabel('Aptitude')
plt.ylabel('Job Proficiency')
# plt.show()



# %%

np.corrcoef(job_data.aptitude, job_data.job_prof)



# %%

model = smf.ols("job_prof ~ aptitude", data = job_data).fit()
model.summary()



# %%

retail_data = pd.read_csv("./data/0104_exploratory_data_analysis/descriptive_statistics/Retail_Data.csv")
retail_data.describe(include = 'all')



# %%

pd.crosstab(index = retail_data.Zone, columns = retail_data.NPS_Category)
pd.crosstab(index = retail_data.Zone, columns = retail_data.NPS_Category, normalize = True)
pd.crosstab(index = retail_data.Zone, columns = retail_data.NPS_Category, normalize = 'index')
pd.crosstab(index = retail_data.Zone, columns = retail_data.NPS_Category, normalize = 'columns')
pd.crosstab([retail_data.Zone, retail_data.NPS_Category], retail_data.Retailer_Age, margins = False)
