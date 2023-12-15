
import pandas as pd
import statsmodels.api as sm
import scipy as sp

from statsmodels.formula.api import ols


# %% 1 - import data and check the head
data = pd.read_csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance Index.csv")
data.head()


# %% 2 -
model = ols('jpi ~ aptitude + tol + technical + general', data = data).fit()
model.summary()


# %% 3 -
data = data.assign(pred = pd.Series(model.fittedvalues))
data = data.assign(resi = pd.Series(model.resid))


# %% 4 -
data.plot.scatter(x = 'pred', y = 'resi')


# %% 5 -
fig = sm.graphics.qqplot(data.resi, line = '45', fit = True)


# %% 6 -
sp.stats.shapiro(data.resi)
