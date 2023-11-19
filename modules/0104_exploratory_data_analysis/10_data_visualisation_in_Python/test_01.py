#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct  5 15:50:33 2023

@author: jerry
"""

import plotly.express as px
# import plotly.io as pio

# pio.renderers.default = "browser"


df = px.data.gapminder()


fig = px.scatter(
    df,
    x = "gdpPercap",
    y = "lifeExp",
    animation_frame = "year",
    animation_group = "country",
    size = "pop",
    color = "continent",
    hover_name = "country",
    log_x = True,
    size_max = 55,
    range_x = [100, 100000], range_y=[25, 90]
)
fig.show(renderer = "browser")
