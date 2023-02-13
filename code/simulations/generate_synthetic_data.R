############### GENERATING FUNCTION #####

generate_synthetic_data <- function(n_c=c(10,10), rho_c=c(0.1, 0.9), sigma2_c=c(0.02,0.01),
                                    sigma2_eps=0.0001, alpha=c(0, 0, 0, 0), T=52, seed=1){

  set.seed(seed)
  
  ############### INITIALIZATION #####
  
  # Alpha and Sigma2 (noise) equal for each time series
  sigma2_eps <- rep(sigma2_eps, sum(n_c))
  alpha <- matrix(rep(alpha,sum(n_c)),ncol=length(alpha),byrow=TRUE)
  
  deg <- 2
  DM <- designmatrices(deg,T,52,2,12)
  
  Z <- DM$Z
  n <- sum(n_c) # Number of time series
  p <- DM$p
  
  # One row for each time series
  y <- matrix(NA, nrow=n, ncol=T)
  theta <- matrix(NA, nrow=n, ncol=T)
  
  
  ############### SYNTHETIC DATA BUILDING #####
  
  # i is the index of the cluster
  # j is the index of the time series in the cluster
  # k is the index of the time series
  
  for(i in 1:length(n_c)){
    
    # Building of R matrix (same for each time series in the cluster)
    R = matrix(NA, nrow=T, ncol=T)
    for(l in 1:T){
      for(s in 1:T){
        R[l, s] = sigma2_c[i]*rho_c[i]^abs(l-s)
      }
    }
    
    for(j in 1:n_c[i]){
      k <- sum(n_c[1:i])-n_c[i] + j
      theta[k,] <- mvrnorm(n=1, mu=rep(0,T), Sigma=R)
      y[k,] <- mvrnorm(n=1, mu=Z%*%alpha[k,]+theta[k,], Sigma=sigma2_eps[k]*diag(T))
    }
  }
  
  
  ############### SAVE DATA #####
  
  # Random coordinates (only for graphic purpose)
  randomX <- array(0,n)
  randomY <- array(0,n)
  for(j in 1:length(n_c)){
    ind = ifelse(j==1,1, sum(n_c[1:(j-1)])+1 ) : (sum(n_c[1:j]))
    randomX[ind] <- runif(n_c[j], j, j+1)
    randomY[ind] <- runif(n_c[j], j, j+1)
  }
  
  data <- data.frame(t(y))
  coord <- data.frame(x=randomX,y=randomY)
  labels <- data.frame(rep(1:length(n_c), n_c))
  
  return(list(data=data, labels=rep(1:length(n_c), n_c), coord=coord,
              theta=t(theta), alpha=t(alpha), sig2eps=sigma2_eps,
              sig2the=rep(sigma2_c, n_c), rho=rep(rho_c, n_c)))
  
}

