designmatrices <- function(deg,T,frequency,seasonfreq,seasondelay,mod=TRUE){
    
  # Function that generates the design matrices of the clustering
  # algorithm based on the parameters that the user wants to consider,
  # i.e. level, polinomial trend and/or seasonal components. It also 
  # returns the number of parameters that are considered and not
  # considered for clustering. Since this function is for internal use,
  # its arguments are taken directly from the clustering functions.
  #
  # IN:
  #
  # deg         <- Degree of the polinomial trend of the model.
  # T           <- Number of periods of the time series.
  # frequency   <- Number that indicates the frequency of data in a
  #		     year, e.g. 12 means one value each month. 
  # seasonfreq  <- Number that indicates the frequency in a year of 
  #		     season component, e.g. 12 means we consider months
  #		     as seasonality 
  # seasondelay <- #after how many data begins the first season 
  #           (useful for example for dividing spring and summer from winter and autumn)
  #
  # OUT:
  #
  # Z <- Design matrix of the parameters not considered for clustering.
  # X <- Design matrix of the parameters considered for clustering.
  # p <- Number of parameters not considered for clustering.
  # d <- Number of parameters considered for clustering.
  
  
  M <- matrix(0,T,1+deg+(seasonfreq - 1)) # Matrix with all components.
  M[,1] <- 1                              # Level components.
  for(i in 1:deg){                        # Trend components.
    M[,i+1] <- seq(T)^i
  }
  
  # Seasonal components
  S <- matrix(0,T,(seasonfreq - 1))
  step <- frequency %/% seasonfreq
  num <- T %/% frequency
  
  if (num == 0){
    for (j in 1:(seasonfreq - 1)) {
      for (i in 1:step) {
        row <- i + step*(j-1) + seasondelay
        if (row <= T)
          S[ row ,j] <- 1
      }
    }
  }
  else{
    for (k in 1:num){
      for (j in 1:(seasonfreq - 1)) {
        for (i in 1:step) {
          S[ i + step*(j-1) + frequency*(k-1) + seasondelay ,j] <- 1
        }
      }
    }
    # Fill remainder
    for (j in 1:(seasonfreq - 1)) {
      for (i in 1:step) {
        row <- i + step*(j-1) + num*step*seasonfreq + seasondelay
        if (row <= T)
          S[ row ,j] <- 1
      }
    }
  }
  
  M[,((deg+2):(1+deg+(seasonfreq - 1)))] <- S          
  
  # Return values
  p <- 1+deg+(seasonfreq - 1)
  d <- 0
  Z <- as.matrix(M)
  X <- matrix(0,1,1)
  if (mod){
    return(list(p=p,d=d,Z=Z,X=X))
  }
  else{
    p <- 1
    d <- deg+(seasonfreq - 1)
    Z <- as.matrix(M[,1])
    X <- as.matrix(M[,(2:(1+deg+(seasonfreq - 1)))])
    return(list(p=p,d=d,Z=Z,X=X))
  }
  
}
