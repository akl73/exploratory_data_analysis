# total emissions in the US (1999-2008)
library(dplyr)

# read files
NEI <- readRDS("data/summarySCC_PM25.rds")

# calculate totals
NEI_DT <- tbl_df(NEI)
totals <- NEI_DT %>% group_by(year) %>% summarize(emissions_total = sum(Emissions)/1000000)

# plot
par(mfrow = c(1,1))
with(totals, plot(year, emissions_total, xlab = "Year", ylab = "Emissions (millions tons)", 
                  main = "Total PM[2.5] emission, all sources", pch = 19, col = "red", axes = FALSE))
lines(totals, col = "blue")
axis(2)
axis(side = 1, at= seq(1999, 2008, by = 3))
box()

# save plot
dev.copy(png, file = "plot1.png", width = 480, height = 480)
dev.off()
