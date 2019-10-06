#---------------------------------------------------------------
#This R script is for plot 3. The plot will be made using ggplot.
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
data3<-dplyr::tbl_df((read.csv2(file, header=TRUE, dec=".", strip.white=TRUE, stringsAsFactors = FALSE)))%>%
  dplyr::filter(Date %in% c("1/2/2007", "2/2/2007"))%>%
  print()

#inspect the data frame
head(data3)
#View(data3)

#convert the data.frame to a long format
data3<-tidyr::gather(data3, "Label", "Value", -Date, -Time,
                     -Global_active_power, -Global_reactive_power, -Voltage, -Global_intensity)%>%
  print()
  
#check the class for each column
sapply(data3, class)

#merge "Date" and "Time" column into one 
data3$DateTime<-paste(data3$Date, data3$Time, sep=" ")

#converte DateTime column to class Posixct
data3$DateTime<-lubridate::dmy_hms(data3$DateTime)

#convert Value into class numeric
data3$Value<-as.numeric(data3$Value)

view(data3)
head(data3)

#2. Make the plot with ggplot
#----------------------------

#specify the size of the png
png("plot3.png", height=480, width=480)

#plot the third chart using ggplot
ggplot(data3, aes(x=DateTime, y=Value, colour=Label))+
  geom_line()+
  labs(y="Energy sub metering", x="")+
  scale_x_datetime(date_breaks="1 day", date_labels="%a")+
  theme_classic()

#this saves png in the directory defined above
dev.off()
