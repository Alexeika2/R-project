require(ape)
require(GenomicRanges)
require(IRanges)

#Подключение пользовательских ф-ций
source("read.ptt.R")
source("getGenes.R")
source("strsplit2.R")
source("dist_matr.R")

#Заносим файлы в список(путь нужно подставить свой)
filenames <- list.files(path="Downloads/snpdata/",pattern = "*.snps") #Занесем в лист наши snps файлы
names_snps <- substr(filenames,1,20)
for (i in names_snps) {
  filepath <- file.path("Downloads/snpdata/", paste(i,"snps",sep = ""))
  assign(i,read.table(filepath, skip = 3, header = TRUE))
}
list_snps <- mget(ls(pattern = 'NC_.*delta'))

#Удаляем вставки/делеции
dfList<-lapply(list_snps, function(df) { subset(df,!(X.SUB. == '.' | X.SUB..1 == '.')) } ) 

#Функция была взята и переписана с пакета genomes2,
#который не поддерживается в данной версии R
#Считываем аннотацию(нужен пакет GenomicRanges)
NC_ann <- read.ptt("Downloads/snpdata/NC_000962.ptt")

#Создаем датафрэйм с ranges где содержаться гены
ranges <- as.data.frame(NC_ann@ranges)

#Удаляем NA
ranges <- na.omit(ranges)

#Применяем ф-цию getGenes(нужен IRanges)
dfList <- lapply(dfList,getGenes,ranges)

#Распаковываем dataframes
list2env(dfList,environment())

#Подсчет дистанционной матрицы с помощью ф-ции dist_matr
#Расстояние между геномами - Количество позиций в которых геном имеет отличие первого типа
distanceMatr <- dist_matr(dfList)

#Построение филогенетического дерева
tree_phylo <- nj(distanceMatr)
plot(tree_phylo, use.edge.length = F)

#P.S
#Данная задача решена не слишком корректно, есть ряд исправлений, которые хотелось бы исправить, 

