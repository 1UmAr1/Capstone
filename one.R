# Reading in the Files
A <- file("en_US.blogs.txt", open = "rb")

blogs <- readLines(A, skipNul = T, encoding = "UTF-8")

close(A)

B <- file("en_US.twitter.txt", open = "rb")

twitter <- readLines(B, skipNul = T, encoding = "UTF-8")

close(B)

C <- file("en_US.news.txt", open = "rb")

news <- readLines(C, skipNul = T, encoding = "UTF-8")

close(C)


# The data set consists of three files in US English
# Sampling text files
# This will enable faster Data processing

sampletext <- function(textbody, portion) {
  taking <- sample(1:length(textbody), length(textbody)*portion)
  Sampletext <- textbody[taking]
  Sampletext
}

set.seed(1103)
# As the test files are large we need to create a samples from each data sets
# This will improve processing time 
portion <- 25/50
SampleTwitter <- sampletext(twitter, portion)
SampleBlog <- sampletext(blogs, portion)
SampleNews <- sampletext(news, portion)

# combine sampled texts into one variable
SampleAll <- c(SampleBlog, SampleNews, SampleTwitter)

# write sampled texts into text files for further analysis
writeLines(SampleAll, "SampleAll.txt")

theSampleCon <- file("SampleAll.txt")
theSample <- readLines(theSampleCon)
close(theSampleCon)

## Checking the size and length of the files and calculate the word count
library(stringi)
blogsFile <- file.info("./final/en_US/en_US.blogs.txt")$size / 1024.0 / 1024.0
newsFile <- file.info("./final/en_US/en_US.news.txt")$size / 1024.0 / 1024.0
twitterFile <- file.info("./final/en_US/en_US.twitter.txt")$size / 1024.0 / 1024.0
sampleFile <- file.info("./MilestoneReport/textSample.txt")$size / 1024.0 / 1024.0
blogsLength <- length(blogs)
newsLength <- length(news)
twitterLength <- length(twitter)
sampleLength <- length(theSample)
blogsWords <- sum(sapply(gregexpr("\\S+", blogs), length))
newsWords <- sum(sapply(gregexpr("\\S+", news), length))
twitterWords <- sum(sapply(gregexpr("\\S+", twitter), length))
sampleWords <- sum(sapply(gregexpr("\\S+", theSample), length))
wpl <- lapply(list(blogs, news, twitter), function(x) stri_count_words(x))
# Analysing
blogsWords
newsWords
twitterWords

# An initial invertigation of the data shows that on average, each text corpora
# Has a relatively low number of words per line.Blogs tend to have more words per line
# News has less number of words per line and Twitter has the least


# Histogram of Words per line
library(ggplot2)
library(gridExtra)

plot1 <- qplot(wpl[[1]],
               geom = "histogram",
               main = "US Blogs",
               xlab = "WPL",
               ylab = "Frequency",
               binwidth = 50)
plot1

plot2 <- qplot(wpl[[2]],
               geom = "histogram",
               main = "US News",
               xlab = "WPL",
               ylab = "Frequency",
               binwidth = 50)
plot2

plot3 <- qplot(wpl[[3]],
               geom = "histogram",
               main = "US Twitter",
               xlab = "WPL",
               ylab = "Frequency",
               binwidth = 50)
plot3


# This observation seems to support a general trend towards short and concise
# communications that may be useful later in the project

library(tm)
library(dplyr)
library(doSNOW)
cl <- makeCluster(6, type = "SOCK")
registerDoSNOW(cl)



library(NLP)
library(rJava)
library(RWeka)
library(data.table)

sample_size = 1700
sample_blog <- blogs[sample(1:length(blogs),sample_size)]
sample_news <- news[sample(1:length(news),sample_size)]
sample_twitter <- twitter[sample(1:length(twitter),sample_size)]

sample_data<-rbind(sample_blog,sample_news,sample_twitter)
rm(blogs,news,twitter, SampleAll, sample_blog, sample_news, sample_twitter)
rm(SampleAll, SampleBlog, SampleNews, SampleTwitter)
rm(wpl)

# Creating Corpus
mycorpus<-VCorpus(VectorSource(sample_data))
mycorpus <- tm_map(mycorpus, content_transformer(tolower)) # convert to lowercase
mycorpus <- tm_map(mycorpus, removePunctuation) # remove punctuation
mycorpus <- tm_map(mycorpus, removeNumbers) # remove numbers
mycorpus <- tm_map(mycorpus, stripWhitespace) # remove multiple whitespace
changetospace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
mycorpus <- tm_map(mycorpus, changetospace, "/|@|\\|")
save(mycorpus,file = "Coupus.Rda")

uniGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 1))
biGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
triGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
fourGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
OneT <- NGramTokenizer(mycorpus, Weka_control(min = 1, max = 1))
oneGM <- TermDocumentMatrix(mycorpus, control = list(tokenize = uniGramTokenizer))
twoGM <- TermDocumentMatrix(mycorpus, control = list(tokenize = biGramTokenizer))
threeGM <- TermDocumentMatrix(mycorpus, control = list(tokenize = triGramTokenizer))
fourGM <- TermDocumentMatrix(mycorpus, control = list(tokenize = fourGramTokenizer))

freqTerms1 <- findFreqTerms(oneGM, lowfreq = 5)
termFreq1 <- rowSums(as.matrix(oneGM[freqTerms1,]))
termFreq1 <- data.frame(unigram=names(termFreq1), frequency=termFreq1)
termFreq1 <- termFreq1[order(-termFreq1$frequency),]
unigramlist <- setDT(termFreq1)
save(unigramlist,file="unigram.csv")
freqTerms2 <- findFreqTerms(twoGM, lowfreq = 3)
termFreq2 <- rowSums(as.matrix(twoGM[freqTerms2,]))
termFreq2 <- data.frame(bigram=names(termFreq2), frequency=termFreq2)
termFreq2 <- termFreq2[order(-termFreq2$frequency),]
bigramlist <- setDT(termFreq2)
save(bigramlist,file="bigram.csv")
freqTerms3 <- findFreqTerms(threeGM, lowfreq = 2)
termFreq3 <- rowSums(as.matrix(threeGM[freqTerms3,]))
termFreq3 <- data.frame(trigram=names(termFreq3), frequency=termFreq3)
trigramlist <- setDT(termFreq3)
save(trigramlist,file="trigram.csv")
freqTerms4 <- findFreqTerms(fourGM, lowfreq = 1)
termFreq4 <- rowSums(as.matrix(fourGM[freqTerms4,]))
termFreq4 <- data.frame(fourgram=names(termFreq4), frequency=termFreq4)
fourgramlist <- setDT(termFreq4)
save(fourgramlist,file="fourgram.csv")

stopCluster(cl)





