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

## Get SCC digits for combustion of coal

comb<-SCC[grepl("Comb",SCC$EI.Sector),]
coal<-comb[grepl("Coal",comb$EI.Sector),]
coalscc<-as.character(coal$SCC)
coalnei<-NEI[NEI$SCC %in% coalscc,]

## Calculate total emissions per year
pmcoal<-with(coalnei,tapply(Emissions,year,sum))
pmcoal<-pmcoal/10^3

## Open png device
png("plot4.png")
barplot(pmcoal,names.arg = names(pmcoal), main = "Total emissions in US from coal combustion sources",
        ylab = "Emissions (in thousand tons)", xlab = "Years",ylim = c(0,600))

## Close device
dev.off()
