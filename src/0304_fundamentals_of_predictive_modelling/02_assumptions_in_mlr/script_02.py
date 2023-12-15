
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

from patsy import dmatrices
from statsmodels.formula.api import ols
from statsmodels.stats.outliers_influence import variance_inflation_factor


# %% 1 - import data and check the head
data = pd.read_csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/ridge regression data.csv")
data.head()


# %% 2 -
sns.pairplot(data[['MODEL', 'RESALE PRICE', 'ENGINE SIZE', 'HORSEPOWER', 'YEARS']])
plt.title('Scatter Plot Matrix')


# %% 3 -
data.columns = [c.replace(' ', '_') for c in data.columns]
model = ols('RESALE_PRICE ~ ENGINE_SIZE + HORSE_POWER + WEIGHT + YEARS', data = data).fit()
model.summary()


# %% 5 -
y, X = dmatrices('RESALE_PRICE ~ ENGINE_SIZE + HORSE_POWER + WEIGHT + YEARS', data = data, return_type = "dataframe")
pd.Series([variance_inflation_factor(X.values, i) for i in range(X.shape[1])], index = X.columns)
