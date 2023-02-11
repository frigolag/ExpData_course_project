percentofchange <- function(x){
  p<-vector(mode = "numeric",length = length(x))
  for (i in 1:3){
    p[i+1]<-(x[i+1]/x[i])-1
  }
  return(p)
  }
