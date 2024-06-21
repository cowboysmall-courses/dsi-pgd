
# BACKGROUND: 
# 
# The given data contain short and crisp movie reviews by various critics.
# 
# QUESTIONS:
# 
#   1. Import Textdata. Do the essential cleaning of the data.
#   2. Find top 20 words sorted by frequency.
#   3. Create a wordcloud using the given data.
#   4. List the number of lines having sentiments ‘Negative', 'Neutral’ and ‘Positive’.
#   5. Plot bar graph showing top 15 words by frequency.





# %% 0 - import libraries
import pandas as pd
import matplotlib.pyplot as plt
import nltk

from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
from nltk.sentiment.vader import SentimentIntensityAnalyzer

from wordcloud import WordCloud

from string import punctuation, digits










# 1. Import Textdata. Do the essential cleaning of the data.

# %% 1 - read data line by line...
with open("./data/0904_text_mining_and_nlp/04_assignment/Textdata.txt") as file:
    lines = [line.strip() for line in file]



# %% 1 - create data frame from lines...
data = pd.DataFrame(lines, columns= ["Review"])
data.head()
#                                               Review
# 0  films adapted from comic books have had plenty...
# 1  for starters , it was created by alan moore ( ...
# 2  to say moore and campbell thoroughly researche...
# 3  the book ( or " graphic novel , " if you will ...
# 4  in other words , don't dismiss this film becau...



# %% 1 - create function to clean the data...
stop_words    = set(stopwords.words('english'))
remove_punc   = str.maketrans('', '', punctuation)
remove_digits = str.maketrans('', '', digits)

def preprocess(line):
    line = line.lower()
    line = line.translate(remove_punc)
    line = line.translate(remove_digits)
    line = " ".join([word for word in word_tokenize(line) if word not in stop_words])
    return " ".join(line.strip().split())



# %% 1 - clean the data and assign it to column...
data["Cleaned_Review"] = data["Review"].apply(preprocess)
data.head()
#                                               Review  \
# 0  films adapted from comic books have had plenty...   
# 1  for starters , it was created by alan moore ( ...   
# 2  to say moore and campbell thoroughly researche...   
# 3  the book ( or " graphic novel , " if you will ...   
# 4  in other words , don't dismiss this film becau...   

#                                       Cleaned_Review  
# 0  films adapted comic books plenty success wheth...  
# 1  starters created alan moore eddie campbell bro...  
# 2  say moore campbell thoroughly researched subje...  
# 3  book graphic novel pages long includes nearly ...  
# 4                     words dont dismiss film source  



# %% 1 - aggregate all words into a single string - to be used later...
words = data["Cleaned_Review"].str.cat(sep = " ")










# 2. Find top 20 words sorted by frequency.

# %% 1 - create frequency distribution object and find 20 most common words...
freq_dist = nltk.FreqDist(word_tokenize(words))
freq_dist.most_common(20)
# [('film', 10),
#  ('like', 7),
#  ('dont', 7),
#  ('make', 7),
#  ('even', 6),
#  ('movie', 6),
#  ('comic', 5),
#  ('get', 5),
#  ('pretty', 5),
#  ('films', 4),
#  ('world', 4),
#  ('really', 4),
#  ('say', 4),
#  ('little', 4),
#  ('good', 4),
#  ('see', 4),
#  ('one', 4),
#  ('teen', 4),
#  ('book', 3),
#  ('moore', 3)]










# 3. Create a wordcloud using the given data.

# %% 1 - create wordcloud from words...
wordcloud = WordCloud(width = 800, height = 400, background_color = "white").generate(words)



# %% 1 - plot the wordcloud...
plt.figure(figsize = (10, 5))
plt.imshow(wordcloud, interpolation = "bilinear")
plt.axis("off")
plt.show()










# 4. List the number of lines having sentiments ‘Negative', 'Neutral’ and ‘Positive’.

# %% 1 - create instance of sentiment intensity analyzer...
sid = SentimentIntensityAnalyzer()



# %% 1 - get sentiment scores...
data["Sentiment_Scores"] = data["Cleaned_Review"].apply(lambda x: sid.polarity_scores(x))
data.iloc[:, 2].head()
# 0    {'neg': 0.19, 'neu': 0.632, 'pos': 0.178, 'com...
# 1    {'neg': 0.0, 'neu': 0.882, 'pos': 0.118, 'comp...
# 2    {'neg': 0.103, 'neu': 0.769, 'pos': 0.128, 'co...
# 3    {'neg': 0.0, 'neu': 0.796, 'pos': 0.204, 'comp...
# 4    {'neg': 0.0, 'neu': 1.0, 'pos': 0.0, 'compound...
# Name: Sentiment_Scores, dtype: object



# %% 1 - retrieve individual sentiment scores (we use compound scores)...
data["Positive_Score"] = data["Sentiment_Scores"].apply(lambda x: x["pos"])
data["Negative_Score"] = data["Sentiment_Scores"].apply(lambda x: x["neg"])
data["Neutral_Score"]  = data["Sentiment_Scores"].apply(lambda x: x["neu"])
data["Compound_Score"] = data["Sentiment_Scores"].apply(lambda x: x["compound"])
data.iloc[:, 3:].head()
#    Positive_Score  Negative_Score  Neutral_Score  Compound_Score
# 0           0.178           0.190          0.632         -0.1119
# 1           0.118           0.000          0.882          0.2500
# 2           0.128           0.103          0.769          0.1263
# 3           0.204           0.000          0.796          0.3182
# 4           0.000           0.000          1.000          0.0000



# %% 1 - lines wirth sentiment 'Negative' ...
data[(data["Compound_Score"] < 0)].shape[0]
# 21



# %% 1 - lines wirth sentiment 'Neutral' ...
data[(data["Compound_Score"] == 0)].shape[0]
# 19



# %% 1 - lines wirth sentiment 'Positive' ...
data[(data["Compound_Score"] > 0)].shape[0]
# 21










# 5. Plot bar graph showing top 15 words by frequency.

# %% 1 - create data frame with top 15 words, and their frequencies...
word_freq = pd.DataFrame(freq_dist.most_common(15), columns=["Word", "Freq"])
word_freq = word_freq.sort_values("Freq", ascending = True).reset_index(drop = True)



# %% 1 - plot bar chart of 15 words by their frequencies...
plt.figure(figsize = (16, 8))

plt.barh(word_freq.Word, word_freq.Freq, color = "cadetblue")

plt.title("Top 15 Words by Frequency")
plt.ylabel("Word")
plt.xlabel("Freq")

plt.show()
