
import pandas as pd

from statsmodels.formula.api import ols
from statsmodels.graphics.regressionplots import influence_plot


# %% 1 - import data and check the head
data = pd.read_csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance Index.csv")
data.head()


# %% 2 -
model = ols('jpi ~ aptitude + tol + technical + general', data = data).fit()
model.summary()


# %% 3 -
influence = model.get_influence()
influence.summary_frame()


# %% 4 -
influence_plot(model, criterion = 'Cooks')
