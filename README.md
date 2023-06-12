# 💵🤑 Forex Trading Information Scraper Project 💰💲

[![Forex Trading Scraper](https://github.com/fulazz/forex-scraper/actions/workflows/forex.yml/badge.svg)](https://github.comfulazz/forex-scraper/actions/workflows/forex.yml)

<p align="center">
  <img width="681" height="471" src="https://images.unsplash.com/photo-1620266757065-5814239881fd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9yZXglMjB0cmFkaW5nfGVufDB8fDB8fHww&w=1000&q=80">
</p>

## 📓 Project Description

<div align="justify">
The Forex Trading Information Scraper project is a meticulously designed project developed as part of the STA1562 Statistical Data Management course at IPB University. This project focuses on leveraging web scraping techniques to extract valuable forex trading information from the website https://www.bni.co.id/en-us/home/forex-information.

By employing sophisticated scraping methodologies, this project automates the extraction of crucial details related to currency exchange rates, historical trends, and other relevant forex data. The scraped information provides a comprehensive dataset that can be utilized for in-depth analysis, market research, and informed decision-making processes concerning forex trading.

The Forex Trading Information Scraper project showcases the effective utilization of scraping technologies, offering a valuable resource for traders, analysts, and professionals in the forex trading industry. The extracted data can be used to gain insights into currency market trends, analyze historical patterns, and make informed trading decisions. Additionally, it provides a centralized and up-to-date source of information, eliminating the need for manual data collection from multiple sources.

By leveraging this project, individuals and professionals in the forex trading industry can access accurate and timely forex information, enhancing their understanding of market dynamics and improving their trading strategies.
</div>

## 📑 Table of Content
- [Features](#mag_right-features)
- [Usage](#recycle-usage)
- [R Script and YAML](#desktop_computer-r-script-and-yaml)
- [Documentation](#camera_flash-documentation)
- [Visualization](#chart_with_upwards_trend-visualization)
- [Contributing](#people_holding_hands-contributing)
- [License](#balance_scale-license)
- [Publications](#globe_with_meridians-publications)
- [Developers](#pencil-developers)

## :mag_right: Features
- Efficient web data extraction using RStudio, a powerful integrated development environment (IDE) for the R programming language.
- Automation of scraping tasks with GitHub Actions, enabling seamless and automated retrieval of forex trading information.
- Secure storage and efficient management of extracted forex data using MongoDB Atlas, a reliable cloud-based database service.
- Precise data gathering on currency exchange rates, historical trends, and other relevant forex information, providing valuable insights for traders and analysts.

## :recycle: Usage
Here's how you can use the Forex Trading Information Scraper project: 
1. Visit the [BNI Forex Information](https://www.bni.co.id/en-us/home/forex-information) webpage to access the latest forex trading information.
2. Determine the specific forex data you are interested in, such as exchange rates, historical data, or market trends.
3. Run the scraper script designed for the Forex Trading Information Scraper project.
4. The scraper will extract the desired forex trading data from the website.
5. The extracted data will be stored in the MongoDB Atlas database for further analysis and processing.


## :desktop_computer: R Script and YAML
To run the Forex Trading Information Scraper project, follow these steps:

Execute the R script provided below:

```
{
#-------------------------------------------------------------------------------
message("Loading Packages")
library(rvest) #For scraping the data
library(mongolite)
library(tidyverse)
library(rlang)

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

data_SR_fix$jam_scrape<-rep(as.character(Sys.time()),nrow(data_SR_fix))
data_TTC_fix$jam_scrape<-rep(as.character(Sys.time()),nrow(data_TTC_fix))
data_BN_fix$jam_scrape<-rep(as.character(Sys.time()),nrow(data_BN_fix))
#-------------------------------------------------------------------------------
message("Connect to Database")

library(mongolite)

# Connect to MongoDB
atlas1 <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION1"),
  db         = Sys.getenv("ATLAS_DB"),
  url        = Sys.getenv("ATLAS_URL")
)

atlas2 <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION2"),
  db         = Sys.getenv("ATLAS_DB"),
  url        = Sys.getenv("ATLAS_URL")
)

atlas3 <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION3"),
  db         = Sys.getenv("ATLAS_DB"),
  url        = Sys.getenv("ATLAS_URL")
)


atlas1$insert(data_SR_fix)
atlas2$insert(data_TTC_fix)
atlas3$insert(data_BN_fix)

rm(atlas1)
rm(atlas2)
rm(atlas3)
}
```

Then, proceed with the following YAML configuration:

```
{
name: scrape_forex

on:
  schedule:
    - cron: '*/10 * * * *' #every 10 minutes
  workflow_dispatch:
    
jobs:
  hashtag-scrape:
    runs-on: macOS-latest
    env:
      ATLAS_COLLECTION1: ${{ secrets.ATLAS_COLLECTION1 }}
      ATLAS_COLLECTION2: ${{ secrets.ATLAS_COLLECTION2 }}
      ATLAS_COLLECTION3: ${{ secrets.ATLAS_COLLECTION3 }}
      ATLAS_DB: ${{ secrets.ATLAS_DB }}      
      ATLAS_URL: ${{ secrets.ATLAS_URL }}
    steps:
    - name: Start time
      run: echo "$(date) ** $(TZ=Asia/Jakarta date)"
    - uses: actions/checkout@v3
    - uses: r-lib/actions/setup-r@v2   
    - name: Install packages
      run: |
        install.packages("rvest", dependencies = TRUE)
        install.packages("tidyverse", dependencies = TRUE)
        install.packages("rlang", dependencies = TRUE)
        install.packages("mongolite")
      shell: Rscript {0} 
    - name: Scrape Forex Data
      run: Rscript forex-scraper.R
}
```

## :camera_flash: Documentation
Presented below is an illustrative representation of a document residing within a persistently stored MongoDB collection:

**Special Rates**

Note: This refers to a specific exchange rate category offered by the bank for certain types of transactions, such as large currency conversions or specific foreign exchange deals. These rates may be different from the standard rates and may be applicable under special circumstances or for specific customers.
```
{
"_id":{"$oid":"6485649d4a89fb70250f4361"},
"CURRENCY":"GBP",
"BUY":{"$numberDouble":"18546.0"},
"SELL":{"$numberDouble":"18690.0"},
"jam_scrape":"2023-06-11 06:07:21.76003"
}
```

**TT Counter**

Note: TT stands for Telegraphic Transfer, which is a method of electronically transferring funds from one bank account to another. TT Counter refers to the exchange rates offered by the bank for telegraphic transfers. These rates are applicable when transferring funds between different banks or accounts, typically for international money transfers.
```
{
"_id":{"$oid":"6485649d4a89fb70250f436e"},
"CURRENCY":"GBP",
"BUY":{"$numberDouble":"18546.0"},
"SELL":{"$numberDouble":"18690.0"},
"jam_scrape":"2023-06-11 06:07:21.771923"
}
```

**Bank Notes**

Note: Bank Notes refer to physical currency notes, such as banknotes or paper money, issued by a country's central bank. The Bank Notes exchange rates provided on the website are applicable for the buying and selling of physical currency notes, typically for cash transactions.
```
{
"_id":{"$oid":"6485649e4a89fb70250f437b"},
"CURRENCY":"GBP",
"BUY":{"$numberDouble":"18546.0"},
"SELL":{"$numberDouble":"18690.0"},
"jam_scrape":"2023-06-11 06:07:21.772099"
}
```

## :chart_with_upwards_trend: Visualization
| URL                      |
| ------------------------ |
| https://charts.mongodb.com/charts-home-property-scraper-aruxm/public/dashboards/9b4064fd-c81d-4e2c-81f1-ef01a6d5cef3|
| https://rpubs.com/fulazz/1053300|

<p align="center">
  <img width="781" height="471" src="https://github.com/fulazz/forex-scraper/blob/main/ouput_viz/viz%20mongo%20db%20chart.png">
</p>

<p align="center">
  <img width="681" height="471" src="https://github.com/fulazz/forex-scraper/blob/main/ouput_viz/BN1.png">
</p>

<p align="center">
  <img width="681" height="471" src="https://github.com/fulazz/forex-scraper/blob/main/ouput_viz/BN2.png">
</p>

<p align="center">
  <img width="681" height="471" src="https://github.com/fulazz/forex-scraper/blob/main/ouput_viz/SR1.png">
</p>

<p align="center">
  <img width="681" height="471" src="https://github.com/fulazz/forex-scraper/blob/main/ouput_viz/SR2.png">
</p>

<p align="center">
  <img width="681" height="471" src="https://github.com/fulazz/forex-scraper/blob/main/ouput_viz/TTC1.png">
</p>

<p align="center">
  <img width="681" height="471" src="https://github.com/fulazz/forex-scraper/blob/main/ouput_viz/TTC2.png">
</p>

Notes
Interpretation for Output published in RPubs:

Bar Chart:
- The bar chart displays the buy prices for each currency.
- The x-axis represents the different currencies.
- The y-axis represents the buy prices.
- Each bar represents the buy price of a specific currency.
- The height of each bar indicates the magnitude of the buy price for that currency.
- You can compare the heights of the bars to understand the relative buy prices between different currencies.
- The title of the chart, "Buy Prices by Currency," summarizes the content of the visualization.

Scatter Plot:

- The scatter plot displays the relationship between the buy prices and sell prices for each currency.
- The x-axis represents the buy prices, and the y-axis represents the sell prices.
- Each point represents a specific currency, with its position on the plot determined by the corresponding buy and sell prices.
- The color of each point indicates the currency.
- You can examine the position of each point to understand the relationship between the buy and sell prices for a given currency.
- Patterns or trends in the scatter plot can provide insights into the relationship between buy and sell prices across different currencies.
- The title of the chart, "BUY vs SELL Prices by Currency," summarizes the content of the visualization.

## :people_holding_hands: Contributing
This repository is exclusively intended for educational purposes as part of the STA1562 course. Contributions are not accepted at this time.

## :balance_scale: License
This project is licensed under the [MIT License](LICENSE).
**Important Note**: This repository is intended for educational purposes only.

## :globe_with_meridians: Publications
Further details about this project can be accessed through the following link:
- RPubs: https://rpubs.com/fulazz/forex-scraper-project
- App: https://charts.mongodb.com/charts-home-property-scraper-aruxm/public/dashboards/9b4064fd-c81d-4e2c-81f1-ef01a6d5cef3
- Visualization: https://rpubs.com/fulazz/1053300

## :pencil: Developers
  - Author    : [Tahira Fulazzaky](https://github.com/fulazz)
  - Student ID: G1501221024
  - e-mail    : tahirafulazzaky@apps.ipb.ac.id

