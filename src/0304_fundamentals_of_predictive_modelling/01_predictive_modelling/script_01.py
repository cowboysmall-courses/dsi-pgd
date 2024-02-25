
import pandas as pd
import seaborn as sns

from statsmodels.formula.api import ols



# %% 1 - import data and check the head
data = pd.read_csv("./data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance Index.csv")
data.head()
#    empid    jpi  aptitude    tol  technical  general
# 0      1  45.52     43.83  55.92      51.82    43.58
# 1      2  40.10     32.71  32.56      51.49    51.03
# 2      3  50.61     56.64  54.84      52.29    52.47
# 3      4  38.97     51.53  59.69      47.48    47.69
# 4      5  41.87     51.35  51.50      47.59    45.77



# %% 2 - construct a scatter plot matrix
sns.pairplot(data)



# %% 3 - build model
model = ols('jpi ~ aptitude + tol + technical + general', data = data).fit()
model.params
# Intercept   -54.282247
# aptitude      0.323562
# tol           0.033372
# technical     1.095467
# general       0.536834
# dtype: float64
