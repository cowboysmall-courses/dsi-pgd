
# %% 0 - import libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import itertools
import nltk
# nltk.download()

from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize

from wordcloud import WordCloud

from string import punctuation, digits



# %% 1 - 
text = [line.rstrip() for line in open("./data/0904_text_mining_and_nlp/01_text_mining/HR Appraisal process.txt")]
text[0:5]



# %% 1 - 
text[2]
# ['The process was transparent.',
#  'There is a lot of scope to improve the process, as most questions were subjective.',
#  'Happy with the process, but salary increment in 2019 is very low as compared to previous years.',
#  'Many questions were very subjective. Very difficult to measure the performance.',
#  'Questions could have been specific to function. Very general questions.']



# %% 1 - 
corp = [item.lower() for item in text]
corp[2]
# 'happy with the process, but salary increment in 2019 is very low as compared to previous years.'



# %% 1 - 
remove_punc = str.maketrans('', '', punctuation)
corp = [item.translate(remove_punc) for item in corp]
corp[2]
# 'happy with the process but salary increment in 2019 is very low as compared to previous years'



# %% 1 - 
remove_digits = str.maketrans('', '', digits)
corp = [item.translate(remove_digits) for item in corp]
corp[2]
# 'happy with the process but salary increment in  is very low as compared to previous years'



# %% 1 - 
stop_words = stopwords.words('english')

fs = []
for item in corp:
    word_tokens = word_tokenize(item)
    filtered_sentence = [word for word in word_tokens if word not in stop_words]
    fs.append(filtered_sentence)
fs[2]
# ['happy',
#  'process',
#  'salary',
#  'increment',
#  'low',
#  'compared',
#  'previous',
#  'years']



# %% 1 - 
new_stop_words = ['process']
stop_words.extend(new_stop_words)

fs = []
for item in corp:
    word_tokens = word_tokenize(item)
    filtered_sentence = [word for word in word_tokens if word not in stop_words]
    fs.append(filtered_sentence)
fs[2]
# ['happy', 'salary', 'increment', 'low', 'compared', 'previous', 'years']



# %% 1 - 
filtered_text = list(itertools.chain.from_iterable(fs))
fdist = nltk.FreqDist(filtered_text)
fdist.most_common(10)
# [('questions', 13),
#  ('hr', 12),
#  ('happy', 10),
#  ('subjective', 8),
#  ('fair', 7),
#  ('performance', 6),
#  ('work', 6),
#  ('difficult', 5),
#  ('measure', 5),
#  ('salary', 4)]



# %% 1 - 
wordcloud = WordCloud(background_color = "white").generate(str(filtered_text))



# %% 1 - 
plt.figure(figsize = (16, 10))
plt.imshow(wordcloud)
plt.axis('off')
plt.tight_layout(pad = 0)
plt.show()



# %% 1 - 
a = fdist.most_common(10)



# %% 1 - 
b = pd.DataFrame(a)
b = b.rename(columns = {0: 'Words', 1: 'Frequency'})



# %% 1 - 
c = b.Words
y = np.arange(len(c))
x = b.Frequency



# %% 1 - 
plt.barh(y, x, align = 'center', alpha = 0.5)

plt.yticks(y, c)

plt.title('Words by Frequency')
plt.xlabel('Frequency')
plt.ylabel('Words')

plt.show()
