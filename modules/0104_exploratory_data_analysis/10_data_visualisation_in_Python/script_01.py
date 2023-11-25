#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct  5 11:11:28 2023

@author: jerry
"""


# %%

import pandas as pd
import matplotlib.pyplot as plt



# %%

telecom_data = pd.read_csv("../../../data/0104_exploratory_data_analysis/data_visualisation/telecom.csv")
telecom_data.info()



# %%

telecom_01 = telecom_data.groupby('Age_Group')['Calls'].sum()
telecom_01

plt.figure()
telecom_01.plot.bar(title = 'Total Calls - Age Group', color = 'darkorange')
plt.xlabel('Age Groups')
plt.ylabel('Total Calls')



# %%

telecom_02 = telecom_data.groupby('Age_Group')['Calls'].mean()
telecom_02

plt.figure()
telecom_02.plot.bar(title = 'Mean Calls - Age Group', color = 'darkorange')
plt.xlabel('Age Groups')
plt.ylabel('Mean Calls')



# %%

telecom_03 = telecom_data.groupby('Age_Group')['CustID'].count()
telecom_03

plt.figure()
telecom_03.plot.barh(title = 'No. of Customers - Age Group (Horizontal)', color = 'darkorange')
plt.xlabel('Age Groups')
plt.ylabel('No. of Customers')



# %%

telecom_04 = pd.pivot_table(telecom_data, index = ['Age_Group'], columns = ['Gender'], values = ['CustID'], aggfunc = 'count')
telecom_04

plt.figure()
telecom_04.plot.bar(title = 'No. of Customers - Age Group (Stacked)', stacked = True)
plt.xlabel('Age Groups')
plt.ylabel('No. of Customers')



# %%

telecom_05 = telecom_04.div(telecom_04.sum(1).astype(float), axis = 0).round(2) * 100
telecom_05

plt.figure()
telecom_05.plot.bar(title = '% Customers - Age Group (Stacked)', stacked = True)
plt.xlabel('Age Groups')
plt.ylabel('% Customers')



# %%

telecom_06 = pd.pivot_table(telecom_data, index = ['Age_Group'], columns = ['Gender'], values = ['Calls'], aggfunc = 'sum')
telecom_06

plt.figure()
telecom_06.plot.bar(title = 'Total Calls - Gender + Age Group')
plt.xlabel('Age Groups')
plt.ylabel('Total Calls')



# %%

telecom_07 = telecom_data.groupby('Age_Group')['Calls'].sum()
telecom_07 = telecom_07.div(telecom_07.sum().astype(float)).round(2) * 100
telecom_07

plt.figure()
telecom_07.plot.pie(label = ('Age Groups'), title = 'Calls - Age Group', colormap = 'brg', autopct = '%1.0f%%')



# %%

telecom_08 = pd.pivot_table(telecom_data, index = ['Age_Group'], columns = ['Gender'], values = ['CustID'], aggfunc = 'count')
telecom_08

plt.figure()
telecom_08.plot.pie(label = ('Age Groups'), title = 'Calls - Age Group', colors = ['darkcyan', 'orange', 'yellowgreen'], autopct = '%.1f%%', subplots = True)
