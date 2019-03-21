#word clouds
install.packages("ggplot2")
install.packages("tm")
install.packages("readr")
install.packages("wordcloud")
install.packages("plyr")
install.packages("lubridate")

library(ggplot2)
library(tm)
library(readr)
library(wordcloud)
library(plyr)
library(lubridate)

require(SnowballC)

library(readr)
d <- read_csv("demonetization-tweets.csv")
head(d)

text <- as.character(d$text)

#clean data
sample <- sample(text, (length(text)))
corpus <- Corpus(VectorSource(list(sample)))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, stopwords('english'))
dtm_up <- DocumentTermMatrix(VCorpus(VectorSource(corpus[[1]]$content)))
freq_up <- colSums(as.matrix(dtm_up))

install.packages("RSentiment")
require(RSentiment)

sentiments_up <- calculate_sentiment(names(freq_up))
#Analysis sentiment of a sentence in English and assigns score to sentiment

sentiments_up <- cbind(sentiments_up, as.data.frame(freq_up))
sent_pos_up <- sentiments_up[sentiments_up$sentiment=='Positive',]
sent_neg_up <- sentiments_up[sentiments_up$sentiment=='Negative',]
cat("Negative sentiments:" ,sum(sent_neg_up$freq_up)," Positive sentiments: ", sum(sent_pos_up$freq_up))

#positive word cloud
wordcloud(sent_pos_up$text,sent_pos_up$freq,min.freq = 5, random.color = FALSE, colors=brewer.pal(6,"Dark2"))

#negative word cloud
wordcloud(sent_neg_up$text,sent_neg_up$freq,min.freq = 5, random.color = FALSE, colors=brewer.pal(6,"Dark2"))