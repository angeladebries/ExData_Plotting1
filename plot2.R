#---------------------------------------------------------------
#This R script is for plot 2. The plot will be made using ggplot.
#---------------------------------------------------------------

#remove all variables  
rm(list = ls())

#install and load required packages
install.packages("tidyverse")
library(tidyverse)
install.packages("lubridate")
library(lubridate)

#Create a directory called "C:\Temp" on your computer

#set the working directory
setwd("C:/Temp")

#1. Download the file and read in R
#-----------------------------------

#define the download file and store in a variable
dest_file<-"C:/Temp/Coursera.zip"

#download zip to the destination file location
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", dest_file)

#unzip the file
file<-unzip(dest_file, "household_power_consumption.txt")

#import/read the data for 1st and 2nd Feb 2007
data2<-dplyr::tbl_df((read.csv2(file, header=TRUE, dec=".", strip.white=TRUE, stringsAsFactors = FALSE)))%>%
  dplyr::filter(Date %in% c("1/2/2007", "2/2/2007"))%>%
  print()

#inspect the data frame
head(data2)
#View(data2)

#check the class for each column
sapply(data2, class)

#convert "Global_active_power" to class "numeric"
data2$Global_active_power<-as.numeric(data2$Global_active_power)

#merge "Date" and "Time" column into one 
data2$DateTime<-paste(data2$Date, data2$Time, sep=" ")

#converte DateTime column to class Posixct
data2$DateTime<-lubridate::dmy_hms(data2$DateTime)

#2. Make the plot with ggplot
#----------------------------

#specify the size of the png
png("plot2.png", height=480, width=480)

#plot the second chart using ggplot
ggplot(data2, aes(x=DateTime, y=Global_active_power))+
  geom_line()+
  labs(y="Global Active Power (kilowatts)", x="")+
  scale_x_datetime(date_breaks="1 day", date_labels="%a")+
  theme_classic()

#this saves png in the directory defined above
dev.off()
