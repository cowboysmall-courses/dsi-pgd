#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Nov 11 10:15:14 2023

@author: jerry
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import statsmodels.api as sm

from statsmodels.stats.diagnostic import lilliefors
from statsmodels.stats.proportion import proportions_ztest
from scipy import stats



cust_data = pd.read_csv("../../../data/si/non_parametric_tests/CUST_PROFILE.csv")

cust_data.head()
cust_data.shape
len(cust_data.CUSTID.unique())
cust_data.info()
cust_data.describe(include = 'all')


nps_data = pd.read_csv("../../../data/si/non_parametric_tests/NPSDATA.csv")

nps_data.head()
nps_data.shape
len(nps_data.CUSTID.unique())
nps_data.info()
nps_data.describe(include = 'all')




merged_data = pd.merge(nps_data, cust_data, on = "CUSTID", how = "left")
merged_data.head()
merged_data.shape
len(merged_data.CUSTID.unique())
merged_data.info()
merged_data.describe(include = 'all')



merged_data.NPS.agg(['mean', 'median']).round(4)



plt.figure()
# plt.boxplot(merged_data.NPS)
merged_data.boxplot(column = 'NPS', grid = False)
plt.title('Box Plot')
plt.suptitle('')



fig = sm.qqplot(merged_data.NPS, line = '45', fit = True)
# qqplot(merged_data.NPS)
stats.shapiro(merged_data.NPS)
# ShapiroResult(statistic=0.9470881223678589, pvalue=0.00032600521808490157)
lilliefors(merged_data.NPS)
# (0.12501168046619382, 0.0009999999999998899)



stats.wilcoxon(merged_data.NPS - 6, correction = True, alternative = 'greater')
# WilcoxonResult(statistic=2166.0, pvalue=0.09808922801666187)



merged_data.groupby('REGION')['NPS'].agg(['mean', 'median']).round(4)



NPS_N = merged_data[merged_data['REGION'] == 'North'].NPS
NPS_S = merged_data[merged_data['REGION'] == 'South'].NPS
NPS_E = merged_data[merged_data['REGION'] == 'East'].NPS
NPS_W = merged_data[merged_data['REGION'] == 'West'].NPS

NPS_N.head()
NPS_S.head()
NPS_E.head()
NPS_W.head()


stats.kruskal(NPS_N, NPS_S, NPS_E, NPS_W)
# KruskalResult(statistic=0.5233555345999821, pvalue=0.913731145150497)

# nps_data = merged_data['NPS']
# regions = merged_data['REGION']
# stats.kruskal(*[nps_data[regions == region] for region in regions.unique()])



table = merged_data.groupby('REGION')['NPS'].median()
table.plot(kind = 'bar', color = 'cadetblue')
plt.xlabel('Region')
plt.ylabel('Median NPS')
plt.title('Median NPS by Region')



merged_data['DETRACTORS'] = np.where(merged_data['NPS'] <= 6, 'YES', 'NO')

table = merged_data.groupby('DETRACTORS')['NPS'].agg(['count']) 
table = table / len(merged_data)
table = table.rename(columns = {'count': 'Percentage'})
table.round(4) * 100
#             Percentage
# DETRACTORS            
# NO               44.86
# YES              55.14



prop_table = merged_data['DETRACTORS'].value_counts(normalize = True)
prop_table
# YES    0.551402
# NO     0.448598
# Name: DETRACTORS, dtype: float6



count_table = pd.value_counts(merged_data['DETRACTORS'])
count_table
# YES    59
# NO     48
# Name: DETRACTORS, dtype: int64



proportions_ztest(count_table.get('YES'), sum(count_table), 0.4, alternative = 'larger')
# (3.148910223112169, 0.000819402663085909)



cont_table = pd.crosstab(merged_data['REGION'], merged_data['DETRACTORS'])
cont_table
# DETRACTORS  NO  YES
# REGION             
# East         7   13
# North       11   13
# South       15   20
# West        15   13



stats.chi2_contingency(cont_table)
# Chi2ContingencyResult(statistic=1.711051839521119, pvalue=0.634479520420212, dof=3, expected_freq=array([[ 8.97196262, 11.02803738],
#        [10.76635514, 13.23364486],
#        [15.70093458, 19.29906542],
#        [12.56074766, 15.43925234]]))
