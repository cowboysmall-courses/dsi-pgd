#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct  3 10:01:38 2023

@author: jerry
"""


import pandas as pd

retail_data = pd.read_csv("../../../data/descriptive_statistics/Retail_Data.csv")
retail_data.describe(include = 'all')


# import matplotlib.pyplot as plt

retail_data.Perindex.plot.box(label = 'No. of Calls', title = 'Box Plot (Perindex)', ylabel = 'Perindex')
retail_data.Growth.plot.box(label = 'No. of Calls', title = 'Box Plot (Growth)', ylabel = 'Growth')



retail_data.Perindex.mean()
retail_data.Growth.mean()

retail_data.Perindex.median()
retail_data.Growth.median()


from scipy import stats

stats.trim_mean(retail_data.Perindex, 0.1)
stats.trim_mean(retail_data.Growth, 0.1)


retail_data.Perindex.mode()
retail_data.Zone.value_counts()


retail_data.Perindex.std()
retail_data.Perindex.var()
retail_data.Perindex.std() / retail_data.Perindex.mean()


retail_data.Growth.skew()
retail_data.Growth.kurtosis()
