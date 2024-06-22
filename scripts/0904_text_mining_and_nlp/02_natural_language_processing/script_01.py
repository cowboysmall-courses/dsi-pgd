
# %% 0 - import libraries
import pandas as pd
import re

from textblob import TextBlob

from nltk.tokenize import sent_tokenize, word_tokenize
from nltk.sentiment.vader import SentimentIntensityAnalyzer



# %% 1 - import data and check the head
file_data = open("./data/0904_text_mining_and_nlp/02_natural_language_processing/HR Appraisal process.txt", "r")
data      = file_data.read()



# %% 1 - 
print(sent_tokenize(data))
# ['The process was transparent.', 'There is a lot of scope to improve the process, as most questions were subjective.', 'Happy with the process, but salary increment in 2019 is very low as compared to previous years.', 'Many questions were very subjective.', 'Very difficult to measure the performance.', 'Questions could have been specific to function.', 'Very general questions.', 'More research is required to come out with better process next time.', 'Very happy with the process adopted.', 'Fair and transparent.', 'Salary increment is extremely low as compared to industry benchmark.', 'Not happy with rating methodology.', 'Very subjective questions.', 'Excellent effort by HR team.', 'Very fair process.', 'Congratulations to HR department.', 'Very fair process.', 'The process needs lot of improvement.', 'More frequent discussion with manager is required.', 'It is difficult to measure performance using current approach.', 'Very subjective questions.', 'Not possible to evaluate.', 'Excellent work by HR.', 'Congratulations.', 'Happy with the process.', 'Some scope to improve.', 'The process was fair.', 'Most questions were subjective.', 'Salary increment is very low.', 'Little disappointed.', 'Very difficult to measure the performance with this approach.', 'Not happy with the process.', 'Very biased.', 'Need better process next time.', 'Fair and transparent work by HR,\nSalary increment not as expected.', 'Not happy with method used to evaluate performance.', 'Very fair process by HR.', 'Congratulations to HR.', 'Good work.', 'The process needs lot of changes.', 'It is difficult to measure performance using this method.', 'Very subjective questions.', 'Excellent work by HR.', 'Very clear process.', 'Happy with the process.', 'Better to do twice a year.', 'We can hire consultant to come out with better method.', 'Last year method was clearer than this year.', 'Many changes are required in self-assessment questions.', 'The questions were biased toward particular department.', 'The questions were so subjective.', 'Difficult to measure performance.', 'I think HR department should research more on appraisal process.', 'Very happy with the way process was carried out in our organization.', 'I would be happy if few questions are modified during next appraisal process.', 'I am satisfied with overall communication and the process.', 'The process was fair.', 'Some scope to improve remains.', 'Good work by HR.', 'Keep it up.', 'Excellent show by our HR team members.', 'Very happy.', 'Few minor changes will make the process more robust.', 'Subjective questions can be replaced or removed.', 'Nice work by HR head.Very smooth process.', 'Overall good process.Must appreciate HR team.']



# %% 1 - 
print(word_tokenize(data))
# ['The', 'process', 'was', 'transparent', '.', 'There', 'is', 'a', 'lot', 'of', 'scope', 'to', 'improve', 'the', 'process', ',', 'as', 'most', 'questions', 'were', 'subjective', '.', 'Happy', 'with', 'the', 'process', ',', 'but', 'salary', 'increment', 'in', '2019', 'is', 'very', 'low', 'as', 'compared', 'to', 'previous', 'years', '.', 'Many', 'questions', 'were', 'very', 'subjective', '.', 'Very', 'difficult', 'to', 'measure', 'the', 'performance', '.', 'Questions', 'could', 'have', 'been', 'specific', 'to', 'function', '.', 'Very', 'general', 'questions', '.', 'More', 'research', 'is', 'required', 'to', 'come', 'out', 'with', 'better', 'process', 'next', 'time', '.', 'Very', 'happy', 'with', 'the', 'process', 'adopted', '.', 'Fair', 'and', 'transparent', '.', 'Salary', 'increment', 'is', 'extremely', 'low', 'as', 'compared', 'to', 'industry', 'benchmark', '.', 'Not', 'happy', 'with', 'rating', 'methodology', '.', 'Very', 'subjective', 'questions', '.', 'Excellent', 'effort', 'by', 'HR', 'team', '.', 'Very', 'fair', 'process', '.', 'Congratulations', 'to', 'HR', 'department', '.', 'Very', 'fair', 'process', '.', 'The', 'process', 'needs', 'lot', 'of', 'improvement', '.', 'More', 'frequent', 'discussion', 'with', 'manager', 'is', 'required', '.', 'It', 'is', 'difficult', 'to', 'measure', 'performance', 'using', 'current', 'approach', '.', 'Very', 'subjective', 'questions', '.', 'Not', 'possible', 'to', 'evaluate', '.', 'Excellent', 'work', 'by', 'HR', '.', 'Congratulations', '.', 'Happy', 'with', 'the', 'process', '.', 'Some', 'scope', 'to', 'improve', '.', 'The', 'process', 'was', 'fair', '.', 'Most', 'questions', 'were', 'subjective', '.', 'Salary', 'increment', 'is', 'very', 'low', '.', 'Little', 'disappointed', '.', 'Very', 'difficult', 'to', 'measure', 'the', 'performance', 'with', 'this', 'approach', '.', 'Not', 'happy', 'with', 'the', 'process', '.', 'Very', 'biased', '.', 'Need', 'better', 'process', 'next', 'time', '.', 'Fair', 'and', 'transparent', 'work', 'by', 'HR', ',', 'Salary', 'increment', 'not', 'as', 'expected', '.', 'Not', 'happy', 'with', 'method', 'used', 'to', 'evaluate', 'performance', '.', 'Very', 'fair', 'process', 'by', 'HR', '.', 'Congratulations', 'to', 'HR', '.', 'Good', 'work', '.', 'The', 'process', 'needs', 'lot', 'of', 'changes', '.', 'It', 'is', 'difficult', 'to', 'measure', 'performance', 'using', 'this', 'method', '.', 'Very', 'subjective', 'questions', '.', 'Excellent', 'work', 'by', 'HR', '.', 'Very', 'clear', 'process', '.', 'Happy', 'with', 'the', 'process', '.', 'Better', 'to', 'do', 'twice', 'a', 'year', '.', 'We', 'can', 'hire', 'consultant', 'to', 'come', 'out', 'with', 'better', 'method', '.', 'Last', 'year', 'method', 'was', 'clearer', 'than', 'this', 'year', '.', 'Many', 'changes', 'are', 'required', 'in', 'self-assessment', 'questions', '.', 'The', 'questions', 'were', 'biased', 'toward', 'particular', 'department', '.', 'The', 'questions', 'were', 'so', 'subjective', '.', 'Difficult', 'to', 'measure', 'performance', '.', 'I', 'think', 'HR', 'department', 'should', 'research', 'more', 'on', 'appraisal', 'process', '.', 'Very', 'happy', 'with', 'the', 'way', 'process', 'was', 'carried', 'out', 'in', 'our', 'organization', '.', 'I', 'would', 'be', 'happy', 'if', 'few', 'questions', 'are', 'modified', 'during', 'next', 'appraisal', 'process', '.', 'I', 'am', 'satisfied', 'with', 'overall', 'communication', 'and', 'the', 'process', '.', 'The', 'process', 'was', 'fair', '.', 'Some', 'scope', 'to', 'improve', 'remains', '.', 'Good', 'work', 'by', 'HR', '.', 'Keep', 'it', 'up', '.', 'Excellent', 'show', 'by', 'our', 'HR', 'team', 'members', '.', 'Very', 'happy', '.', 'Few', 'minor', 'changes', 'will', 'make', 'the', 'process', 'more', 'robust', '.', 'Subjective', 'questions', 'can', 'be', 'replaced', 'or', 'removed', '.', 'Nice', 'work', 'by', 'HR', 'head.Very', 'smooth', 'process', '.', 'Overall', 'good', 'process.Must', 'appreciate', 'HR', 'team', '.']



# %% 1 - 
sentences = re.split(r' *[\.\?!][\'"\)\]]* *', data)
print(sentences)



# %% 1 - 
sentiment_analysis = list()

for i in range(0, len(sentences)):
    sentiment = TextBlob(sentences[i])
    print("Sentiment Score: ", sentiment.sentiment.polarity)
    sentiment_analysis.append(sentiment)

# Sentiment Score:  0.0
# Sentiment Score:  0.5
# Sentiment Score:  0.21111111111111114
# Sentiment Score:  0.35
# Sentiment Score:  -0.65
# Sentiment Score:  0.0
# Sentiment Score:  0.06500000000000003
# Sentiment Score:  0.3333333333333333
# Sentiment Score:  1.0
# Sentiment Score:  0.7
# Sentiment Score:  0.0
# Sentiment Score:  -0.4
# Sentiment Score:  0.2
# Sentiment Score:  1.0
# Sentiment Score:  0.9099999999999999
# Sentiment Score:  0.0
# Sentiment Score:  0.9099999999999999
# Sentiment Score:  0.0
# Sentiment Score:  0.3
# Sentiment Score:  -0.25
# Sentiment Score:  0.2
# Sentiment Score:  0.0
# Sentiment Score:  1.0
# Sentiment Score:  0.0
# Sentiment Score:  0.8
# Sentiment Score:  0.0
# Sentiment Score:  0.7
# Sentiment Score:  0.5
# Sentiment Score:  0.0
# Sentiment Score:  -0.46875
# Sentiment Score:  -0.65
# Sentiment Score:  -0.4
# Sentiment Score:  0.2
# Sentiment Score:  0.25
# Sentiment Score:  0.3
# Sentiment Score:  -0.4
# Sentiment Score:  0.9099999999999999
# Sentiment Score:  0.0
# Sentiment Score:  0.7
# Sentiment Score:  0.0
# Sentiment Score:  -0.5
# Sentiment Score:  0.2
# Sentiment Score:  1.0
# Sentiment Score:  0.13
# Sentiment Score:  0.8
# Sentiment Score:  0.5
# Sentiment Score:  0.5
# Sentiment Score:  0.0
# Sentiment Score:  0.5
# Sentiment Score:  0.16666666666666666
# Sentiment Score:  0.0
# Sentiment Score:  -0.5
# Sentiment Score:  0.5
# Sentiment Score:  1.0
# Sentiment Score:  0.20000000000000004
# Sentiment Score:  0.25
# Sentiment Score:  0.7
# Sentiment Score:  0.0
# Sentiment Score:  0.7
# Sentiment Score:  0.0
# Sentiment Score:  1.0
# Sentiment Score:  1.0
# Sentiment Score:  0.08333333333333333
# Sentiment Score:  0.0
# Sentiment Score:  0.6
# Sentiment Score:  0.52
# Sentiment Score:  0.35
# Sentiment Score:  0.0
# Sentiment Score:  0.0



# %% 1 - 
sid = SentimentIntensityAnalyzer()



# %% 1 - 
sent_analysis = pd.DataFrame(columns = ["sentence", "compound", "negative", "neutral", "positive"])



# %% 1 - 
text = [line.rstrip() for line in open("./data/0904_text_mining_and_nlp/02_natural_language_processing/HR Appraisal process.txt")]

for i in range(0, len(text)):
    ss = sid.polarity_scores(text[i])
    compound = ss['compound']
    negative = ss['neg']
    neutral  = ss['neu']
    positive = ss['pos']
    sent_analysis.loc[len(sent_analysis.index)] = [text[i], compound, negative, neutral, positive]

    # This line fails in modern pandas
    # sent_analysis = sent_analysis.append({"sentence": sentences[i], "compound": compound, "negative": negative, "neutral": neutral, "positive": positive}, ignore_index = True)



# %% 1 - 
sent_analysis.head(10)
#                                             sentence  compound  negative  \
# 0                       The process was transparent.    0.0000     0.000   
# 1  There is a lot of scope to improve the process...    0.4404     0.000   
# 2  Happy with the process, but salary increment i...   -0.1875     0.151   
# 3  Many questions were very subjective. Very diff...   -0.4690     0.234   
# 4  Questions could have been specific to function...    0.0000     0.000   
# 5  More research is required to come out with bet...    0.4404     0.000   
# 6  Very happy with the process adopted. Fair and ...    0.7425     0.000   
# 7  Salary increment is extremely low as compared ...   -0.3384     0.210   
# 8  Not happy with rating methodology. Very subjec...   -0.4585     0.300   
# 9    Excellent effort by HR team. Very fair process.    0.7425     0.000   

#    neutral  positive  
# 0    1.000     0.000  
# 1    0.818     0.182  
# 2    0.734     0.115  
# 3    0.766     0.000  
# 4    1.000     0.000  
# 5    0.791     0.209  
# 6    0.527     0.473  
# 7    0.790     0.000  
# 8    0.700     0.000  
# 9    0.488     0.512  
