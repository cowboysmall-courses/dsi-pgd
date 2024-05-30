
library(tm)
library(wordcloud)
library(ggplot2)
library(sentimentr)
library(syuzhet)


data <- readLines("./data/0904_text_mining_and_nlp/00_live_class/HR Appraisal process.txt")
head(data)
# [1] "The process was transparent."                                                                    "There is a lot of scope to improve the process, as most questions were subjective."             
# [3] "Happy with the process, but salary increment in 2019 is very low as compared to previous years." "Many questions were very subjective. Very difficult to measure the performance."                
# [5] "Questions could have been specific to function. Very general questions."                         "More research is required to come out with better process next time."  


corp <- Corpus(VectorSource(data))
class(corp)
# "SimpleCorpus" "Corpus"


inspect(corp[1:3])
# <<SimpleCorpus>>
# Metadata:  corpus specific: 1, document level (indexed): 0
# Content:  documents: 3

# [1] The process was transparent.                                                                    There is a lot of scope to improve the process, as most questions were subjective.             
# [3] Happy with the process, but salary increment in 2019 is very low as compared to previous years.


writeLines(as.character(corp[[3]]))
# Happy with the process, but salary increment in 2019 is very low as compared to previous years.


corp <- tm_map(corp, tolower)
writeLines(as.character(corp[[3]]))
# happy with the process, but salary increment in 2019 is very low as compared to previous years.


corp <- tm_map(corp, removePunctuation)
writeLines(as.character(corp[[3]]))
# happy with the process but salary increment in 2019 is very low as compared to previous years


corp <- tm_map(corp, removeNumbers)
writeLines(as.character(corp[[3]]))
# happy with the process but salary increment in  is very low as compared to previous years


corp <- tm_map(corp, removeWords, stopwords("english"))
writeLines(as.character(corp[[3]]))
# happy   process  salary increment     low  compared  previous years


corp <- tm_map(corp, removeWords, "process")
writeLines(as.character(corp[[3]]))
# happy     salary increment     low  compared  previous years


tdm <- TermDocumentMatrix(corp)
findFreqTerms(tdm)
#  [1] "transparent"     "improve"         "lot"             "questions"       "scope"           "subjective"      "compared"        "happy"           "increment"       "low"             "previous"        "salary"          "years"          
# [14] "difficult"       "many"            "measure"         "performance"     "function"        "general"         "specific"        "better"          "come"            "next"            "required"        "research"        "time"           
# [27] "adopted"         "fair"            "benchmark"       "extremely"       "industry"        "methodology"     "rating"          "effort"          "excellent"       "team"            "congratulations" "department"      "improvement"    
# [40] "needs"           "approach"        "current"         "discussion"      "frequent"        "manager"         "using"           "evaluate"        "possible"        "work"            "disappointed"    "little"          "biased"         
# [53] "need"            "expected"        "method"          "used"            "good"            "changes"         "clear"           "twice"           "year"            "can"             "consultant"      "hire"            "clearer"        
# [66] "last"            "selfassessment"  "particular"      "toward"          "appraisal"       "think"           "carried"         "organization"    "way"             "modified"        "communication"   "overall"         "satisfied"      
# [79] "remains"         "keep"            "members"         "show"            "make"            "minor"           "robust"          "will"            "removed"         "replaced"        "headvery"        "nice"            "smooth"         
# [92] "appreciate"      "processmust"    


findFreqTerms(tdm, 5)
# "questions"   "subjective"  "happy"       "difficult"   "measure"     "performance" "fair"        "work" 


findAssocs(tdm, "difficult", 0.6)
# $difficult
#     measure performance    approach       using
#        1.00        0.90        0.61        0.61


findAssocs(tdm, "questions", 0.6)
# $questions
# subjective
#       0.67


m <- as.matrix(tdm)


v <- sort(rowSums(m), decreasing = TRUE)
d <- data.frame(word = names(v), freq = v)
head(d)
#                    word freq
# questions     questions   13
# happy             happy   10
# subjective   subjective    8
# fair               fair    7
# performance performance    6
# work               work    6

pal2 <- brewer.pal(8, "Dark2")


wordcloud(d$word, d$freq, random.order = FALSE, min.freq = 1, colors = pal2)


term.freq <- rowSums(m)
term.freq <- subset(term.freq, term.freq >= 5)

df <- data.frame(term = names(term.freq), freq = term.freq)

ggplot(df, aes(x = term, y = freq)) +
    geom_bar(stat = "identity") +
    xlab("Terms") +
    ylab("Count") +
    coord_flip()




data2 <- readLines("./data/0904_text_mining_and_nlp/00_live_class/HR Appraisal process.txt")
sentiment(data2)
# Key: <element_id, sentence_id>
#     element_id sentence_id word_count   sentiment
#          <int>       <int>      <int>       <num>
#  1:          1           1          4 -0.12500000
#  2:          2           1         15  0.19364917
#  3:          3           1         16  0.52500000
#  4:          4           1          5  0.00000000
#  5:          4           2          6 -0.07348469
#  6:          5           1          7 -0.39686270
#  7:          5           2          3  0.41569219
#  8:          6           1         12  0.23094011
#  9:          7           1          6  0.55113519
# 10:          7           2          3  0.28867513
# 11:          8           1         10  0.18973666
# 12:          9           1          5 -0.33541020
# 13:          9           2          3  0.00000000
# 14:         10           1          5  0.44721360
# 15:         10           2          3  0.77942286
# 16:         11           1          4  0.37500000
# 17:         11           2          3  0.77942286
# 18:         12           1          6  0.30618622
# 19:         13           1          7  0.27213442
# 20:         13           2          9 -0.03333333
# 21:         14           1          3  0.00000000
# 22:         14           2          4  0.00000000
# 23:         15           1          4  0.62500000
# 24:         15           2          1  0.75000000
# 25:         16           1          4  0.37500000
# 26:         16           2          4  0.37500000
# 27:         17           1          4  0.37500000
# 28:         18           1          4  0.00000000
# 29:         19           1          5  0.26832816
# 30:         19           2          2 -0.14142136
# 31:         20           1          9 -0.06000000
# 32:         21           1          5 -0.33541020
# 33:         21           2          2 -1.27279221
# 34:         22           1          5  0.35777088
# 35:         23           1          6  0.30618622
# 36:         24           1          5 -0.26832816
# 37:         25           1          8 -0.12374369
# 38:         26           1          5  0.60373835
# 39:         27           1          3  0.43301270
# 40:         27           2          2  0.70710678
# 41:         28           1          6  0.00000000
# 42:         29           1          9 -0.03333333
# 43:         30           1          3  0.00000000
# 44:         31           1          4  0.62500000
# 45:         31           2          3  0.51961524
# 46:         32           1          4  0.37500000
# 47:         32           2          6  0.32659863
# 48:         33           1         10  0.44271887
# 49:         34           1          8  0.28284271
# 50:         35           1          8  0.00000000
# 51:         36           1          7 -0.68033605
# 52:         37           1          5  0.00000000
# 53:         37           2          4 -0.05000000
# 54:         38           1         10  0.14230249
# 55:         39           1         12  0.50518149
# 56:         40           1         13 -0.18027756
# 57:         41           1          9  0.33333333
# 58:         42           1          4  0.37500000
# 59:         42           2          5  0.33541020
# 60:         43           1          4  0.50000000
# 61:         43           2          3  0.00000000
# 62:         44           1          7  0.37796447
# 63:         44           2          2  0.95459415
# 64:         45           1          9  0.45000000
# 65:         46           1          7  0.00000000
# 66:         47           1          5  0.33541020
# 67:         47           2          3  0.62353829
# 68:         48           1          3  0.43301270
# 69:         48           2          4  0.25000000
#     element_id sentence_id word_count   sentiment

sentiment_by(data2)


get_sentiment(data2)


nrcsentiment <- get_nrc_sentiment(data2)
head(nrcsentiment)
#   anger anticipation disgust fear joy sadness surprise trust negative positive
# 1     0            0       0    0   0       0        0     0        0        0
# 2     0            1       0    0   1       0        0     1        0        1
# 3     0            2       0    0   2       0        0     2        0        2
# 4     0            0       0    1   0       0        0     1        0        0
# 5     0            0       0    0   0       0        0     1        0        1
# 6     0            1       0    0   0       0        0     0        0        0






