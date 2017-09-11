dist_matr <- function(List) {
  #Функция для расчета дистанционной матрицы между геномами.
  #List - list with dataframes
  matr <- matrix(NA, nrow = length(List), ncol = length(List),dimnames = list(names(List),
                                                                          names(List)))
  for (i in 1:length(names(List))) {
    matr[i,1] <- sum(List[[i]][[1]] %in% List[[1]][[1]])
    for (j in 2:length(names(List))){
      matr[i,j] <- sum(List[[i]][[1]] %in% List[[j]][[1]])
  }
}
  diag(matr) <- 0 #Диагональные элементы матрицы равны нулю
  return(matr)
}