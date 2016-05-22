# total emissions in the US (1999-2008) for coal combustion sources
library(dplyr)

# read files
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

# Coal Combustion sources:
# concatenate all descriptions
# find the ones which contain word Comb and word Coal
Comb <- SCC[ grep("Comb", paste(SCC$Short.Name, SCC$EI.Sector, SCC$SCC.Level.One, SCC$SCC.Level.Two, SCC$SCC.Level.Three, SCC$SCC.Level.Four)) ,]
Coal_Comb <- Comb[grep("Coal", paste(Comb$Short.Name, Comb$EI.Sector, Comb$SCC.Level.One, Comb$SCC.Level.Two, Comb$SCC.Level.Three, Comb$SCC.Level.Four)),]

# merge both datasets only relevant records will be extarcted
Coal_Comb_emission <- merge(NEI, Coal_Comb, by = "SCC")

# calculate totals
Coal_Comb_emission_dt <- tbl_df(Coal_Comb_emission)
totals <- Coal_Comb_emission_dt %>% group_by(year) %>% summarize(emissions_total = sum(Emissions)/1000)

# plot
with(totals, plot(year, emissions_total, xlab = "Year", ylab = "Emissions (thousands tons)", 
                  main = "Total PM2.5 Emission from Coal Combustion Related Sources ", pch = 19, col = "red", axes = FALSE))
lines(totals, col = "blue")
axis(2)
axis(side = 1, at= seq(1999, 2008, by = 3))
box()


# save plot
dev.copy(png, file = "plot4.png", width = 480, height = 480)
dev.off()

