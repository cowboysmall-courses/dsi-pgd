#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Nov 25 09:06:46 2023

@author: jerry
"""

# %% import libraries

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import statsmodels.api as sm
import seaborn as sns

from statsmodels.formula.api import ols
from statsmodels.stats.diagnostic import lilliefors
from scipy import stats





# %% 1 - import data and check first 5 rows

data = pd.read_csv("./data/0204_statistical_inference/00_live_class/Food Delivery App Survey Data.csv")
data.head(n = 5)
#    CUSTID    AGE GENDER  Q1  Q2  Q3
# 0       1   <=30   Male   7   9   6
# 1       2   <=30   Male   3   6   7
# 2       3  30-50   Male   7   6   5
# 3       4    >50   Male   7   9   8
# 4       5   <=30   Male   8   9   7




# %% 2 - find median rating for each parameter for AGE

data.groupby('AGE')[['Q1', 'Q2', 'Q3']].agg('median')
#         Q1   Q2   Q3
# AGE
# 30-50  5.0  6.0  5.0
# <=30   6.0  6.0  6.0
# >50    6.0  6.0  5.0

# %%

data.groupby('AGE')[['Q1', 'Q2', 'Q3']].median()
#         Q1   Q2   Q3
# AGE
# 30-50  5.0  6.0  5.0
# <=30   6.0  6.0  6.0
# >50    6.0  6.0  5.0





# %% 3 - calculate total score as sum of the 3 parameter ratings

data['TOTAL_SCORE'] = data.Q1 + data.Q2 + data.Q3
data.head()
#    CUSTID    AGE GENDER  Q1  Q2  Q3  TOTAL_SCORE
# 0       1   <=30   Male   7   9   6           22
# 1       2   <=30   Male   3   6   7           16
# 2       3  30-50   Male   7   6   5           18
# 3       4    >50   Male   7   9   8           24
# 4       5   <=30   Male   8   9   7           24




# %% 4 - obtain box-whisker plot for total score

plt.figure(figsize = (8, 6))

sns.set_style("darkgrid")
sns.set_context("paper")
sns.boxplot(y = 'TOTAL_SCORE', data = data, width = 0.15, fill = False)
plt.xlabel(' ')
plt.ylabel('Total Score')
plt.title('Box Plot')
plt.show()





# %% 5 - can total score be assumed to be normal? use statistical test

fig = sm.qqplot(data.TOTAL_SCORE, line = '45', fit = True)

# %%

stats.shapiro(data.TOTAL_SCORE)
# ShapiroResult(statistic=0.9740760922431946, pvalue=0.23897004127502441)

# %%

lilliefors(data.TOTAL_SCORE)
# (0.09533948973755785, 0.23383750055940083)





# %% 6 - 6 - compare the total score for three age groups using statistical tests

data.groupby('AGE')[['TOTAL_SCORE']].agg(lambda x: stats.shapiro(x).pvalue)
#        TOTAL_SCORE
# AGE
# 30-50     0.779106
# <=30      0.404519
# >50       0.746498

# %%

data.groupby('AGE')[['TOTAL_SCORE']].agg(lambda x: lilliefors(x)[1])
#        TOTAL_SCORE
# AGE
# 30-50     0.092577
# <=30      0.293475
# >50       0.624895

# %%

model = ols('TOTAL_SCORE ~ C(AGE)', data = data).fit()
sm.stats.anova_lm(model, type = 2)
#             df      sum_sq    mean_sq         F    PR(>F)
# C(AGE)     2.0    2.076197   1.038099  0.078653  0.924462
# Residual  56.0  739.110244  13.198397       NaN       NaN





# %% 7 - compare the total score for male and female using statistical tests

data.groupby('GENDER')[['TOTAL_SCORE']].agg(lambda x: stats.shapiro(x).pvalue)
#         TOTAL_SCORE
# GENDER
# Female     0.500238
# Male       0.173646

# %%

data.groupby('GENDER')[['TOTAL_SCORE']].agg(lambda x: lilliefors(x)[1])
#         TOTAL_SCORE
# GENDER
# Female     0.399971
# Male       0.616717

# %%

data_m = data[data.GENDER == 'Male']['TOTAL_SCORE']
data_f = data[data.GENDER == 'Female']['TOTAL_SCORE']

stats.ttest_ind(data_m, data_f, nan_policy = 'omit', equal_var = True)
# TtestResult(statistic=3.2193239856235936, pvalue=0.0021225350188049715, df=57.0)

# %%

model = ols('TOTAL_SCORE ~ C(GENDER)', data = data).fit()
sm.stats.anova_lm(model, type = 2)
#              df      sum_sq     mean_sq          F    PR(>F)
# C(GENDER)   1.0  114.032505  114.032505  10.364047  0.002123
# Residual   57.0  627.153935   11.002701        NaN       NaN





# %% 8 - analyze the effect of age group and gender with interaction on total score

model = ols('TOTAL_SCORE ~ C(AGE) + C(GENDER) + C(AGE):C(GENDER)', data = data).fit()
sm.stats.anova_lm(model, type = 2)
#                     df      sum_sq     mean_sq          F    PR(>F)
# C(AGE)             2.0    2.076197    1.038099   0.089759  0.914290
# C(GENDER)          1.0  122.476870  122.476870  10.589913  0.001983
# C(AGE):C(GENDER)   2.0    3.665697    1.832848   0.158476  0.853846
# Residual          53.0  612.967677   11.565428        NaN       NaN

# %%

model = ols('TOTAL_SCORE ~ C(AGE):C(GENDER)', data = data).fit()
sm.stats.anova_lm(model, type = 2)
#                     df      sum_sq    mean_sq         F   PR(>F)
# C(AGE):C(GENDER)   5.0  128.218764  25.643753  2.217277  0.06605
# Residual          53.0  612.967677  11.565428       NaN      NaN





# %% 9 - create indicator variable as satisfied "Yes" if total score > 20, "No" otherwise

data['SATISFIED'] = np.where(data['TOTAL_SCORE'] <= 20, 'No', 'Yes')
data.head()
#    CUSTID    AGE GENDER  Q1  Q2  Q3  TOTAL_SCORE SATISFIED
# 0       1   <=30   Male   7   9   6           22       Yes
# 1       2   <=30   Male   3   6   7           16        No
# 2       3  30-50   Male   7   6   5           18        No
# 3       4    >50   Male   7   9   8           24       Yes
# 4       5   <=30   Male   8   9   7           24       Yes




# %% 10 - find the proportion of satisfied customers

data['SATISFIED'].value_counts(normalize = True)
# No     0.745763
# Yes    0.254237
# Name: SATISFIED, dtype: float64

# %%

(data['SATISFIED'].value_counts(normalize = True) * 100).round(2)
# No     74.58
# Yes    25.42
# Name: SATISFIED, dtype: float64
