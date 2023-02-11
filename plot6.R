## Load package
library(tidyverse)

## Check if zip file exists in directory
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zipfile <- "exdata_data_NEI_data.zip"
## If not download 
if (!file.exists(zipfile)){
  download.file(url,zipfile,mode="wb")
}

## Check if files exist in directory
## If not unzip 
if (!file.exists("summarySCC_PM25.rds")){
  unzip(zipfile,files ="summarySCC_PM25.rds" )
}
if (!file.exists("Source_Classification_Code.rds")){
  unzip(zipfile,files ="Source_Classification_Code.rds")
}

## Read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Get SCC digits for motor vehicle sources
vehicle<-SCC[grepl("vehicle",SCC$SCC.Level.Two,ignore.case = TRUE),]
vehiclescc<-as.character(vehicle$SCC)
vehiclenei<-NEI[NEI$SCC %in% vehiclescc,]

## Subset data to Baltimore City
vehicle<-vehiclenei[vehiclenei$fips=="24510"|vehiclenei$fips=="06037",]
##vehiclebc$city<-"Baltimore City"
## Subset data to Los Angeles County
##vehiclelac<-vehiclenei[vehiclenei$fips=="06037",]
##vehiclelac$city<-"Los Angeles County"

## Merge data sets
##df<-rbind(vehiclebc,vehiclelac)

ind<-list(fips=as.factor(vehicle$fips),year=as.factor(vehicle$year))
t<-with(vehicle,tapply(Emissions, ind, sum))
dflac<-data.frame(city="Los Angeles County",emissions=t[1,],year=dimnames(t)[2])
dfbc<-data.frame(city="Baltimore City",emissions=t[2,],year=dimnames(t)[2])
dft<-rbind(dflac,dfbc)

## Open png device
png("plot6.png")

## Create plot
g<-ggplot(dft,aes(year,log(emissions),color=city))+
  geom_point()+ geom_path(aes(color=city,group=city))+
  labs(title= "Emissions from motor vehicle sources")
print(g)

## Close device
dev.off()
