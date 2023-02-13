

############### DISTANCE FUNCTION  #####
# IN:
# clustering1 is the real clustering
# memorygn is the sampled clustering structure
# c1 is the price to pay when two observations belong to different clusters
#    in the real clustering but they are classified as equal
# c1 is the price to pay when two observations belong to the same cluster
#    in the real clustering but they are classified as different
#
# Usually we set c2 higher in order to avoid too many clusters
#
# OUT:
# gnstar clustering structure that minimizes binder loss function
# index iteration in which the binder loss function is minimized
# mincost value of the binder loss function at the iteration in which the binder loss function is minimized

binderfunction <- function(clustering1, memorygn, c1=1, c2=1){
  cost <- matrix(0,1,dim(memorygn)[1])
  for(k in 1:(dim(memorygn)[1])){
    clustering2 <- memorygn[k,]
    if(length(clustering1)!=length(clustering2) || length(clustering1)<2){
      message("Clusterings must have the same size and we need at least two observations")
    }
    n <- length(clustering1)
    cost_tmp <- 0
    for(i in 2:n){
      for(j in 1:(i-1)){
        if(clustering1[i]!=clustering1[j] && clustering2[i]==clustering2[j])
          cost_tmp <- cost_tmp + c1
        if(clustering1[i]==clustering1[j] && clustering2[i]!=clustering2[j])
          cost_tmp <- cost_tmp + c2
      }
    }
    cost[k] <- cost_tmp/choose(n,2)
  }
  index <- which.min(cost)
  mincost <- cost[index]
  gnstar <- memorygn[index,]
  return(list(gnstar=gnstar,index=index,mincost=mincost))
}


