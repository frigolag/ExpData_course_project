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

## Plot 3
## Calculate total emissions in Baltimore City per year
bc<-subset(NEI,fips=="24510")
ind<-list(type=as.factor(bc$type),year=as.factor(bc$year))
pmbc_t<-with(bc,tapply(Emissions,ind,sum,na.rm = TRUE))

## Create data frame
df<-as_tibble(pmbc_t,rownames="type")
df1<-with(df,tibble(type=type,year="1999",pm=`1999`))
df2<-with(df,tibble(type=type,year="2002",pm=`2002`))
df3<-with(df,tibble(type=type,year="2005",pm=`2005`))
df4<-with(df,tibble(type=type,year="2008",pm=`2008`))
df0<-rbind(df1,df2,df3,df4)

## Open png device
png("plot3.png")
## Generate plot
g<-ggplot(df0,aes(year,pm))
g<-g+geom_point(aes(color=type))+geom_path(aes(color=type,group=type))
g<-g+labs(y=bquote("Total PM"[2.5]*" emissions (in tons)"),title= "Total emissions by source type in Baltimore City")
print(g)
## Close device
dev.off()
