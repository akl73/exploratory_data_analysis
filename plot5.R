# total emissions in Baltimore City (1999-2008) - motor vehicles
library(dplyr)

# read files
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

# subset data - Baltimore
Baltimore <- subset(NEI, fips == "24510")

# Motor vehicle sources:
# EI.Sector starts with Mobile - Non-Road or Mobile - On-Road
all_vehicles <- SCC[grep("Mobile", SCC$EI.Sector),]
motor_vehicles <- all_vehicles[grep("-Road", all_vehicles$EI.Sector),]
# merge both datasets only relevant records will be extarcted
Balt_motor_veh <- merge(Baltimore, motor_vehicles, by = "SCC")

# calculate totals
Balt_motor_veh_dt <- tbl_df(Balt_motor_veh)
totals <- Balt_motor_veh_dt %>% group_by(year) %>% summarize(emissions_total = sum(Emissions))

# plot
with(totals, plot(year, emissions_total, xlab = "Year", ylab = "Emissions (tons)", 
                  main = "Total PM2.5 Emission from Motor Vehicle Sources in Baltimore ", pch = 19, col = "red", axes = FALSE))
lines(totals, col = "blue")
axis(2)
axis(side = 1, at= seq(1999, 2008, by = 3))
box()

# save plot
dev.copy(png, file = "plot5.png", width = 480, height = 480)
dev.off()


