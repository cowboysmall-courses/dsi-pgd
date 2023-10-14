#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Oct 14 09:04:02 2023

@author: jerry
"""


import pandas as pd
import numpy as np
import scipy.stats as stats

import matplotlib.pyplot as plt
import seaborn as sns



bank_data = pd.read_csv("../../../data/eda/live_class/Bank_Churn.csv")

bank_data.info()
bank_data.shape

bank_data.head()
bank_data.tail()

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


bank_summary_cs = bank_data.groupby('Exited')['CreditScore'].agg(['count', 'mean'])
bank_summary_cs = bank_summary_cs.rename(columns = {'count': 'Count', 'mean': 'Mean'})

bank_summary_cs.round(2)


bank_ct = pd.crosstab(bank_data['Geography'], bank_data['Exited'], margins = True, margins_name = 'Total')
bank_ct

bank_ct_prop = bank_ct.div(bank_ct['Total'], axis = 0) * 100
bank_ct_prop.round(2)

bank_ct = bank_ct.rename(columns = {0: 'Not Exited', 1: 'Exited'})
bank_ct

bank_ct_prop = bank_ct_prop.rename(columns = {0: 'Not Exited (%)', 1: 'Exited (%)'})
bank_ct_prop.round(2)


bank_cses_corr = bank_data['CreditScore'].corr(bank_data['EstimatedSalary'])
bank_cses_corr.round(4)
# very weak / no correlation
