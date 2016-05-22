# total emissions in Baltimore City in years 1999 and 2008

library(dplyr)

# read files
NEI <- readRDS("data/summarySCC_PM25.rds")

# calculate totals
Baltimore <- subset(NEI, fips == "24510")
Baltimore_DT <- tbl_dt(Baltimore)
totals <- Baltimore_DT %>% group_by(year) %>% summarize(emissions_total = sum(Emissions))

# plot
with(totals, plot(year, emissions_total, xlab = "Year", ylab = "Emissions (tons)", 
                  main = "Total PM[2.5] emission in Baltimore City", pch = 19, col = "red", axes = FALSE))
lines(totals, col = "blue")
axis(2)
axis(side = 1, at= seq(1999, 2008, by = 3))
box()

dev.copy(png, file = "plot2.png", width = 480, height = 480)
dev.off()
