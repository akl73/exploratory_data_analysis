# total emissions in Baltimore City and Los Angeles County (1999-2008) - motor vehicles
library(dplyr)

# read files
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

# subset data - Baltimore
Baltimore <- subset(NEI, fips == "24510")
Los_Angeles <- subset(NEI, fips == "06037")

# Motor vehicle sources:
# EI.Sector starts with Mobile - Non-Road or Mobile - On-Road
all_vehicles <- SCC[grep("Mobile", SCC$EI.Sector),]
motor_vehicles <- all_vehicles[grep("-Road", all_vehicles$EI.Sector),]
# merge both datasets only relevant records will be extarcted
Balt_motor_veh <- merge(Baltimore, motor_vehicles, by = "SCC")
LA_motor_veh <- merge(Los_Angeles, motor_vehicles, by = "SCC")

# calculate totals
Balt_motor_veh_dt <- tbl_df(Balt_motor_veh)
Balt_totals<- Balt_motor_veh_dt %>% group_by(year) %>% summarize(emissions_total = sum(Emissions))
LA_motor_veh_dt <- tbl_df(LA_motor_veh)
LA_totals<- LA_motor_veh_dt %>% group_by(year) %>% summarize(emissions_total = sum(Emissions))
totals <- rbind(Balt_totals,LA_totals)

# plot
g <- ggplot(totals, aes(year, emissions_total))
g + geom_point(aes(color = type)) + 
    geom_line(aes(color = type)) +
    ggtitle("Total emissions in Baltimore City in 1999 and 2008 by emission type") +
    labs( x= "Year", y = "Emissions (tons)") +
    theme_bw()

# save plot
dev.copy(png, file = "plot6.png", width = 600, height = 480)
dev.off()


