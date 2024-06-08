
# %% 0 - import libraries
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import re

import nltk
# nltk.download('vader_lexicon')

from nltk.sentiment.vader import SentimentIntensityAnalyzer
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize

from wordcloud import WordCloud



# %% 1 - import data and check the head
data = pd.read_csv("./data/0904_text_mining_and_nlp/05_case_study/reviews_data.csv")
data.head()
#        name           location            Date  Rating  \
# 0     Helen  Wichita Falls, TX   Sept 13, 2023       5   
# 1  Courtney         Apopka, FL   July 16, 2023       5   
# 2  Daynelle  Cranberry Twp, PA    July 5, 2023       5   
# 3    Taylor        Seattle, WA    May 26, 2023       5   
# 4   Tenessa        Gresham, OR    Jan 22, 2023       5   

#                                               Review  
# 0  Amber and LaDonna at the Starbucks on Southwes...  
# 1  ** at the Starbucks by the fire station on 436...  
# 2  I just wanted to go out of my way to recognize...  
# 3  Me and my friend were at Starbucks and my card...  
# 4  I’m on this kick of drinking 5 cups of warm wa...  



# %% 1 - 
data.info()
# <class 'pandas.core.frame.DataFrame'>
# RangeIndex: 812 entries, 0 to 811
# Data columns (total 5 columns):
#  #   Column    Non-Null Count  Dtype 
# ---  ------    --------------  ----- 
#  0   name      812 non-null    object
#  1   location  812 non-null    object
#  2   Date      812 non-null    object
#  3   Rating    812 non-null    int64 
#  4   Review    812 non-null    object
# dtypes: int64(1), object(4)
# memory usage: 31.8+ KB



# %% 1 - 
def preprocess_text(text):
    swords = set(stopwords.words("english")) | set(["drink", "drinks", "starbucks", "coffee"])

    tokens = word_tokenize(re.sub(r"[^a-zA-Z\s]", "", text.lower()))
    tokens = [word for word in tokens if word not in swords]

    return " ".join(tokens)



# %% 1 - 
data["Cleaned_Review"] = data["Review"].apply(preprocess_text)
data["Cleaned_Review"].head()
# 0    amber ladonna southwest parkway always warm we...
# 1    fire station altamonte springs fl made day fin...
# 2    wanted go way recognize employee billy frankli...
# 3    friend card didnt work thankful worker paid ni...
# 4    im kick drinking cups warm water work instacar...
# Name: CLeaned_Review, dtype: object



# %% 1 - 
data["Review"][0]
# 'Amber and LaDonna at the Starbucks on Southwest Parkway are always so warm and welcoming. There is always a smile in their voice when they greet you at the drive-thru. And their customer service is always spot-on, they always get my order right and with a smile. I would actually give them more than 5 stars if they were available.'



# %% 1 - 
data["Cleaned_Review"][0]
# 'amber ladonna southwest parkway always warm welcoming always smile voice greet drivethru customer service always spoton always get order right smile would actually give stars available'



# %% 1 - 
def create_wordcloud(text):
    wordcloud = WordCloud(width = 800, height = 400, background_color = "white").generate(text)
    plt.figure(figsize = (10, 5))
    plt.imshow(wordcloud, interpolation = "bilinear")
    plt.axis("off")
    plt.show()



# %% 1 - 
data_wc = data.copy()

positive_reviews = data_wc[data_wc["Rating"] > 3]["Cleaned_Review"].str.cat(sep = " ")
negative_reviews = data_wc[data_wc["Rating"] < 3]["Cleaned_Review"].str.cat(sep = " ")



# %% 1 - 
print("Word Cloud for Positive Reviews")
create_wordcloud(positive_reviews)


# %% 1 - 
print("Word Cloud for Negative Reviews")
create_wordcloud(negative_reviews)



# %% 1 - 
sid = SentimentIntensityAnalyzer()



# %% 1 - 
data["Sentiment_Scores"] = data["Cleaned_Review"].apply(lambda x: sid.polarity_scores(x))
data["Sentiment_Scores"].head()
# 0    {'neg': 0.0, 'neu': 0.634, 'pos': 0.366, 'comp...
# 1    {'neg': 0.085, 'neu': 0.547, 'pos': 0.368, 'co...
# 2    {'neg': 0.15, 'neu': 0.614, 'pos': 0.236, 'com...
# 3    {'neg': 0.157, 'neu': 0.436, 'pos': 0.406, 'co...
# 4    {'neg': 0.046, 'neu': 0.462, 'pos': 0.492, 'co...
# Name: Sentiment_Scores, dtype: object


# %% 1 - 
data["Positive_Score"] = data["Sentiment_Scores"].apply(lambda x: x["pos"])
data["Negative_Score"] = data["Sentiment_Scores"].apply(lambda x: x["neg"])
data["Neutral_Score"]  = data["Sentiment_Scores"].apply(lambda x: x["neu"])
data["Compound_Score"] = data["Sentiment_Scores"].apply(lambda x: x["compound"])
data.head()
#    Positive_Score  Negative_Score  Neutral_Score  Compound_Score
# 0           0.366           0.000          0.634          0.8779
# 1           0.368           0.085          0.547          0.9670
# 2           0.236           0.150          0.614          0.4215
# 3           0.406           0.157          0.436          0.9028
# 4           0.492           0.046          0.462          0.9723



# %% 1 - 
data_sent = data.copy()

mean_positive_score = data_sent.groupby("Rating")["Positive_Score"].mean().reset_index()
mean_negative_score = data_sent.groupby("Rating")["Negative_Score"].mean().reset_index()



# %% 1 - 
plt.figure(figsize = (10, 6))

sns.lineplot(x = "Rating", y = "Positive_Score", data = mean_positive_score, label = "Mean Positive Score", marker = 'o')
sns.lineplot(x = "Rating", y = "Negative_Score", data = mean_negative_score, label = "Mean Negative Score", marker = 'o')

plt.title("Mean Positive and Negative Scores by Rating")
plt.xlabel("Rating")
plt.ylabel("Mean Score")

plt.legend()
plt.show()



# %% 1 - 
data["Year"] = data["Date"].str.split(", ").str[-1]
data["Year"] = pd.to_numeric(data["Year"], errors = "coerce", downcast = "integer")



# %% 1 - 
recent = data[data["Year"] > 2018]

mean_scores_by_year = recent.groupby("Year")["Compound_Score"].mean().reset_index()



# %% 1 - 
plt.figure(figsize=(10, 6))

sns.barplot(x = "Year", y = "Compound_Score", data = mean_scores_by_year, palette = "viridis")

plt.title("Mean Compound Score by Year (Year > 2018)")
plt.xlabel("Year")
plt.ylabel("Compound Score")

plt.show()
