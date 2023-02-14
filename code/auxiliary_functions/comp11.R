comp11 <-
function(y, iter=0, maxiter=-1){
  
  # Function that computes the distinct observations in a numeric vector.
  # It is based entirely on the "comp1" function from the BNPdensidty 
  # package with the exception that it returns the variable that 
  # rearranges the numeric vector into one with its unique values only. 
  # 
  # IN:
  # 
  # y <- numeric vector. 
  # iter <- current iteration.
  # maxiter <- number of total iterations.
  # 
  # OUT: 
  # 
  # jstar <- variable that rearranges "y" into a vector with its unique values. 
  # nstar <- frequency of each distinct observation in "y". 
  # rstar <- number of distinct observations in "y".
  # gn    <- variable that indicates the group number to which every entry in "y" belongs. 
  
  n <- length(y)
  mat <- outer(y, y, "==")
  jstar <- led <- rep(FALSE, n)
  
  i_g <- maxiter-iter
  g <- 15
  if(i_g<=0 || i_g>=g || n>100){
    for (j in seq(n)) {
      if (!led[j]) {
        jstar[j] <- TRUE
        if (j == n) 
          break
        ji <- seq(j + 1, n)
        tt <- mat[ji, j] %in% TRUE
        led[ji] <- led[ji] | tt
      }
      if (all(led[-seq(j)])) 
        break
    }
    
    ystar <- y[jstar]
    nstar <- apply(as.matrix(mat[, jstar]), 2, sum)
    rstar <- length(nstar)
    gn <- match(y, ystar)
    
    return(list(jstar = jstar, nstar = nstar, rstar = rstar, gn = gn))
  }
  
  
  #### Only for dubugging purpose####
  else{
    list_r <- check(g,i_g,n,y)
    return(list_r)
  }
}
