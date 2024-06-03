
library(tm)
library(sentimentr)
library(tidyverse)
library(wordcloud)

data <- read.csv("./data/0904_text_mining_and_nlp/05_case_study/reviews_data.csv", header = TRUE)
head(data)
#       name          location           Date Rating
# 1    Helen Wichita Falls, TX  Sept 13, 2023      5
# 2 Courtney        Apopka, FL  July 16, 2023      5
# 3 Daynelle Cranberry Twp, PA   July 5, 2023      5
# 4   Taylor       Seattle, WA   May 26, 2023      5
# 5  Tenessa       Gresham, OR   Jan 22, 2023      5
# 6   Alyssa     Sunnyvale, TX  Sept 14, 2023      1
#                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Review
# 1                                                                                                                                                                                                                                   Amber and LaDonna at the Starbucks on Southwest Parkway are always so warm and welcoming. There is always a smile in their voice when they greet you at the drive-thru. And their customer service is always spot-on, they always get my order right and with a smile. I would actually give them more than 5 stars if they were available.
# 2 ** at the Starbucks by the fire station on 436 in Altamonte Springs, FL made my day and finally helped me figure out the way to make my drink so I’d love it. She took time out to talk to me for 2 minutes to make my experience better than what I’m used to. It was much appreciated! I’ve had bad experiences one after another at the Starbucks that’s closest to me in my work building with my drinks not being great along with not great customer service from specific starbuckss. Niko was refreshing to speak to and pleasant. The drink was perfect! Store 11956
# 3                                                                                                                                                                                                               I just wanted to go out of my way to recognize a Starbucks employee Billy at the Franklin Park location! I was running late to work & placed an order at the wrong location and not only did he make my order with a smile he made it within 60 seconds! Thank you SOO much I was having a bad morning and people like you just make this world a better place.
# 4                                                                                                                     Me and my friend were at Starbucks and my card didn’t work. Thankful the worker there, paid for our drinks. And was very nice about it, it didn’t seem to bother him that he paid for our drinks. This made my day, but made me look like a fool because my card didn’t work. All thanks to Dillon. At Shoreline WA in Safeway. Thank you so much Dillon for the help, support and, kindness. I rate this 1000/10 if I could but, other than that, 10/10.
# 5                                                                                                                                                         I’m on this kick of drinking 5 cups of warm water. I work for Instacart right now and every location of Starbucks I was given free hot water because I asked for it without being charged. I really appreciate Starbucks for giving me the opportunity to do such thing. That’s why I give them five stars. They fully have my support. They’re super nice and professional and the coffee is great. Go to Starbucks.
# 6                                                                                                                                                                                                                                  We had to correct them on our order 3 times. They never got it right then the manager came over to us and said we made her employee uncomfortable because we were trying to correct our order. The manager tried was racist against my stepmom (Chinese) taking over her but when I (**) would talk she would stop talking and listen to me.

str(data)
# 'data.frame':   812 obs. of  5 variables:
#  $ name    : chr  "Helen" "Courtney" "Daynelle" "Taylor" ...
#  $ location: chr  "Wichita Falls, TX" "Apopka, FL" "Cranberry Twp, PA" "Seattle, WA" ...
#  $ Date    : chr  " Sept 13, 2023" " July 16, 2023" " July 5, 2023" " May 26, 2023" ...
#  $ Rating  : int  5 5 5 5 5 1 1 1 1 1 ...
#  $ Review  : chr  "Amber and LaDonna at the Starbucks on Southwest Parkway are always so warm and welcoming. There is always a smi"| __truncated__ "** at the Starbucks by the fire station on 436 in Altamonte Springs, FL made my day and finally helped me figur"| __truncated__ "I just wanted to go out of my way to recognize a Starbucks employee Billy at the Franklin Park location! I was "| __truncated__ "Me and my friend were at Starbucks and my card didn’t work. Thankful the worker there, paid for our drinks. And"| __truncated__ ...


data$Cleaned_Review <- tolower(data$Review)
data$Cleaned_Review <- removeWords(data$Cleaned_Review, stopwords("en"))
data$Cleaned_Review <- removeWords(data$Cleaned_Review, c("drinks", "starbucks", "coffee", "order", "cafe"))
data$Cleaned_Review <- gsub("[^[:alnum:][:space:]]", "", data$Cleaned_Review)
data$Cleaned_Review <- gsub("[0-9]", "", data$Cleaned_Review)
data$Cleaned_Review <- str_squish(data$Cleaned_Review)

data$Review[1]
# [1] "Amber and LaDonna at the Starbucks on Southwest Parkway are always so warm and welcoming. There is always a smile in their voice when they greet you at the drive-thru. And their customer service is always spot-on, they always get my order right and with a smile. I would actually give them more than 5 stars if they were available."

data$Cleaned_Review[1]
# [1] "amber ladonna southwest parkway always warm welcoming always smile voice greet drivethru customer service always spot always get right smile actually give stars available"

positive_reviews <- subset(data, Rating > 3)
positive_reviews <- positive_reviews %>% dplyr::select(Cleaned_Review) %>% tidytext::unnest_tokens(word, Cleaned_Review) %>% dplyr::count(word, sort = TRUE) %>% ungroup()
head(positive_reviews, 2)
#      word  n
# 1  always 60
# 2 service 55

negative_reviews <- subset(data, Rating < 3)
negative_reviews <- negative_reviews %>% dplyr::select(Cleaned_Review) %>% tidytext::unnest_tokens(word, Cleaned_Review) %>% dplyr::count(word, sort = TRUE) %>% ungroup()
head(negative_reviews, 2)
#       word   n
# 1 customer 236
# 2    drink 234

pal <- brewer.pal(8, "Dark2")

wordcloud(positive_reviews$word, positive_reviews$n, random.order = FALSE, min.freq = 10, scale = c(3, 0.3), colors = pal)
wordcloud(negative_reviews$word, negative_reviews$n, random.order = FALSE, min.freq = 10, scale = c(3, 0.3), colors = pal)

data$Compound_Score <- sentiment(data$Cleaned_Review)$sentiment
head(data, 3)

data$Year  <- str_split(data$Date, ", ") %>% sapply(function(x) x[[2]])
data$Year  <- as.numeric(data$Year)
recentdata <- subset(data, Year > 2018)

mean_scores_by_year <- recentdata %>% group_by(Year) %>% summarise(CScore = mean(Compound_Score))

ggplot(data = mean_scores_by_year, aes(x = Year, y = CScore, fill = as.factor(Year))) +
  geom_bar(stat = "identity", position = "dodge") + 
  scale_fill_brewer(palette = "Set2") +
  labs(title = "Mean Compound Score by Year (Year > 2018)", x = "Year", y = "Mean Compound Score", fill = "Year") +
  theme_minimal()

# mean_scores_by_year <- recentdata %>% group_by(Year) %>% summarise(`Compound Score` = mean(Compound_Score))
# 
# ggplot(data = mean_scores_by_year, aes(x = Year, y = `Compound Score`, fill = as.factor(Year))) + 
#   geom_bar(stat = "identity", position = "dodge") + 
#   scale_fill_brewer(palette = "Set2") + 
#   labs(title = "Mean Compound Score by Year (Year > 2018)", x = "Year", y = "Mean Compound Score", fill = "Year") + 
#   theme_minimal()
