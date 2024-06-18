
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





library(tm)
library(wordcloud)
library(RSentiment)
library(tidyverse)










# 1. Import Textdata. Do the essential cleaning of the data.

lines <- readLines("./data/0904_text_mining_and_nlp/04_assignment/Textdata.txt", skipNul = TRUE)
data  <- data.frame(Review = lines)
head(data)
# 1 films adapted from comic books have had plenty of success , whether they're about superheroes ( batman , superman , spawn ) , or geared toward kids ( casper ) or the arthouse crowd ( ghost world ) , but there's never really been a comic book like from hell before . 
# 2                                                                                              for starters , it was created by alan moore ( and eddie campbell ) , who brought the medium to a whole new level in the mid '80s with a 12-part series called the watchmen . 
# 3                                                                                                                    to say moore and campbell thoroughly researched the subject of jack the ripper would be like saying michael jackson is starting to look a little odd . 
# 4                                                                                                                                the book ( or " graphic novel , " if you will ) is over 500 pages long and includes nearly 30 more that consist of nothing but footnotes . 
# 5                                                                                                                                                                                                          in other words , don't dismiss this film because of its source . 
# 6                                                                                                                              if you can get past the whole comic book thing , you might find another stumbling block in from hell's directors , albert and allen hughes .


data$Cleaned_Review <- tolower(data$Review)
data$Cleaned_Review <- removePunctuation(data$Cleaned_Review)
data$Cleaned_Review <- removeNumbers(data$Cleaned_Review)
data$Cleaned_Review <- removeWords(data$Cleaned_Review, stopwords("english"))
data$Cleaned_Review <- str_squish(data$Cleaned_Review)
head(data)
#                                                                        Review
# 1 films adapted from comic books have had plenty of success , whether they're about superheroes ( batman , superman , spawn ) , or geared toward kids ( casper ) or the arthouse crowd ( ghost world ) , but there's never really been a comic book like from hell before . 
# 2                                                                                              for starters , it was created by alan moore ( and eddie campbell ) , who brought the medium to a whole new level in the mid '80s with a 12-part series called the watchmen . 
# 3                                                                                                                    to say moore and campbell thoroughly researched the subject of jack the ripper would be like saying michael jackson is starting to look a little odd . 
# 4                                                                                                                                the book ( or " graphic novel , " if you will ) is over 500 pages long and includes nearly 30 more that consist of nothing but footnotes . 
# 5                                                                                                                                                                                                          in other words , don't dismiss this film because of its source . 
# 6                                                                                                                              if you can get past the whole comic book thing , you might find another stumbling block in from hell's directors , albert and allen hughes . 
#                                                                                                                                                              Cleaned_Review
# 1 films adapted comic books plenty success whether superheroes batman superman spawn geared toward kids casper arthouse crowd ghost world never really comic book like hell
# 2                                                               starters created alan moore eddie campbell brought medium whole new level mid s part series called watchmen
# 3                                                         say moore campbell thoroughly researched subject jack ripper like saying michael jackson starting look little odd
# 4                                                                                              book graphic novel will pages long includes nearly consist nothing footnotes
# 5                                                                                                                                                 words dismiss film source
# 6                                                                can get past whole comic book thing might find another stumbling block hells directors albert allen hughes










# 2. Find words with minimum frequency 6.

tdm <- TermDocumentMatrix(data$Cleaned_Review)
findFreqTerms(tdm, 6)
# [1] "like"  "dont"  "film"  "even"  "make"  "movie"










# 3. List words with at least 0.35 correlation with ‘film’.

findAssocs(tdm, "film", 0.35)
# $film
# biggest     now 
#    0.42    0.39


findAssocs(tdm, "movie", 0.35)
# $movie
#   mindfuck      sorta   critique generation    package   presents    touches   problems       lazy       mean    melissa      plain    running    showing    visions  different     giving    insight   offering     decent    decided 
#       0.56       0.39       0.39       0.39       0.39       0.39       0.39       0.39       0.39       0.39       0.39       0.39       0.39       0.39       0.39       0.39       0.39       0.39       0.39       0.39       0.39 
#       edge    mightve  somewhere      suits      video       teen 
#       0.39       0.39       0.39       0.39       0.39       0.36










# 4. Create a wordcloud with words having minimum frequency 4. (Use any palette from RColorBrewer)

words <- data %>%
  dplyr::select(Cleaned_Review) %>%
  tidytext::unnest_tokens(Word, Cleaned_Review) %>%
  dplyr::count(Word, sort = TRUE, name = "Freq") %>%
  dplyr::filter(Freq >= 4) %>%
  ungroup()

wordcloud(words$Word, words$Freq, random.order = FALSE, colors = brewer.pal(8, "Dark2"))


words <- data %>%
  dplyr::select(Cleaned_Review) %>%
  tidytext::unnest_tokens(Word, Cleaned_Review) %>%
  dplyr::count(Word, sort = TRUE, name = "Freq") %>%
  ungroup()

wordcloud(words$Word, words$Freq, random.order = FALSE, min.freq = 4, colors = brewer.pal(8, "Dark2"))










# 5. List the number of lines having sentiments ‘Sarcasm’, ‘Very Negative’ and ‘Very Positive’.

calculate_total_presence_sentiment(data$Review)
# [1,] "Sarcasm" "Negative" "Very Negative" "Neutral" "Positive" "Very Positive"
# [2,] "9"       "12"       "6"             "20"      "6"        "8"


calculate_total_presence_sentiment(data$Cleaned_Review)
# [1,] "Sarcasm" "Negative" "Very Negative" "Neutral" "Positive" "Very Positive"
# [2,] "0"       "13"       "11"            "18"      "9"        "10"










# 6. Plot graph showing words occurring more than 3 times (Use tidytext package).

words <- data %>%
  dplyr::select(Cleaned_Review) %>%
  tidytext::unnest_tokens(Word, Cleaned_Review) %>%
  dplyr::count(Word, sort = TRUE, name = "Freq") %>%
  dplyr::filter(Freq >= 4) %>%
  ungroup()


ggplot(data = words, aes(x = reorder(Word, Freq), y = Freq, fill = Word)) + 
  geom_bar(stat = "identity") + 
  labs(title = "Words Occurring More Than 3 Times", x = "Word", y = "Freq") +
  coord_flip()
