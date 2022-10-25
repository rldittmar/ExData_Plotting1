# Prepare data and environment
set.seed(215)
setwd("./R/Coursera/exploratory_data_analysis/Week_1/")
library("lubridate")
library("dplyr")

# Download and tidy data

## Download and save data to working directory.

filename <- "exdata_data_household_power_consumption.zip"

## Checking if folder exists; then, unzip it
if (!file.exists("household_power_consumption")) { 
        unzip(filename) 
}

## Read in file
hcp_keep <- read.table(file = "household_power_consumption.txt", col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage","Global_intensity","Sub_metering_1","Sub_metering_2", "Sub_metering_3"), sep = ";", skip = 1)

hcp <- hcp_keep
dim(hcp) # dimensions should be 2075259 x 9


## Date and time are character strings and must be date and time, respectively

hcp$Date <- dmy(hcp$Date)
hcp$Time <- hms(hcp$Time)

hcp$date.time <- hcp$Date + hcp$Time

hcp <- hcp %>% relocate(date.time, .before = Global_active_power)


# Question mark used in lieu of NA. Replace question marks with NA
# Investigate how many question marks there are
sum(hcp[,4:9] == "?")

# Column 10 does not have question marks - it is a numerical value already, so we can ignore that
# Replace ? with NA
index <- hcp[,4:9] == "?"
is.na(hcp[,4:9]) <- index
sum(hcp[,4:9] == "?")


# Subset to only use data from 2007-02-01 and 2007-02-02.
mydates <- hcp %>%
        filter(Date == "2007-02-01" | Date == "2007-02-02")
dim(mydates)
head(mydates)

mydates$Global_active_power <- as.numeric(mydates$Global_active_power)
mydates$Global_reactive_power <- as.numeric(mydates$Global_reactive_power)
mydates$Voltage <- as.numeric(mydates$Voltage)
mydates$Global_intensity <- as.numeric(mydates$Global_intensity)
mydates$Sub_metering_1 <- as.numeric(mydates$Sub_metering_1)
mydates$Sub_metering_2 <- as.numeric(mydates$Sub_metering_2)
mydates$Sub_metering_3 <- as.numeric(mydates$Sub_metering_3)


# Plot 3
png(file = "plot3.png", width = 480, height = 480, units = "px")
with(mydates, plot(date.time,Sub_metering_1, type="l", col = "black", xlab = "", ylab = "Energy sub metering"))
with(mydates, lines(date.time,Sub_metering_2, type="l", col = "red"))
with(mydates, lines(date.time,Sub_metering_3, type="l", col = "blue"))
legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black","red","blue"), lty = 1)
dev.off()