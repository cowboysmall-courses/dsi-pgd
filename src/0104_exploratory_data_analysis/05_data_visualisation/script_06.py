#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct  5 14:36:10 2023

@author: jerry
"""


# %%

import pandas as pd
import plotly.express as px



# %%

sales_data = pd.read_csv("./data/0104_exploratory_data_analysis/data_visualisation/Sales Data (Motion Chart).csv")
sales_data.info()
sales_data.describe(include = 'all')



# %%

fig = px.scatter(
    sales_data,
    x = "Penetration",
    y = "Sales",
    animation_frame = "Year",
    animation_group = "Region",
    size = "Sales",
    color = "Region",
    hover_name = "Region",
    log_x = True,
    size_max = 50,
    range_x = [700, 2000],
    range_y = [25, 100]
)
fig.show(renderer = "browser")
