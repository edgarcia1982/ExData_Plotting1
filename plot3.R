# DOWNLOAD FILE.

##Create a folder to save the files.
if (!file.exists("Data")) {
        dir.create("Data", recursive = TRUE)
        cat("Folder created.")
} else {
        cat("The folder already exists.")
}

##Download and save file.
urlDATA <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(urlDATA, "./Data/exdata_data_household_power_consumption.zip")



# UNZIP FILE.

## Define the path to the zip file.
path_zip <- "./Data/exdata_data_household_power_consumption.zip"

## Load 'zip' package to work with zip files.
if (!requireNamespace("zip", quietly = TRUE)) {
        install.packages("zip")
}
library(zip)

## Extract the file from the zip to the "Data" folder.
path_unzip <- "./Data"
unzip(path_zip, exdir = path_unzip)
remove(list = ls())


# OPEN AND PREPARE FILE.

## Open file.
electric_power <- read.table("./Data/household_power_consumption.txt", header = TRUE, sep = ";", na.strings = "?")

## Transform Date variable into date class.
electric_power$Date <- as.Date(electric_power$Date, format = "%d/%m/%Y")
class(electric_power$Date) # Check class
head(electric_power$Date) # Check head

## Convert the "Time" column.
library(lubridate)
electric_power$Time <- as.POSIXct(paste(electric_power$Date, electric_power$Time), format = "%Y-%m-%d %H:%M:%S")
class(electric_power$Time) # Check class
head(electric_power$Time) # Check head

## Filter cases of interest.
library(dplyr)
filter_ep <- filter(electric_power, Date=="2007/02/01"| Date=="2007/02/02")
table(filter_ep$Date) # Check filter.



# CREATE PLOT.

## Set the output file and dimensions.
png(filename = "plot3.png", width = 480, height = 480)

## Change margins.
par(mar=c(2,4,1,1))

## Create plot.
with(filter_ep, plot(Time, Sub_metering_1, 
                     type = "l", 
                     xaxt = "n",
                     xlab = "",
                     ylab = "Energy sub metering",
                     cex.lab = 0.8,
                     cex.axis = 0.8))

## Add the lines for Sub_metering_2 and Sub_metering_3.
with(filter_ep, lines(Time, Sub_metering_2, type = "l", col = "red"))
with(filter_ep, lines(Time, Sub_metering_3, type = "l", col = "blue"))

## Define x-axis locations and labels.
x_locations <- as.POSIXct(c("2007-02-01 00:00:00 -02", "2007-02-02 00:00:00 -02", "2007-02-03 00:00:00 -02"))
x_labels <- c("Thu", "Fri", "Sat")

## Add labels on the x-axis.
axis(1, at = x_locations, labels = x_labels, cex.axis = 0.8)

## Add legend.
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lty = 1, cex = 0.8)

## Close the graphics device.
dev.off()