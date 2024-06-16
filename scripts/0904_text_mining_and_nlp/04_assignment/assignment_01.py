
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
import matplotlib.pyplot as plt
import nltk

from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize

from wordcloud import WordCloud

from string import punctuation, digits


# %% 1 - 
with open("./data/0904_text_mining_and_nlp/04_assignment/Textdata.txt") as file:
    lines = [line.rstrip() for line in file]



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



# %% 1 - 
text = data["Cleaned_Review"].str.cat(sep = " ")



# %% 1 - 
freq_dist = nltk.FreqDist(word_tokenize(text))



# %% 1 - 
words = pd.DataFrame(freq_dist.items(), columns=["Word", "Freq"])
print(words[words.Freq >= 6].sort_values("Freq", ascending = False))
#       Word  Freq
# 68    film    10
# 24    like     7
# 66    dont     7
# 238   make     7
# 170   even     6
# 360  movie     6



# %% 1 - 
words[words.Freq >= 4].sort_values("Freq", ascending = False).reset_index(drop = True)
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
wordcloud = WordCloud(width = 800, height = 400, background_color = "white").generate_from_frequencies(dict(words[words.Freq >= 4].values))

plt.figure(figsize = (10, 5))
plt.imshow(wordcloud, interpolation = "bilinear")
plt.axis("off")

plt.show()



# %% 1 - 




# %% 1 -



