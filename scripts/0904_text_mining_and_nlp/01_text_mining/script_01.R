
library(tm)
library(wordcloud)
library(ggplot2)


data <- readLines("./data/0904_text_mining_and_nlp/01_text_mining/HR Appraisal process.txt")
head(data)
# [1] "The process was transparent."                                                                   
# [2] "There is a lot of scope to improve the process, as most questions were subjective."             
# [3] "Happy with the process, but salary increment in 2019 is very low as compared to previous years."
# [4] "Many questions were very subjective. Very difficult to measure the performance."                
# [5] "Questions could have been specific to function. Very general questions."                        
# [6] "More research is required to come out with better process next time."


corp <- Corpus(VectorSource(data))
class(corp)
# [1] "SimpleCorpus" "Corpus"


inspect(corp[1:3])
# <<SimpleCorpus>>
# Metadata:  corpus specific: 1, document level (indexed): 0
# Content:  documents: 3

# [1] The process was transparent.                                                                   
# [2] There is a lot of scope to improve the process, as most questions were subjective.             
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
#  [1] "transparent"     "improve"         "lot"             "questions"       "scope"           "subjective"      "compared"        "happy"           "increment"       "low"            
# [11] "previous"        "salary"          "years"           "difficult"       "many"            "measure"         "performance"     "function"        "general"         "specific"       
# [21] "better"          "come"            "next"            "required"        "research"        "time"            "adopted"         "fair"            "benchmark"       "extremely"      
# [31] "industry"        "methodology"     "rating"          "effort"          "excellent"       "team"            "congratulations" "department"      "improvement"     "needs"          
# [41] "approach"        "current"         "discussion"      "frequent"        "manager"         "using"           "evaluate"        "possible"        "work"            "disappointed"   
# [51] "little"          "biased"          "need"            "expected"        "method"          "used"            "good"            "changes"         "clear"           "twice"          
# [61] "year"            "can"             "consultant"      "hire"            "clearer"         "last"            "selfassessment"  "particular"      "toward"          "appraisal"      
# [71] "think"           "carried"         "organization"    "way"             "modified"        "communication"   "overall"         "satisfied"       "remains"         "keep"           
# [81] "members"         "show"            "make"            "minor"           "robust"          "will"            "removed"         "replaced"        "headvery"        "nice"           
# [91] "smooth"          "appreciate"      "processmust"


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
