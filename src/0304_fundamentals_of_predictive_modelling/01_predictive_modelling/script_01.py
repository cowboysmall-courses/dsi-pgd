
import pandas as pd
import seaborn as sns

from statsmodels.formula.api import ols



# %% 1 - import data and check the head
data = pd.read_csv("../../../data/0304_fundamentals_of_predictive_modelling/predictive_modelling/Performance Index.csv")
data.head()



# %% 2 - construct a scatter plot matrix
sns.pairplot(data)



# %% 3 - build model
model = ols('jpi ~ aptitude + tol + technical + general', data = data).fit()
model.params
