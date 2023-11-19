#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Oct  2 16:56:50 2023

@author: jerry
"""


import pandas as pd
import numpy as np

from statistics import mean



salary_data = pd.read_csv("../../../data/eda/data_management/basic_salary.csv")
salary_data.head()
salary_data.isnull()
salary_data.isnull().sum()
salary_data.info()


x = [10, 30, 12, np.nan, 9]
mean(x)
np.nanmean(x)


salary_data.dropna()


consumer_data = pd.read_csv("../../../data/eda/data_management/consumerpreference.csv")
consumer_data.isnull().sum()


consumer_data['Processor'].fillna(consumer_data['Processor'].median(), inplace = True)
consumer_data['Processor'].isnull().sum()


cd_ffill = consumer_data.fillna(method = 'ffill')
cd_ffill.head(10)


cd_bfill = consumer_data.fillna(method = 'bfill')
cd_bfill.head(10)
