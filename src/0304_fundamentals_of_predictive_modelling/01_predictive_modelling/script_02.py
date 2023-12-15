
import numpy as np
import pandas as pd
import seaborn as sns

from scipy import stats
from statsmodels.formula.api import ols



# %% 1 - import data and check the head
data = pd.read_csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance Index.csv")
data.head()



# %% 2 - construct a scatter plot matrix
sns.pairplot(data)



# %% 3 - build model
model = ols('jpi ~ aptitude + tol + technical + general', data = data).fit()
model.params



# %% 4 - model summary
model.summary()



# %% 5 - rebuild model omitting tol
model = ols('jpi ~ aptitude + technical + general', data = data).fit()
model.params



# %% 6 - new model summary
model.summary()



# %% 7 - add fitted and residuals
data = data.assign(pred = pd.Series(model.fittedvalues))
data = data.assign(resi = pd.Series(model.resid))
data.head()



# %% 8 - predictions for new data set
pred = pd.read_csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance Index new.csv")
pred = pred.assign(pred = pd.Series(model.predict(pred)))
pred = pred.assign(resi = pd.Series(pred.jpi - pred.pred))
pred.head()



# %% 9 - predictions with 95% confidence interval
result = model.get_prediction(pred)
result.conf_int()



# %% 10 - standardize the data
z = data.select_dtypes(include=[np.number]).dropna().apply(stats.zscore)



# %% 11 - rebuild model with standardized data
std = ols('jpi ~ aptitude + technical + general', data = z).fit()
std.params
