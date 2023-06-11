#-------------------------------------------------------------------------------
message("Loading Packages")
library(robotstxt) #For checking website scraping permission
library(rvest) #For scraping the data
library(mongolite)
library(tidyverse)
library(rlang)

#-------------------------------------------------------------------------------
message("Checking Website Permission")
paths_allowed("https://www.bni.co.id/en-us/home/forex-information")

#-------------------------------------------------------------------------------
message("Scraping Data")

#retrieve data from websites
url = "https://www.bni.co.id/en-us/home/forex-information"
html = read_html(url)

# display data with tables
data <- html %>% html_nodes("table") %>% html_table()
data_SR <- as.data.frame(data[[1]])
data_TTC <- as.data.frame(data[[2]])
data_BN <- as.data.frame(data[[3]])

# convert data to numeric
##data Bank Notes
data_BN$SELL <- as.numeric(gsub(",", "", as.character(data_BN$SELL)))
data_BN$SELL[is.na(data_BN$SELL)] <- NA
data_BN$BUY <- as.numeric(gsub(",", "", as.character(data_BN$BUY)))
data_BN$BUY[is.na(data_BN$BUY)] <- NA
##data Special Rates
data_SR$SELL <- as.numeric(gsub(",", "", as.character(data_SR$SELL)))
data_SR$SELL[is.na(data_SR$SELL)] <- NA
data_SR$BUY <- as.numeric(gsub(",", "", as.character(data_SR$BUY)))
data_SR$BUY[is.na(data_SR$BUY)] <- NA
##data TT counter
data_TTC$SELL <- as.numeric(gsub(",", "", as.character(data_TTC$SELL)))
data_TTC$SELL[is.na(data_TTC$SELL)] <- NA
data_TTC$BUY <- as.numeric(gsub(",", "", as.character(data_TTC$BUY)))
data_TTC$BUY[is.na(data_TTC$BUY)] <- NA

# Sort data by maximum selling price
data_SR_fix <- data_SR[order(data_SR$SELL, decreasing = T),]
data_TTC_fix <- data_SR[order(data_TTC$SELL, decreasing = T),]
data_BN_fix <- data_SR[order(data_BN$SELL, decreasing = T),]

data_SR_fix$hari_scrap<-rep(as.character(Sys.Date()),nrow(data_SR_fix))
data_TTC_fix$jam_scrap<-rep(as.character(Sys.time()),nrow(data_TTC_fix))
data_BN_fix$jam_scrap<-rep(as.character(Sys.time()),nrow(data_BN_fix))
#-------------------------------------------------------------------------------
message("Connect to Database")

library(mongolite)

# Connect to MongoDB
atlas1 <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION"),
  db         = Sys.getenv("ATLAS_DB"),
  url        = Sys.getenv("ATLAS_URL")
)

atlas2 <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION"),
  db         = Sys.getenv("ATLAS_DB"),
  url        = Sys.getenv("ATLAS_URL")
)

atlas3 <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION"),
  db         = Sys.getenv("ATLAS_DB"),
  url        = Sys.getenv("ATLAS_URL")
)


atlas1$insert(data_SR_fix)
atlas2$insert(data_TTC_fix)
atlas3$insert(data_BN_fix)

rm(atlas1)
rm(atlas2)
rm(atlas3)

atlas1$disconnect()
atlas2$disconnect()
atlas3$disconnect()
