#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov 12 14:55:57 2023

@author: jerry

 BACKGROUND:
   In a randomized control trial, 32 patients were divided into
   two groups: A and B. Group A received test drug whereas group
   B received placebo. The variable of interest was 'Change in
   pain level' measured by visual analogue scale (VAS) before
   treatment and after 3 days of treatment.

"""

import pandas as pd
import statsmodels.api as sm
import matplotlib.pyplot as plt
import seaborn as sns

from scipy import stats




# 1 - Import VAS DATA and name it as pain_vas. Check for normality of the data.
data = pd.read_csv("../../../data/si/assignment/VAS DATA.csv")

data.head()
data.info()
data.describe(include = 'all')



fig = sm.qqplot(data.VAS_before, line = '45', fit = True)

stats.shapiro(data.VAS_before)

# ShapiroResult(statistic=0.9794087409973145, pvalue=0.7822298407554626)

sm.stats.diagnostic.lilliefors(data.VAS_before)

# (0.07235615314781019, 0.9431115681520438)



fig = sm.qqplot(data.VAS_after, line = '45', fit = True)

stats.shapiro(data.VAS_after)

# ShapiroResult(statistic=0.9104496240615845, pvalue=0.011548812501132488)

sm.stats.diagnostic.lilliefors(data.VAS_after)

# (0.14681083293269181, 0.0782606763533638)



# there is some ambiguity - the Shapiro-Wilk test and the
# Kolmogorov-Smirnov do not agree for the VAS_after data 
# - the latter is usually appropriate for large samples so 
# I would tend to believe that the former result is more 
# reliable. Does this mean that we should not proceed? Or 
# can we proceed because the data is normal at the 0.01 
# level of significance?




# 2 - Is post treatment VAS score significantly less as
#     compared to ‘before treatment’ VAS score for Group A?
data_A = data[data['Group'] == 'A']

stats.ttest_rel(data_A.VAS_before, data_A.VAS_after, alternative = 'greater')

# TtestResult(statistic=12.020636761607365, pvalue=2.111193574879611e-09, df=15)

# as p-value < 0.05, we reject the null hypothesis
# that, for group A, the VAS scores are the same
# before and after treatment




# 3 - Is post treatment VAS score significantly less as
#     compared to ‘before treatment’ VAS score for Group B?
data_B = data[data['Group'] == 'B']

stats.ttest_rel(data_B.VAS_before, data_B.VAS_after, alternative = 'greater')

# TtestResult(statistic=2.425215564365917, pvalue=0.014194417664315588, df=15)

# as p-value < 0.05, we reject the null hypothesis 
# that, for group B, the VAS scores are the same 
# before and after treatment (in this case a placebo)




# 4 - Is the average change in pain level for group 
#     ‘A’ significantly more than group ‘B’? 
data['Delta'] = data.VAS_before - data.VAS_after

data_A = data[data['Group'] == 'A']
data_B = data[data['Group'] == 'B']

stats.ttest_ind(data_A['Delta'], data_B['Delta'], nan_policy = 'omit', equal_var = False, alternative = 'greater')

# TtestResult(statistic=11.120642756667216, pvalue=1.90301603209263e-09, df=16.7283983596526)

# as p-value < 0.05, we reject the null hypothesis 
# that the average change in pain scores are the same 
# across the groups




# 5 - Present change in pain level for each group 
#     using box-whisker plot.
plt.figure(figsize = (8, 6))

sns.set_style("darkgrid")
sns.set_context("paper")

sns.boxplot(x = 'Group', y = 'Delta', data = data)

plt.xlabel('Group')
plt.ylabel('Change in Pain Level')
plt.title('Box Plot')

plt.show()
