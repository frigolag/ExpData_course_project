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
vehiclebc<-vehiclenei[vehiclenei$fips=="24510",]

## Calculate total emissions per year
pmmob<-with(vehiclebc,tapply(Emissions,year,sum))

## Open png device
png("plot5.png")
plot(names(pmmob),pmmob,type = "o", main = "Emissions from motor vehicle sources in Baltimore City",
     ylab = "Emissions (in tons)", xlab = "Years",ylim = c(0,420),
     xaxt= "n")
axis(1,at=names(pmmob))

## Close device
dev.off()
