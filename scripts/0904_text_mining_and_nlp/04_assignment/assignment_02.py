
# EXTRA - in this script I present an implementation of Find Associations in Python
# 
# (this is not part of the assignment - it is presented out of interest)





# %% 0 - import libraries
import pandas as pd
import numpy as np
import nltk

from scipy.stats import pearsonr

from sklearn.feature_extraction.text import CountVectorizer

from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize

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










# 3. List words with at least 0.35 correlation with ‘film’.

# %% 1 - Approach 1
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





# %% 1 - Approach 2
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

