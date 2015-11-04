# Predicting visitors on a website based on various independent variables

# importing libraries
library(gdata)

# loading data
dat <- read.xls("./data/mallinnusdata.xlsx", header = TRUE)

# summarizing basic statistics of the dataset
summary(dat)

# plotting the dependent variable against weeks
plot(dat$Juokseva_viikko, dat$Verkkosivun_uniikit_kävijät, type="l")

# building linear regression models
# first general variables: rainfall and customer trust index with 
# an interaction term:
model1 <- lm(Verkkosivun_uniikit_kävijät ~ Sademäärä_Helsinki.Vantaa*
  Kuluttajien.luottamusindeksi, data=dat)
summary(model1)

# do midweek holidays affect the dependent variable?
model2 <- lm(Verkkosivun_uniikit_kävijät ~ factor(Arkipyhät), data=dat)
summary(model2)

# does month affect the dependent variable?
# it's easier to move all months into one variable with 12 levels and use 
# that in the LM
dat$kuukaudet = dat$Tammikuu+dat$Helmikuu*2+dat$Maaliskuu*3+dat$Huhtikuu*4+
dat$Toukokuu*5+dat$Kesakuu*6+dat$Heinakuu*7+dat$Elokuu*8+dat$Syyskuu*9+
dat$Lokakuu*10+dat$Marraskuu*11+dat$Joulukuu*12
model3 <- lm(Verkkosivun_uniikit_kävijät ~ factor(kuukaudet), data=dat)
summary(model3)

# media investments
model4 <- lm(Verkkosivun_uniikit_kävijät ~ AIKAKAUSLEHDET_MEDIAPANOSTUKSET+          
  ELOKUVA_MEDIAPANOSTUKSET+INTERNET_MEDIAPANOSTUKSET+RADIO_MEDIAPANOSTUKSET+                    
  SANOMALEHDET_MEDIAPANOSTUKSET+TELEVISIO_MEDIAPANOSTUKSET+
  ULKO..JA.LIIKENNEMAINONTA_MEDIAPANOSTUKSET, data=dat)
summary(model4)

# media investments with pairwise interaction terms
model5 <- lm(Verkkosivun_uniikit_kävijät ~ (AIKAKAUSLEHDET_MEDIAPANOSTUKSET+          
  ELOKUVA_MEDIAPANOSTUKSET+INTERNET_MEDIAPANOSTUKSET+RADIO_MEDIAPANOSTUKSET+                    
  SANOMALEHDET_MEDIAPANOSTUKSET+TELEVISIO_MEDIAPANOSTUKSET+
  ULKO..JA.LIIKENNEMAINONTA_MEDIAPANOSTUKSET)^2, data=dat)
summary(model5)

# contacting customers
model6 <- lm(Verkkosivun_uniikit_kävijät ~ TELEVISIO_KONTAKTIT+                       
  RADIO_KONTAKTIT+Lähetetyt_uutiskirjeet_nykyiset_asiakkaat+ 
  Avatut_uutiskirjeet_nykyiset_asiakkaat+Lähetetyt_uutiskirjeet_uudet_asiakkaat+    
  Avatut_uutiskirjeet_uudet_asiakkaat+Hakukonemainonta_kustannukset+             
  Hakukonemainonta_klikit+Hakukonemainonta_impressiot+Recency_Impressions+                       
  Recency_klikit+Burst_Impressions+Burst_klikit+Burst_kustannukset+
  TELEVISIO_OHJELMAYHTEISTYÖN_AJANKOHTA, data=dat)
summary(model6)

# total investments of all competitors with pairwise interaction terms
model7 <- lm(Verkkosivun_uniikit_kävijät ~ (KILPAILIJA_A_yht+                          
  KILPAILIJA_B_yht+KILPAILIJA_C_yht+KILPAILIJA_D_yht)^2,  
  data=dat)
summary(model7)

# detailed analysis of the investments by competitor A
model8 <- lm(Verkkosivun_uniikit_kävijät ~ (KILPAILIJA_A_SANOMALEHDET+
  KILPAILIJA_A_AIKAKAUSLEHDET+KILPAILIJA_A_TELEVISIO+KILPAILIJA_A_RADIO+
  KILPAILIJA_A_ULKOMAINONTA+KILPAILIJA_A_ELOKUVA+KILPAILIJA_A_INTERNET)^2,  
  data=dat)
summary(model8)

# detailed analysis of the investments by competitor B
model9 <- lm(Verkkosivun_uniikit_kävijät ~ (KILPAILIJA_B_SANOMALEHDET+
  KILPAILIJA_B_AIKAKAUSLEHDET+KILPAILIJA_B_TELEVISIO+KILPAILIJA_B_RADIO+
  KILPAILIJA_B_ULKOMAINONTA+KILPAILIJA_B_ELOKUVA+KILPAILIJA_B_INTERNET)^2,  
  data=dat)
summary(model9)

# detailed analysis of the investments by competitor C
model10 <- lm(Verkkosivun_uniikit_kävijät ~ (KILPAILIJA_C_SANOMALEHDET+
  KILPAILIJA_C_AIKAKAUSLEHDET+KILPAILIJA_C_TELEVISIO+                    
  KILPAILIJA_C_RADIO+KILPAILIJA_C_ULKOMAINONTA+KILPAILIJA_C_ELOKUVA+                      
  KILPAILIJA_C_INTERNET)^2,  
  data=dat)
summary(model10)

# detailed analysis of the investments by competitor D
model11 <- lm(Verkkosivun_uniikit_kävijät ~ (KILPAILIJA_D_SANOMALEHDET+                 
  KILPAILIJA_D_AIKAKAUSLEHDET+KILPAILIJA_D_TELEVISIO+KILPAILIJA_D_RADIO+                        
  KILPAILIJA_D_ULKOMAINONTA+KILPAILIJA_D_ELOKUVA+KILPAILIJA_D_INTERNET)^2,  
  data=dat)
summary(model11)

# building the final model
model12 <- lm(Verkkosivun_uniikit_kävijät ~ (Kuluttajien.luottamusindeksi+
  INTERNET_MEDIAPANOSTUKSET+SANOMALEHDET_MEDIAPANOSTUKSET+Hakukonemainonta_klikit+
  Recency_Impressions+Recency_klikit+TELEVISIO_OHJELMAYHTEISTYÖN_AJANKOHTA)^2)
summary(model12)
