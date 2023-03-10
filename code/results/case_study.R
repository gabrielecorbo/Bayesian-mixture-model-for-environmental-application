#### PROPOSED MODEL ####
source("code/include_all.R")

pollutant <- read.csv('code/data/pollutant.csv') 
stationInfo <- read.csv('code/data/stationsInfo.csv')
##get latitude and longitude
latitude <- c()
longitude <- c()
region <- c()
for (i in 1:dim(pollutant)[2]) {
  site <- colnames(pollutant)[i]
  latitude <- c(latitude,stationInfo$latitude[which(stationInfo$site==site)])
  longitude <- c(longitude,stationInfo$longitude[which(stationInfo$site==site)])
  region <- c(region,stationInfo$region[which(stationInfo$site==site)])
}

plot(longitude,latitude,pch=19,cex=0.9,xlab='Longitude',ylab='Latitude')
map("world",add=T)

pb=progress_bar$new(total=300)
invisible(pb$tick(0))
# estimated 90 minutes running time
#tseriesc.out <- tseriesclust(pollutant,maxiter=300,thinning=2,frequency = 365,seasonfreq = 2,seasondelay = 80)
#frequency = 365, seasonfreq = 2,seasondelay = 80 
#because we have daily data, two season (autumn/winter and spring/summer) and the spring starts the 80th day of the year



load("code/results/result_proposedmodel.RData")

gnstar <- as.numeric(salso(tseriesc.out$memorygn, maxNClusters=4, loss=VI(a=0.5), nRuns=50, nCores=2))
d <- dim(tseriesc.out$rhosample)[1]
rho <- tseriesc.out$rhosample[d,]
rho_m <- c()
for (i in 1:4) {
  rho_m <- c(rho_m, round(mean(rho[which(gnstar==i)]),2) ) 
}

plot(longitude,latitude,pch=19,cex=2,main = "Proposed model", xlab="", ylab="",col=gnstar)
legend('topleft',legend=rho_m,col=1:4,pch=19)
map("world",add=T)



#diagnostic plot
x <- 30:300                      #x is defined just for visual purposes
x <- x[which(x %% 2 == 0)]
x <- x[-1]                              
par(mfrow=c(2,1))
station <- 112
rhosample <- tseriesc.out$rhosample[,station]
plot(x,cumsum(rhosample)/1:d,type = "l",main = "Ergodic mean of rho ",xlab = "Iteration number",ylab = "",ylim=c(0.55,0.85))
acf(rhosample, main='Autocorrelation of rho')
gnstar[2]
par(mfrow=c(2,1))
station <- 102
rhosample <- tseriesc.out$rhosample[,station]
plot(x,cumsum(rhosample)/1:n,type = "l",main = "Ergodic mean of rho",xlab = "Iteration number",ylab = "",ylim=c(0.55,0.85))
acf(rhosample, main='Autocorrelation of rho')
gnstar[4]


#similarity matrix
simm <- comp.psm(tseriesc.out$memorygn)
heatmap(as.matrix(simm))


#histogram of number of groups
hist(tseriesc.out$msample, main="Distribution of the number of cluster",xlab = "Number of cluster")


#### STARTING MODEL ####

# estimated 90 minutes running time
#tseriesc.out.first <- tseriesclust_first(pollutant,maxiter=300,thinning=2,frequency = 365, seasonfreq = 2,seasondelay = 80)

#frequency = 365, seasonfreq = 2,seasondelay = 80 
#because we have daily data, two season (autumn/winter and spring/summer) and the spring starts the 80th day of the year

load("code/results/result_firstmodel.RData")

gnstar_f <- as.numeric(salso(tseriesc.out.first$memorygn, maxNClusters=4, loss=VI(a=0.5), nRuns=50, nCores=2))

plot(longitude,latitude,pch=19,cex=2,main = "First model", xlab="", ylab="",col=gnstar_f)
map("world",add=T)
