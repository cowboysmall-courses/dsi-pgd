
import pandas as pd

from statsmodels.formula.api import ols



# %% 1 - import data and check the head
data = pd.read_csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/RESTAURANT SALES DATA.csv")
data.head()
data.info()


# %% 2 - convert LOCATION to category
data['LOCATION'] = data['LOCATION'].astype('category')
data['LOCATION'].cat.categories


# %% 3 -fit the model
model = ols('SALES ~ NOH + LOCATION', data = data).fit()
model.summary()


# %% 4 -fir the model withreordered levels
model = ols("SALES ~ NOH + C(LOCATION, Treatment(reference = 'mall'))", data = data).fit()
model.summary()
