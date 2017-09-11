getGenes <- function(n,ranges) {
  #n - name of dataframe
  #ranges - dataframe with ranges
  w1 <- with(n, IRanges(X.P1.,width=1))
  w2 <- with(ranges, IRanges(start,end))
  olaps <- findOverlaps(w1,w2)
  n1 <- n[queryHits(olaps),]
  return(n1)
} 