#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov 12 14:57:00 2023

@author: jerry

 BACKGROUND:
   In a randomized control trial, 32 patients were divided
   into two groups: A and B. Group A received test drug
   whereas group B received placebo. The variable of
   interest was Numerical Pain Rating Scale (NPRS) before
   treatment and after 3 days of treatment. (Higher number
   indicates more pain)

"""


# %% 0 - Import libraries.

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from scipy import stats




# %% 1 - Import NPRS DATA and name it as pain_nprs. Find
#     median NPRS before and after treatment.
data = pd.read_csv("./data/0204_statistical_inference/04_assignment/NPRS DATA.csv")

data.head()
data.info()
data.describe(include = 'all')

data.NPRS_before.median()
# 7

data.NPRS_after.median()
# 5




# %% 2 - Is post treatment NPRS score significantly less
#     as compared to 'before treatment' NPRS score for
#     Group A?
data_A = data[data['Group'] == 'A']

stats.wilcoxon(data_A.NPRS_before, data_A.NPRS_after, correction = True, alternative = 'greater')
# WilcoxonResult(statistic=105.0, pvalue=0.0004507025578743344)

# as the p-value < 0.05 we reject the null hypothesis
# that post treatment NPRS score is the same as before
# treatment NPRS score for Group A




# %% 3 - Is post treatment NPRS score significantly less
#     as compared to 'before treatment' NPRS score for
#     Group B?
data_B = data[data['Group'] == 'B']

stats.wilcoxon(data_B.NPRS_before, data_B.NPRS_after, correction = True, alternative = 'greater')
# WilcoxonResult(statistic=120.0, pvalue=0.00030791032810110303)

# as the p-value < 0.05 we reject the null hypothesis
# that post treatment NPRS score is the same as before
# treatment NPRS score for Group B




# %% 4 - Is the change in NPRS for Group A significantly
#     different than Group B?
data['Delta'] = data.NPRS_before - data.NPRS_after
data.head()

data_A = data[data['Group'] == 'A']
data_B = data[data['Group'] == 'B']

stats.ranksums(data_A['Delta'], data_B['Delta'])
# RanksumsResult(statistic=-0.8480006566249602, pvalue=0.3964376050481627)

# as the p-value > 0.05 we fail to reject the null
# hypothesis that the difference in NPRS score is
# the same across Groups




# %% 5 - Present change in NPRS for each group using
#     box-whisker plot.
plt.figure(figsize = (8, 6))

sns.set_style("darkgrid")
sns.set_context("paper")

sns.boxplot(x = 'Group', y = 'Delta', data = data)

plt.xlabel('Group')
plt.ylabel('Change in NPRS')
plt.title('Box Plot')

plt.show()
