loadData <- function(year){
  
  pollutant <- read.csv('code/data/timeSeriesData.csv')
  start <- (year-2013)*365+1
  end <- start + 364
  
  return(pollutant[start:end,])
  
}

day_above_limit <- function(year){
  poll <- loadData(year)
  max_daily_val = 50 #critic daily level 
  max_dang_days = 35
  
  #stores for every station the num of "dangerous" days
  n_dang_days = colSums(poll>max_daily_val) 
  
  #hist of the stations divided for the number of dangerous days
  hist(n_dang_days, breaks = 20, main=paste('Days above the limit per station (',year,')',sep=''), 
       xlab='n. of days above the limit', ylab='n. of stations', xlim=c(0,125), ylim=c(0,35)) 
  abline(v=max_dang_days, col='red')
}

matplot1 <- function(){
  poll <- loadData(2019)
  set.seed(5)
  rand_st <- sample(1:dim(poll)[2], 10)
  days= seq(as.Date("2019-01-01"), as.Date("2019-12-31"), by="days")
  matplot(days,poll[,rand_st],type='l',xlab='Time',ylab='PM10 (µg/m^3)', main="Timeseries of 10 stations (2019)")
  
}

matplot2 <- function(){
  
  pollutant <- read.csv('code/data/timeSeriesData.csv')
  N = dim(pollutant)[1] #time instants
  YEARS <- 7
  
  daily.avg = rep(0,N) #Mean in the day if there is at least one valid value
  for(i in 1:N){
    daily.avg[i] = mean(as.numeric(pollutant[i,]), na.rm=T)
  }
  
  avg_per_y = matrix(NA, nrow = 365, ncol = YEARS)
  
  for (y in 1:YEARS){
    avg = rep(0,365)
    for(d in 1:365){
      i = (y-1)*365 + d
      avg_per_y[d,y] = daily.avg[i]
    }
  }
  
  days= seq(as.Date("2019-01-01"), as.Date("2019-12-31"), by="days")
  matplot(days,avg_per_y,type='l',xlab='Time',ylab='PM10 (µg/m^3)', main='Average concentration of PM10 per day',col=1:YEARS,lty=1)
  legend('topright',legend=2013:(2013+YEARS-1),col=1:YEARS,lty=1, cex=0.8)
}

arima_model <- function(){
  pollutant <- read.csv('code/data/timeSeriesData.csv')
  #arima
  rho <- c()
  sigma <- c()
  for(r in 1:dim(pollutant)[2]){
    a = arima(as.numeric(pollutant[,r]), order=c(1,0,0))
    rho[r] = as.numeric(a$coef[1])
    sigma[r] = sqrt(as.numeric(a$sigma2))
    
  }
  return(list(rho=rho,sigma=sigma))
}


plot_rho <- function(rho){
  stat_inf <- read.csv('code/data/stationsInfo.csv')
  sigma <- rep(NaN,length(rho))
  plotData <- data.frame(site=stat_inf$site,rho=rho,sigma=sigma,
                         latitude=stat_inf$latitude,longitude=stat_inf$longitude)
  
  #plot on the map
  pal <- colorNumeric(
    palette = colorRampPalette(c('green', 'yellow', 'red'))(length(plotData$rho)), 
    domain = plotData$rho)
  
  
  map <- leaflet() %>% addProviderTiles(providers$Stamen.TonerLite,
                                        options = providerTileOptions(noWrap = TRUE)
  )
  map%>%
    addCircleMarkers(plotData$longitude,plotData$latitude, 
                     color = pal(plotData$rho),
                     radius = 2, 
                     label = plotData$rho, 
                     labelOptions = labelOptions(textsize = "12px"),
                     popup = plotData$site_type
    )%>% addLegend('topright',
                   pal = pal,
                   values = plotData$rho)
}