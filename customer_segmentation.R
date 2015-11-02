# R script for customer purchase data segmentation

library(dplyr)
library(reshape2)
library(ggplot2)

# loading data
dat2 <- read.csv("./data/ostosdata.csv", header = TRUE, sep="\t")

# changing date format
dat2$PVM <- as.Date(dat2$PVM,"%d.%m.%Y")

# some data processing
orders <- dcast(dat2,NRO+ID+PVM ~ TUOTE, value.var='TUOTE',
  fun.aggregate=length)
 
# defining ending date as it is in the dataset
today <- as.Date('30-12-2014', format='%d-%m-%Y')

# let's compute for every customer (1) how many items (s)he has purchased 
# (frequency) and (2) time lapse from the last purchase to the ending 
# date (recency)
orders <- orders %>%
  group_by(ID) %>%
  mutate(frequency=n(),
  recency=as.numeric(today-PVM)) %>%
  filter(PVM==max(PVM)) %>%
  filter(NRO==max(NRO))

# let's do some exploratory analysis by plotting frequency and
# recency histograms

# for frequency
ggplot(orders, aes(x=frequency)) +
  theme_bw() +
  scale_x_continuous(breaks=c(1:10)) +
  geom_bar(alpha=0.6, binwidth=1) +
  ggtitle("Frekvenssijakauma") +
  xlab("Frekvenssi") +
  ylab("Lukumäärä")
 
# and for recency
ggplot(orders, aes(x=recency)) +
  theme_bw() +
  geom_bar(alpha=0.6, binwidth=1) +
  ggtitle("Ajankohtaisuusjakauma") +
  xlab("Ajankohtaisuus") +
  ylab("Lukumäärä")

# defining between function
Is.Between <- function(x, a, b) {
  (x - a)  *  (b - x) >= 0
}

# segments for each customer ID 
orders.segm <- orders %>%
  mutate(segm.freq=ifelse(Is.Between(frequency, 1, 2), '1-2',
  ifelse(Is.Between(frequency, 3, 4), '3-4',
  ifelse(Is.Between(frequency, 5, 6), '5-6',
  ifelse(Is.Between(frequency, 7, 8), '7-8',
  ifelse(Is.Between(frequency, 9, 10), '9-10', '>10')))))) %>%
  mutate(segm.rec=ifelse(Is.Between(recency, 0, 10), '0-10 päivää',
  ifelse(Is.Between(recency, 11, 20), '11-25 päivää',
  ifelse(Is.Between(recency, 21, 30), '26-40 päivää',
  ifelse(Is.Between(recency, 31, 50), '41-80 päivää',
  ifelse(Is.Between(recency, 81, 120), '81-120 päivää', '>120 päivää')))))) %>%
  arrange(ID)
 
# defining order of boundaries
orders.segm$segm.freq <- factor(orders.segm$segm.freq, levels=c('>10', '9-10',
  '7-8', '5-6', '3-4', '1-2'))
orders.segm$segm.rec <- factor(orders.segm$segm.rec, levels=c('>120 päivää', 
  '81-120 päivää', '41-80 päivää', '26-40 päivää', '11-25 päivää','0-10 päivää'))

# combining clients into segments
lcg <- orders.segm %>%
  group_by(segm.rec, segm.freq) %>%
  summarise(lukumäärä=n()) %>%
  mutate(asiakas='asiakas') %>%
  ungroup()

# visualizing frequency and recency in a single grid
ggplot(lcg, aes(x=asiakas, y=lukumäärä, fill=lukumäärä)) +
  theme_bw() +
  theme(panel.grid = element_blank())+
  geom_bar(stat='identity', alpha=0.6) +
  geom_text(aes(y=max(lukumäärä)/2, label=lukumäärä), size=4) +
  facet_grid(segm.freq ~ segm.rec) +
  ggtitle("Asiakkuusruudukko")



# OK. Next, we'll analyze the monetary value of each customer in a similar 
# way. There are some NAs in the data, so we'll omit those rows.
dat3 <- dat2[complete.cases(dat2),]

# Otherwise, we'll be doing the same stuff as previously but now we have 
# the monetary value, as well. The code has some repetition because
# in the previous analysis we did not want to omit rows with only price 
# field missing.
dat3$PVM <- as.Date(dat3$PVM,"%d.%m.%Y")
orders2 <- dcast(dat3,NRO+ID+PVM+HINTA ~ TUOTE, value.var='TUOTE',
  fun.aggregate=length)

orders2 <- orders2 %>%
  group_by(ID) %>%
  mutate(frequency=n(),
  recency=as.numeric(today-PVM),
  monetary_value=sum(orders2$HINTA)) %>%
  filter(PVM==max(PVM)) %>%
  filter(NRO==max(NRO))

# plotting a histogram of customer monetary value
ggplot(orders2, aes(x=monetary_value)) +
  theme_bw() +
  geom_bar(alpha=0.6, binwidth=10) +
  ggtitle("Jakauma käytetyn rahamäärän mukaan") +
  xlab("Käytetty rahamäärä") +
  ylab("Lukumäärä")

# segments
orders2.segm <- orders2 %>%
  mutate(segm.freq=ifelse(Is.Between(frequency, 1, 2), '1-2',
  ifelse(Is.Between(frequency, 3, 4), '3-4',
  ifelse(Is.Between(frequency, 5, 6), '5-6',
  ifelse(Is.Between(frequency, 7, 8), '7-8',
  ifelse(Is.Between(frequency, 9, 10), '9-10', '>10')))))) %>%
  mutate(segm.rec=ifelse(Is.Between(recency, 0, 10), '0-10 päivää',
  ifelse(Is.Between(recency, 11, 20), '11-25 päivää',
  ifelse(Is.Between(recency, 21, 30), '26-40 päivää',
  ifelse(Is.Between(recency, 31, 50), '41-80 päivää',
  ifelse(Is.Between(recency, 81, 120), '81-120 päivää', '>120 päivää')))))) %>%
  mutate(segm.mon=ifelse(Is.Between(monetary_value, 0, 100), '0-100 euroa',
  ifelse(Is.Between(monetary_value, 101, 200), '101-200 euroa',
  ifelse(Is.Between(monetary_value, 201, 300), '201-300 euroa',
  ifelse(Is.Between(monetary_value, 301, 400), '301-400 euroa',
  ifelse(Is.Between(monetary_value, 401, 500), '401-500 euroa',
    '>500 euroa')))))) %>%
  arrange(ID)

# boundaries
orders2.segm$segm.freq <- factor(orders2.segm$segm.freq, levels=c('>10', '9-10',
  '7-8', '5-6', '3-4', '1-2'))
orders2.segm$segm.rec <- factor(orders2.segm$segm.rec, levels=c('>120 päivää', 
  '81-120 päivää', '41-80 päivää', '26-40 päivää', '11-25 päivää','0-10 päivää'))
orders2.segm$segm.mon <- factor(orders2.segm$segm.mon, levels=c('>500 euroa',
  '401-500 euroa', '301-400 euroa','201-300 euroa', '101-200 euroa', '0-100 euroa'))

# combining clients into segments
lcg2 <- orders2.segm %>%
  group_by(segm.rec, segm.mon) %>%
  summarise(lukumäärä=n()) %>%
  mutate(asiakas='asiakas') %>%
  ungroup()

# visualizing customer recency and monetary value in a single grid
ggplot(lcg2, aes(x=asiakas, y=lukumäärä, fill=lukumäärä)) +
  theme_bw() +
  theme(panel.grid = element_blank())+
  geom_bar(stat='identity', alpha=0.6) +
  geom_text(aes(y=max(lukumäärä)/2, label=lukumäärä), size=4) +
  facet_grid(segm.mon ~ segm.rec) +
  ggtitle("Asiakkuusruudukko")


