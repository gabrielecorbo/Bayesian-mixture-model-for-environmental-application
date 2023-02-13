loadData <- function(year){
  
  pollutant <- read.csv('Dati/newTimeSeriesData.csv')
  start <- (year-2013)*365+1
  end <- start + 364
  
  return(pollutant[start:end,])
  
}
