#----------------------------
#This R script is for plot 4
#----------------------------

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
data4<-dplyr::tbl_df((read.csv2(file, header=TRUE, dec=".", strip.white=TRUE, stringsAsFactors = FALSE)))%>%
  dplyr::filter(Date %in% c("1/2/2007", "2/2/2007"))%>%
  print()

#inspect the data frame
head(data4)
#View(data4)

#check the class for each column
sapply(data4, class)

#merge "Date" and "Time" column into one 
data4$DateTime<-paste(data4$Date, data4$Time, sep=" ")

#converte DateTime column to class Posixct
data4$DateTime<-lubridate::dmy_hms(data4$DateTime)

#convert Voltage into class numeric
data4$Voltage<-as.numeric(data4$Voltage)

#convert Global_active_power into class numeric
data4$Global_active_power<-as.numeric(data4$Global_active_power)

#convert Global_reactive_power into class numeric
data4$Global_reactive_power<-as.numeric(data4$Global_reactive_power)

view(data4)
head(data4)
str(data4)

#2. Create top left chart
#------------------------
Chart_GAP<-ggplot(data4, aes(x=DateTime, y=Global_active_power))+
  geom_line()+
  labs(y="Global Active Power (kilowatts)", x="")+
  scale_x_datetime(date_breaks="1 day", date_labels="%a")+
  theme_classic()

Chart_GAP

#3. Create top right chart
#------------------------
Chart_Voltage<-ggplot(data4, aes(x=DateTime, y=Voltage))+
  geom_line()+
  labs(y="Voltage", x="datetime")+
  scale_x_datetime(date_breaks="1 day", date_labels="%a")+
  scale_y_continuous(breaks=seq(234, 246, 4))+
  theme_classic()

Chart_Voltage

#4. Create bottom left chart
#---------------------------
#convert the data.frame to a long format
data3a<-tidyr::gather(data4, "Label", "Value", -DateTime, -Date, -Time,
                     -Global_active_power, -Global_reactive_power, -Voltage, -Global_intensity)%>%
  print()

view(data3a)

#check the class for each column
sapply(data3a, class)

#convert Value to class numeric
data3a$Value<-as.numeric(data3a$Value)

#do the chart
Chart_ESM<-ggplot(data3a, aes(x=DateTime, y=Value, colour=Label))+
  geom_line()+
  labs(y="Energy sub metering", x="")+
  scale_x_datetime(date_breaks="1 day", date_labels="%a")+
  theme_classic()

Chart_ESM

#5. Create bottom right chart
#----------------------------
Chart_GRP<-ggplot(data4, aes(x=DateTime, y=Global_reactive_power))+
  geom_line()+
  labs(y="Global_reactive_power", x="datetime")+
  scale_x_datetime(date_breaks="1 day", date_labels="%a")+
  theme_classic()

Chart_GRP

#6. Combine all charts in one
#----------------------------
#load library
install.packages("ggpubr")
library(ggpubr)

#specify the size of the png
png("plot4.png", height=480, width=480)

#plot the fourth charts 
ggpubr::ggarrange(Chart_GAP, Chart_Voltage, Chart_ESM, Chart_GRP, ncol = 2, nrow = 2)

#this saves png in the directory defined above
dev.off()
