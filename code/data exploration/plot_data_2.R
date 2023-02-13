#reading the file
pollutant = read.csv('code/data/timeSeriesData.csv')
stat_inf = read.csv('code/data/stationsInfo.csv')


N = dim(pollutant)[1] #time instants
R = dim(pollutant)[2] #stations
YEARS = 7

#let's create one dataframe per year: (USEREI GLI ULTIMI 3 ANNI x data expl)
poll13 = pollutant[1:365,]
poll14 = pollutant[366:730,]
poll15 = pollutant[731:1095,]
poll16 = pollutant[1096:1460,]
poll17 = pollutant[1461:1825,]
poll18 = pollutant[1826:2190,]
poll19 = pollutant[2191:2555,]



#mean level of pm10 for every station (USELESS)
meanvalues_tot = colMeans(pollutant)
#boxplot
boxplot(meanvalues_tot)
#histogram
hist(meanvalues_tot)



##### considering only one year #####
poll = poll19 #cambia qui a seconda dell'anno che vuoi usare

#mean level of pm10 for every station (along 1 y)
meanval = colMeans(poll)

#histogram
max_annual_val = 40 #max level allowed for the annual mean
hist(meanval, main = "Mean concentration of PM10 (2019)", xlab = 'concentration of PM10 (?g/m^3)', ylab='n. of stations', xlim=c(0,50), ylim=c(0,50))
abline(v=max_annual_val, col='red')

#how many stations over the annual limit?
sum(meanval > max_annual_val)


#how many days above the daily limit?
max_daily_val = 50 #critic daily level 
max_dang_days = 35

n_dang_days = colSums(poll>max_daily_val) #stores for every station the num of "dangerous" days
hist(n_dang_days, breaks = 20, main='Days above the limit per station (2019)', xlab='n. of days above the limit', ylab='n. of stations', xlim=c(0,125), ylim=c(0,35)) #hist of the stations divided for the number of dangerous days
abline(v=max_dang_days, col='red')


#how many stations have too many dangerous days?
sum(n_dang_days >= max_dang_days)




############### plot delle stazioni ###############
library(shiny)
library(shinythemes)
library(leaflet)


#1) map for the stations that exceeded the annual threshold
map <- leaflet() %>% addProviderTiles(providers$Stamen.TonerLite,
                                      options = providerTileOptions(noWrap = TRUE))

col_dot <- vector(mode="character", length=R)

for (i in c(1:R)){
  if (meanval[i] > max_annual_val) {
    col_dot[i]='red'
  } else {
    col_dot[i]='green'
  }
}

map%>%
  addCircleMarkers(stat_inf$longitude,stat_inf$latitude, 
                   color = col_dot,
                   radius = 2
                   )



#2) map for the stations that exceeded the limit of dangerous days
map <- leaflet() %>% addProviderTiles(providers$Stamen.TonerLite,
                                      options = providerTileOptions(noWrap = TRUE)
)

col_dot <- vector(mode="character", length=R)

for (i in c(1:R)){
  if (n_dang_days[i] >= max_dang_days) {
    col_dot[i]='red'
  } else {
    col_dot[i]='green'
  }
}

map%>%
  addCircleMarkers(stat_inf$longitude,stat_inf$latitude, 
                   color = col_dot,
                   radius = 2
  )









##### MATPLOTS #####

#PLOT1: all the station throughout all years ---> (super ugly)
matplot(pollutant,type='l',xlab='Time',ylab='PM10')

#PLOT2: all the station in 2019 --->(troppo visibili le stazioni piene di ex NA)
days= seq(as.Date("2019-01-01"), as.Date("2019-12-31"), by="days")
matplot(days,poll19,type='l',xlab='Time',ylab='PM10')

#PLOT3: plot 10 random station (2019) ---> 
set.seed(5) #risetta il seed ogni volta che riesegui! (lascia 5)
rand_st <- sample(1:R, 10)
matplot(days,poll19[,rand_st],type='l',xlab='Time',ylab='PM10 (?g/m^3)', main="timeseries of 10 stations (2019)")

# Average values per day per year
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
matplot(days,avg_per_y,type='l',xlab='Time',ylab='PM10 (?g/m^3)', main='average concentration of PM10 per day')


#PLOT7: mean of 2017,2018,2019 -> useful, but we have to match the weeks
matplot(days, avg_per_y[,c(5:7)],col=c(2,3,4),type='l',xlab='Time',ylab='PM10 (?g/m^3)', main='average concentration of PM10 per day')
legend('topright',legend=c('2017','2018','2019'),col=c(2,3,4),lty=1:3, cex=0.5)
#NB non si pu? usare come pretesto per il trend settimanale perch? le settimane sono diverse



##### Seasonal trends: winter vs summer

# Average values per day of the year (taking into account the day of the week)

a = rep(0,364)
for(i in 1:364){
  tmp = c()
  for(j in 0:(YEARS-1))
    if(!is.na(daily.avg[i+j*364]))
      tmp = c(tmp, daily.avg[i+j*364])
  a[i] = mean(tmp)
}

days= seq(as.Date("2019-01-01"), as.Date("2019-12-30"), by="days")
plot(x=days, y=a, type='l', xlab='Day', ylab='pm10')



##### Weekly trends (the one has to define the summer period w.r.t. the number of weeks)
DAYS = 7
winter = rep(0, DAYS)
summer = rep(0, DAYS)

for(d in 1:DAYS){
  winter_tmp = c()
  summer_tmp = c()
  for(w in 1:(52*YEARS)){
    pm10 = daily.avg[(w-1)*DAYS+d]
    if(w%%52 > 10 && w%%52 < 52-12)       # Summer from the half of March to September
      summer_tmp = c(summer_tmp, pm10)
    else
      winter_tmp = c(winter_tmp, pm10)
  }
  winter[d] = mean(winter_tmp, na.rm=T)
  summer[d] = mean(summer_tmp, na.rm=T)
}

# 2013 begins with Tuesday
winter = c(winter[DAYS], winter[1:(DAYS-1)])
summer = c(summer[DAYS], summer[1:(DAYS-1)])

days = c('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun')

x11()
par(mfrow=c(2,1))
plot(winter, type='l', xlab='Day', ylab='pm10', main='Winter trend')
plot(summer, type='l', xlab='Day', ylab='pm10', main='Summer trend')






### MAP for rho

#arima
rho <- c()
eps <- c()
for(r in 1:N){
  a = arima(as.numeric(pollutant[,r]), order=c(1,0,0))
  rho[r] = as.numeric(a$coef[1])
  eps[r] = sqrt(as.numeric(a$sigma2))
  
}

plotData <- data.frame(site=stat_inf$site,rho=rho,eps=eps,
                       latitude=stat_inf$latitude,longitude=stat_inf$longitude)


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

#----
pal <- colorNumeric(
  palette = colorRampPalette(c('green','yellow', 'red'))(length(plotData$rho)), 
  domain = plotData$eps)

map <- leaflet() %>% addProviderTiles(providers$Stamen.TonerLite,
                                      options = providerTileOptions(noWrap = TRUE)
)
map%>%
  addCircleMarkers(plotData$longitude,plotData$latitude, 
                   color = pal(plotData$eps),
                   #color = pal(plotData$rho),
                   radius = 2, 
                   label = plotData$rho, 
                   labelOptions = labelOptions(textsize = "12px"),
                   popup = plotData$site_type
                   
                   # )%>% addLegend('topright',
                   #                pal = pal, 
                   #                values = seq(from = 0, to = 1, by = 0.01))
                   
  )%>% addLegend('topright',
                 pal = pal,
                 values = plotData$rho)

