source("code/algorithm/designmatrices.R")


# Given some synthetic data n_samples from the posterior of sig2eps are generated
# A histogram of the requested station will be plotted

debug_sig2eps <- function(synthetic, plot_station, n_samples){
  
  data = synthetic$data
  T = dim(data)[1]
  
  rho <-     synthetic$rho
  sig2the <- synthetic$sig2the
  alpha <-   synthetic$alpha

  c0eps=2
  c1eps=1

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
  
  sig2epssample <- matrix(0, n_samples, n)
  
  for(k in 1:n_samples){
    M <- t(mydata - Z%*%synthetic$alpha - synthetic$theta) %*%
      (mydata - Z%*%synthetic$alpha - synthetic$theta)
    sig2eps <- 1/rgamma(n,(c0eps + T/2),(c1eps + diag(M)/2))
    sig2epssample[k,] <- sig2eps
  }
  
  
  ############### HISTOGRAMS #####
  
  prior_mean = c1eps/(c0eps-1)
  
  hist(sig2epssample[,plot_station],
       xlab=paste("Sig2Eps, real value = ", round(synthetic$sig2eps[plot_station], digits=3), "\n",
                  "Prior Mean: ", round(prior_mean, digits=3)),
       ylab= paste("Samples=", n_samples),
       main=paste("Sig2Eps: Station", plot_station))

}


