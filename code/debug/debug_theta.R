source("code/algorithm/designmatrices.R")

# Given some synthetic data n_samples from the posterior of alpha are generated
# A histogram of the requested station at a certain time will be plotted

debug_theta <- function(synthetic, plot_station, plot_time, n_samples){
  
  data = synthetic$data
  T = dim(data)[1]
  
  sig2eps <- synthetic$sig2eps
  rho <-     synthetic$rho
  sig2the <- synthetic$sig2the
  
  mydata = as.matrix(data)
  #datascaled <- scaleandperiods(data,TRUE)
  #mydata <- as.matrix(datascaled$mydata)

  T <- nrow(mydata)
  n <- ncol(mydata)
  deg=2
  DM <- designmatrices(deg,T,52,2,12)
  p <- DM$p
  d <- DM$d
  Z <- DM$Z
  
  P <- array(0,dim=c(T,T,n))                    
  R <- array(0,dim=c(T,T,n))
  for(i in seq(n)){
    for (j in seq(T)){
      for (k in seq(T)){
        P[j,k,i] <- rho[i]^(abs(j-k))  
        R[j,k,i] <- sig2the[i]*P[j,k,i]
      }
    }
  }
  
  sig2alpha <- matrix(1,p,1)
  sigmaalpha <- diag(c(sig2alpha),p,p)
  invsigmaalpha <- diag(1/c(sig2alpha),p,p)
  
  alpha <-matrix(0,p,n)
  
  theta <- matrix(0,T,n)
  for(i in seq(n)){
    theta[,i] <- mvrnorm(1,matrix(0,T,1),R[,,i])
  }
  
  thetasample <- array(0,dim=c(n_samples,T,n)) 
  
  for(k in 1:n_samples){
    for(i in 1:n){
      invsigmaeps <- diag((1/sig2eps[i]),T)
      Rinv <- solve(R[,,i])     
      Sinv <- invsigmaeps + Rinv
      Stheta <- solve(Sinv)   #Stheta <- chol2inv(chol(Sinv))
      mutheta <- Stheta %*% invsigmaeps %*% (mydata[,i] - Z %*% alpha[,i])
      theta[,i] <- mvrnorm(1,mutheta,Stheta)
    }
    thetasample[k,,] <- theta
  }
  
  
  ############### HISTOGRAMS #####
  
  hist(thetasample[,plot_time, plot_station],
       xlab=paste("Theta, real value = ", round(synthetic$theta[plot_time, plot_station], digits=3),"\n",
                  "Prior Mean:", 0),
       ylab= paste("Samples=", n_samples),
       main=paste("Theta: Station", plot_station,", Time",plot_time))
  
}
      

