source("code/include_all.R")

### Code to reproduce figures in Synthetic chapter 


##### SYNTHETIC DATA BUILDING #####

s = generate_synthetic_data(n_c=c(2,2,2), rho_c=c(0.9, 0.9, 0.1),
                            sigma2_c=c(0.1,0.5,0.5), sigma2_eps=0.0001, alpha=c(0, 0, 0, 0), T=52)


par(mfrow=c(2,2))
matplot(s$data, type='l', col=unique(s$labels), xlab='t', ylab='y', lty=1, main='y')
for (j in 1:length(unique(s$labels))){
  matplot(s$data[,s$labels==j], type='l', col=j, xlab='t', ylab='y', lty=1, main=paste('Cluster ',j))
}


##### SYNTHETIC DATA BUILDING FOR POSTERIORS #####

s = generate_synthetic_data(n_c=c(15,15,15), rho_c=c(0.9, 0.9, 0.1),
                            sigma2_c=c(0.1,0.5,0.5), sigma2_eps=0.1, alpha=c(0, 0, 0, 1), T=52)


par(mfrow=c(ceiling((length(unique(s$labels))+1)/2),2))
matplot(s$data, type='l', col=unique(s$labels), xlab='t', ylab='y', lty=1, main='y')
for (j in 1:length(unique(s$labels))){
  matplot(s$data[,s$labels==j], type='l', col=j, xlab='t', ylab='y', lty=1, main=paste('Cluster ',j))
}


##### POSTERIOR SAMPLING #####

debug_alpha(s, 1, 4, 200)
debug_sig2eps(s, 1, 200)

##### TESTING #####

rho_c <- c(0.8,0.6,0.2) 
sigma2_c <- c(0.015,0.028,0.015)
synthetic = generate_synthetic_data(n_c=c(9,15,5), rho_c=rho_c, sigma2_c=sigma2_c,
                                    sigma2_eps=0.0001, alpha=c(0, 0, 0, 0), T=52)

data = synthetic$data
labels = synthetic$labels
coord = synthetic$coord
pb=progress_bar$new(total=300)
invisible(pb$tick(0))
tseriesc.out = tseriesclust(data, maxiter=300, thinning=1, scale=TRUE, a=17,b=0.3,ab=3,bb=3,seed=4)

jstar <- tseriesc.out$jstarsample
memory <- tseriesc.out$memorygn

real_cluster <- c(rep(1,9),rep(2,15),rep(3,5))
sample_clust <- binderfunction(real_cluster,memory)
gnstar <- sample_clust[[1]]
index <- sample_clust[[2]]

jstar[index,]
rho <- tseriesc.out$rhosample[index,]
sigma2 <- tseriesc.out$sig2thesample[index,]

plot(rho,sigma2,col=gnstar ,pch=19 ,xlim = c(0,1),ylim = c(0.01,0.035),xlab = 'Rho Sampled',ylab = 'Sigma2 Sampled')
points(rho_c,sigma2_c, col=c(1,2,3),pch=4 ,cex=2,lwd=4)

jf <- 3
set.seed(28) #just for the jittering
plot(jitter(rho,jf),jitter(sigma2,jf),col=real_cluster ,pch=19 ,xlim = c(0,1),ylim = c(0.01,0.035),xlab = 'Rho Jittered',ylab = 'Sigma2 Jittered')
points(rho_c,sigma2_c, col=c(1,2,3),pch=4 ,cex=2,lwd=4)

simm <- comp.psm(memory)
heatmap(as.matrix(simm))


