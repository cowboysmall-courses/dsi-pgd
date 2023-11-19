#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Oct 14 09:04:02 2023

@author: jerry
"""


# %% 0 - import libraries

import pandas as pd
import numpy as np
import scipy.stats as stats

import matplotlib.pyplot as plt
import seaborn as sns




# %% 1 - import data, check dimensions...
bank_data = pd.read_csv("../../../data/eda/live_class/Bank_Churn.csv")

bank_data.info()
bank_data.shape

bank_data.head()
bank_data.tail()




# %% 2 - check distribution of credit score for exited == 1 and exited == 0
bank_exit_0 = bank_data[bank_data['Exited'] == 0]
bank_exit_1 = bank_data[bank_data['Exited'] == 1]


plt.figure(figsize = (8, 5))

plt.subplot(1, 2, 1)
sns.boxplot(x = 'Exited', y = 'CreditScore', data = bank_exit_1)
plt.title('CreditScore Dist for Exited = 1')

plt.subplot(1, 2, 2)
sns.boxplot(x = 'Exited', y = 'CreditScore', data = bank_exit_0)
plt.title('CreditScore Dist for Exited = 0')

plt.tight_layout()

plt.show()

bank_skew_0 = stats.skew(bank_exit_0['CreditScore'])
bank_skew_1 = stats.skew(bank_exit_1['CreditScore'])

print(f"Skewness for Exited = 1: {bank_skew_1:.2f}")
print(f"Skewness for Exited = 0: {bank_skew_0:.2f}")




# %% 3 - summarise credit score by exited using count and appropriate measure of central tendency
bank_summary_cs = bank_data.groupby('Exited')['CreditScore'].agg(['count', 'mean'])
bank_summary_cs = bank_summary_cs.rename(columns = {'count': 'Count', 'mean': 'Mean'})

bank_summary_cs.round(2)




# %% 4 - obtain cross table of geography versus exited
bank_ct = pd.crosstab(bank_data['Geography'], bank_data['Exited'], margins = True, margins_name = 'Total')
bank_ct = bank_ct.rename(columns = {0: 'Not Exited', 1: 'Exited'})
bank_ct

bank_ct_prop = bank_ct.div(bank_ct['Total'], axis = 0) * 100
bank_ct_prop = bank_ct_prop.rename(columns = {0: 'Not Exited (%)', 1: 'Exited (%)'})
bank_ct_prop.round(2)




# %% 5 - obtain correlation coefficients between credit score and estimated salary
bank_cses_corr = bank_data['CreditScore'].corr(bank_data['EstimatedSalary'])
bank_cses_corr.round(4)
# very weak / no correlation




# %% 6 - derive a new variable Creditscore_Cat 1 if CreditScore >= 65- else 0
bank_data['CreditScore_Cat'] = np.where(bank_data['CreditScore'] >= 650, 1, 0)
bank_data.head()
# bank_data.loc[:, ['CreditScore', 'CreditScore_Cat']].head()



# %% 7 - obtain cross table of CreditScore_Cat versus Exited
bank_ct = pd.crosstab(bank_data['CreditScore_Cat'], bank_data['Exited'], margins = False)
bank_ct.columns = ['Not Exited', 'Exited']

bank_ct_prop = (bank_ct.div(bank_ct.sum(axis = 1), axis = 0) * 100).round(2)
bank_ct_prop.columns = ['Not Exited (%)', 'Exited (%)']

bank_result_ct = pd.concat([bank_ct, bank_ct_prop], axis = 1)
bank_result_ct




# %% 8 - create subset of 500 customers with highest credit score
top_300 = bank_data.sort_values(by = 'CreditScore', ascending = False).head(300)
top_300_geo = pd.crosstab(top_300['Geography'], columns = ['Count'])
top_300_geo




# %% 9 - group data by geography and gender and calculate statistics
bank_data_summary = bank_data.groupby(['Geography', 'Gender'])['CreditScore'].agg(['count', 'mean', 'median'])
bank_data_summary

bank_data_summary = bank_data_summary.reset_index()
bank_data_summary

bank_data_summary = bank_data_summary.rename(columns = {'count': 'Count', 'mean': 'Mean', 'median': 'Median'})
bank_data_summary




# %% 10 - count number of products for each combination of geography
bank_data_pc = bank_data.groupby('Geography')['NumOfProducts'].sum().reset_index()
bank_data_pc

plt.figure(figsize = (6, 5))
sns.barplot(x = 'Geography', y = 'NumOfProducts', data = bank_data_pc)
plt.title('Count of Number of Products by Geography')
plt.xlabel('Geography')
plt.ylabel('Count of Number of Products')
plt.show()










# 11 - some further work
bank_data_pp = bank_data.groupby('Geography')['NumOfProducts'].sum().reset_index()
bank_data_pp['Total Products (%)'] = (bank_data_pp['NumOfProducts'].div(bank_data_pp['NumOfProducts'].sum(), axis = 0) * 100).round(2)
bank_data_pp = bank_data_pp.rename(columns = {'NumOfProducts': 'Total Products'})
bank_data_pp

bank_data_cp = bank_data.groupby('Geography')['NumOfProducts'].count().reset_index()
bank_data_cp['Customer Count (%)'] = (bank_data_cp['NumOfProducts'].div(bank_data_cp['NumOfProducts'].sum(), axis = 0) * 100).round(2)
bank_data_cp = bank_data_cp.rename(columns = {'NumOfProducts': 'Customer Count'})
bank_data_cp

bank_data_agg = bank_data.groupby('Geography')['NumOfProducts'].agg(['mean', 'median']).reset_index()
bank_data_agg = bank_data_agg.rename(columns = {'mean': 'Average Products', 'median': 'Median Products'})
bank_data_agg

# pd.concat([bank_data_pp, bank_data_cp, bank_data_agg], axis = 1)
