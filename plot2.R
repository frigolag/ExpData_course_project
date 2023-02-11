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

## Plot 2
## Calculate total emissions in Baltimore City per year
bc<-NEI[NEI$fips=="24510",]
pmbc<-with(bc,tapply(Emissions,year,sum,na.rm = TRUE))

## Open png device
png("plot2.png")
## Generate plot
plot(names(pmbc),pmbc,type = "o", main = "Total emissions in Baltimore City",
     ylab = "Emissions (in tons)", xlab = "Years",
     ylim = c(1500,3500), xaxt= "n")
axis(1,at=names(pmbc))
## Close device
dev.off()
