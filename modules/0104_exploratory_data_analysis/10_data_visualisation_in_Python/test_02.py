#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Oct  6 15:54:17 2023

@author: jerry
"""


# %%

import numpy as np
import pandas as pd
import seaborn as sns



# %%

telecom_data = pd.read_csv("../../../data/0104_exploratory_data_analysis/data_visualisation/telecom.csv")



# %%

sns.set_theme(style="whitegrid")

g = sns.catplot(
    data = telecom_data,
    kind = "bar",
    x = "Age_Group",
    y = "Calls",
    hue = "Gender",
    # errorbar = "sd",
    palette = "dark",
    alpha = .6,
    height = 6
)
g.despine(left = True)
g.set_axis_labels("Age Groups", "Calls")
g.legend.set_title("")



# %%

sns.set_theme()

x = np.random.normal(0, 1, 50)
y = x * 2 + np.random.normal(0, 2, size=x.size)
sns.regplot(x=x, y=y)
