
# BACKGROUND: 
# 
# The given data contain short and crisp movie reviews by various critics.
# 
# QUESTIONS:
# 
#   1. Import Textdata. Do the essential cleaning of the data.
#   2. Find words with minimum frequency 6.
#   3. List words with at least 0.35 correlation with ‘film’.
#   4. Create a wordcloud with words having minimum frequency 4. (Use any palette from RColorBrewer)
#   5. List the number of lines having sentiments ‘Sarcasm’, ‘Very Negative’ and ‘Very Positive’.
#   6. Plot graph showing words occurring more than 3 times (Use tidytext package).





# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import nltk

from scipy.stats import pearsonr

from sklearn.feature_extraction.text import CountVectorizer

from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
from nltk.sentiment.vader import SentimentIntensityAnalyzer

from textblob import TextBlob

from wordcloud import WordCloud

from string import punctuation, digits










# 1. Import Textdata. Do the essential cleaning of the data.

# %% 1 - 
with open("./data/0904_text_mining_and_nlp/04_assignment/Textdata.txt") as file:
    lines = [line.strip() for line in file]



# %% 1 - 
data = pd.DataFrame(lines, columns= ["Review"])
data.head()
#                                               Review
# 0  films adapted from comic books have had plenty...
# 1  for starters , it was created by alan moore ( ...
# 2  to say moore and campbell thoroughly researche...
# 3  the book ( or " graphic novel , " if you will ...
# 4  in other words , don't dismiss this film becau...



# %% 1 - 
stop_words    = set(stopwords.words('english'))
remove_punc   = str.maketrans('', '', punctuation)
remove_digits = str.maketrans('', '', digits)

def preprocess(line):
    line = line.lower()
    line = line.translate(remove_punc)
    line = line.translate(remove_digits)
    line = " ".join([word for word in word_tokenize(line) if word not in stop_words])
    return " ".join(line.strip().split())



# %% 1 - 
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










# 2. Find words with minimum frequency 6.

# %% 1 - 
freq_dist = nltk.FreqDist(word_tokenize(data["Cleaned_Review"].str.cat(sep = " ")))



# %% 1 - 
word_freq = pd.DataFrame(freq_dist.items(), columns=["Word", "Freq"])
print(word_freq[word_freq.Freq >= 6].sort_values("Freq", ascending = False).reset_index(drop = True))
#     Word  Freq
# 0   film    10
# 1   like     7
# 2   dont     7
# 3   make     7
# 4   even     6
# 5  movie     6










# 3. List words with at least 0.35 correlation with ‘film’.

# %% 1 - 
def find_assocs(tdm, idx, min_correlation):
    found = []

    for row in range(tdm.shape[0]):
        if row != idx:
            cor, _ = pearsonr(tdm[idx], tdm[row])
            if cor >= min_correlation:
                found.append((row, round(cor, 2)))

    return found



# %% 1 - 
def create_tdm(sentences, words):
    lines = sentences.apply(lambda sentence: word_tokenize(sentence))
    rows  = len(words)
    cols  = len(lines)

    tdm = np.zeros((rows, cols))

    for word in range(rows):
        for line in range(cols):
            tdm[word, line] += lines[line].count(words[word])

    return tdm



# %% 1 - 
words = sorted(list(set(word_tokenize(data["Cleaned_Review"].str.cat(sep = " ")))))
tdm   = create_tdm(data["Cleaned_Review"], words)



# %% 1 - 
found = sorted(find_assocs(tdm, words.index("film"), 0.35), key = lambda x: (-x[1], x[0]))
print("\n".join([f"{words[f[0]]:>12} -> {f[1]}" for f in found]))
#      biggest -> 0.42



# %% 1 - 
found = sorted(find_assocs(tdm, words.index("movie"), 0.35), key = lambda x: (-x[1], x[0]))
print("\n".join([f"{words[f[0]]:>12} -> {f[1]}" for f in found]))
#     mindfuck -> 0.56
#     critique -> 0.39
#       decent -> 0.39
#      decided -> 0.39
#    different -> 0.39
#         edge -> 0.39
#   generation -> 0.39
#       giving -> 0.39
#      insight -> 0.39
#         lazy -> 0.39
#         mean -> 0.39
#      melissa -> 0.39
#      mightve -> 0.39
#     offering -> 0.39
#      package -> 0.39
#        plain -> 0.39
#     presents -> 0.39
#     problems -> 0.39
#      running -> 0.39
#      showing -> 0.39
#    somewhere -> 0.39
#        sorta -> 0.39
#        suits -> 0.39
#      touches -> 0.39
#           us -> 0.39
#        video -> 0.39
#      visions -> 0.39
#         teen -> 0.36





# %% 1 - 
cv     = CountVectorizer()
matrix = cv.fit_transform(data["Cleaned_Review"])

words  = cv.get_feature_names_out().tolist()
tdm    = np.array(matrix.todense()).T



# %% 1 - 
found = sorted(find_assocs(tdm, words.index("film"), 0.35), key = lambda x: (-x[1], x[0]))
print("\n".join([f"{words[f[0]]:>12} -> {f[1]}" for f in found]))
#      biggest -> 0.42


# %% 1 - 
found = sorted(find_assocs(tdm, words.index("movie"), 0.35), key = lambda x: (-x[1], x[0]))
print("\n".join([f"{words[f[0]]:>12} -> {f[1]}" for f in found]))
#     mindfuck -> 0.56
#     critique -> 0.39
#       decent -> 0.39
#      decided -> 0.39
#    different -> 0.39
#         edge -> 0.39
#   generation -> 0.39
#       giving -> 0.39
#      insight -> 0.39
#         lazy -> 0.39
#         mean -> 0.39
#      melissa -> 0.39
#      mightve -> 0.39
#     offering -> 0.39
#      package -> 0.39
#        plain -> 0.39
#     presents -> 0.39
#     problems -> 0.39
#      running -> 0.39
#      showing -> 0.39
#    somewhere -> 0.39
#        sorta -> 0.39
#        suits -> 0.39
#      touches -> 0.39
#           us -> 0.39
#        video -> 0.39
#      visions -> 0.39
#         teen -> 0.36










# 4. Create a wordcloud with words having minimum frequency 4. (Use any palette from RColorBrewer)

# %% 1 - 
wf_sub = word_freq[word_freq.Freq >= 4].sort_values("Freq", ascending = False).reset_index(drop = True)
print(wf_sub)
#       Word  Freq
# 0     film    10
# 1     make     7
# 2     like     7
# 3     dont     7
# 4    movie     6
# 5     even     6
# 6      get     5
# 7    comic     5
# 8   pretty     5
# 9   little     4
# 10     say     4
# 11    good     4
# 12  really     4
# 13     see     4
# 14     one     4
# 15    teen     4
# 16   world     4
# 17   films     4


# %% 1 - 
wordcloud = WordCloud(width = 800, height = 400, background_color = "white").generate_from_frequencies(dict(wf_sub.values))

plt.figure(figsize = (16, 8))
plt.imshow(wordcloud, interpolation = "bilinear")
plt.axis("off")

plt.show()










# 5. List the number of lines having sentiments ‘Sarcasm’, ‘Very Negative’ and ‘Very Positive’.

# %% 1 - 
sid = SentimentIntensityAnalyzer()



# %% 1 - 
data["Sentiment_Scores"] = data["Cleaned_Review"].apply(lambda x: sid.polarity_scores(x))
data.iloc[:, 2].head()
# 0    {'neg': 0.19, 'neu': 0.632, 'pos': 0.178, 'com...
# 1    {'neg': 0.0, 'neu': 0.882, 'pos': 0.118, 'comp...
# 2    {'neg': 0.103, 'neu': 0.769, 'pos': 0.128, 'co...
# 3    {'neg': 0.0, 'neu': 0.796, 'pos': 0.204, 'comp...
# 4    {'neg': 0.0, 'neu': 1.0, 'pos': 0.0, 'compound...
# Name: Sentiment_Scores, dtype: object



# %% 1 - 
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



# %% 1 - 
print(data["Compound_Score"].describe())
# count    61.000000
# mean      0.018243
# std       0.446924
# min      -0.897900
# 25%      -0.227800
# 50%       0.000000
# 75%       0.340000
# max       0.893400
# Name: Compound_Score, dtype: float64



# %% 1 - 
data[(data["Compound_Score"] > data["Compound_Score"].quantile(0.75))].shape[0]
# 15


# %% 1 - 
data[(data["Compound_Score"] > 0.5)].shape[0]
# 9


# %% 1 - 
data[(data["Compound_Score"] < data["Compound_Score"].quantile(0.25))].shape[0]
# 15


# %% 1 - 
data[(data["Compound_Score"] < -0.5)].shape[0]
# 7



# %% 1 - 
data["Polarity_Score"]     = data["Cleaned_Review"].apply(lambda x: TextBlob(x).sentiment.polarity)
data["Subjectivity_Score"] = data["Cleaned_Review"].apply(lambda x: TextBlob(x).sentiment.subjectivity)




# %% 1 - 
data.iloc[:, 3:].head()









# 6. Plot graph showing words occurring more than 3 times (Use tidytext package).

# %% 1 - 
wf_sub = wf_sub.sort_values("Freq", ascending = True)



# %% 1 - 
plt.figure(figsize = (16, 8))

plt.barh(wf_sub.Word, wf_sub.Freq, color = "cadetblue")

plt.title("Words Occurring More Than 3 Times")
plt.ylabel('Word')
plt.xlabel('Freq')

plt.show()
