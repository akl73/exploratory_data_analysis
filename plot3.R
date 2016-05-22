# total emissions in Baltimore City in 1999 and 2008 by type

library(dplyr)
library(ggplot2)

# read files
NEI <- readRDS("data/summarySCC_PM25.rds")

# calculate totals
Baltimore <- subset(NEI, fips == "24510")
Baltimore$type <- as.factor(Baltimore$type)
Baltimore_DT <- tbl_dt(Baltimore)
totals <- Baltimore_DT %>% group_by(year, type) %>% summarize(emissions_total = sum(Emissions))

# plot
g <- ggplot(totals, aes(year, emissions_total))
g + scale_x_continuous(breaks = seq(1999, 2008, 3))+
    geom_point(aes(color = type), size = 3) + 
    facet_grid(.~type) + 
    geom_line(aes(color = type)) +
    ggtitle("Total emissions in Baltimore City in 1999 and 2008 by emission type") +
    labs( x= "Year", y = "Emissions (tons)") +
    theme_bw()


dev.copy(png, file = "plot3.png", width = 800, height = 480)
dev.off()
