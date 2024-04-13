
# %% 0 - import libraries
import yfinance as yf

from statsmodels.tsa.stattools import coint


# %% 1 - retrieve data
data = yf.download(["WIPRO.NS", "INFY.NS"], start = "2022-01-01", end = "2022-12-31")


# %% 2 - 
adj_close = data["Adj Close"]
adj_close.columns = ["INFY", "WIPRO"]


# %% 3 - 
coint(adj_close.INFY, adj_close.WIPRO)
# (-2.1544244058600848, 0.4479750255969704, array([-3.94132922, -3.36097908, -3.06166543]))
