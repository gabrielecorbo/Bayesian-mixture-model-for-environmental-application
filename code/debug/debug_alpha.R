source("code/algorithm/designmatrices.R")


# Given some synthetic data n_samples from the posterior of alpha are generated
# A histogram of the requested station and component will be plotted

debug_alpha <- function(synthetic, plot_station, plot_component, n_samples){

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
  
  alphasample <- array(0,dim=c(n_samples,p,n)) 
  
  for(k in 1:n_samples){
    for(i in 1:n){
      sigmaeps <- diag(c(sig2eps[i]),T)
      Q <- sigmaeps + R[,,i]
      Qinv <- chol2inv(chol(Q))
      
      Valphainv <- (t(Z) %*% Qinv %*% Z) + invsigmaalpha
      Valpha <- chol2inv(chol(Valphainv))
      
      mualpha <- Valpha %*% t(Z) %*% Qinv %*% mydata[,i]
      
      alpha[,i] <- mvrnorm(1,mualpha,Valpha)
    }
    alphasample[k,,] <- alpha
  }
  
  hist(alphasample[,plot_component, plot_station],
       xlab=paste("Alpha, real value = ", round(synthetic$alpha[plot_component, plot_station], digits=3), "\n",
                  "Prior Mean:", 0),
       ylab= paste("Samples=", n_samples),
       main=paste("Alpha: Station", plot_station,", Comp",plot_component))
  
}


