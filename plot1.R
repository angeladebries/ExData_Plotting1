#---------------------------------------------------------------
#This R script is for plot 1. The plot will be made using ggplot.
#---------------------------------------------------------------

#remove all variables  
rm(list = ls())

#install and load required packages
install.packages("tidyverse")
library(tidyverse)

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
data1<-dplyr::tbl_df((read.csv2(file, header=TRUE, dec=".", strip.white=TRUE, stringsAsFactors = FALSE)))%>%
  dplyr::filter(Date %in% c("1/2/2007", "2/2/2007"))%>%
  print()

#inspect the data frame
head(data1)
#View(data1)

#check the class for each column
sapply(data1, class)

#convert "Global_active_power" to class "numeric"
data1$Global_active_power<-as.numeric(data1$Global_active_power)

#look at the data1 set
View(data1)

#2. Make the plot with ggplot
#----------------------------

#specify the size of the png
png(filename="plot1.png", height=480, width=480)

#plot the first chart using ggplot
ggplot(data1, aes(x=Global_active_power))+
  geom_histogram(bins = 18, color="black", fill="red")+
  labs(title="Global Active Power", y="Frequency", x="Global Active Power (kilowatts)")+
  scale_y_continuous(breaks = seq(0, 1200, 200))+
  theme_classic()

#this saves png in the directory defined above
dev.off()
