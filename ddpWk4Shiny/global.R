
perfm.data <- read.csv("./data/perfmdata.csv", header=TRUE, sep=",", stringsAsFactors=FALSE)
perfm.data <- perfm.data[,c('appTime', 'cslTime', 'Date')]
perfm.data$Date <- as.Date(perfm.data$Date)
perfm.date <- c(min(perfm.data$Date), max(perfm.data$Date))
perfm.appTarget <- 2.5; perfm.cslTarget <- 1200
