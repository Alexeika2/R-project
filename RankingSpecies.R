# Есть таблица следующего вида:
#   
  ## species feature value
  ## 1 Pseudomonas aeruginosa feature870273 107.899446
  ## 2 Streptococcus australis feature529226 123.277075
  ## 3 Achromobacter insolitus feature548221 76.162284
  ## 4 Staphylococcus xylosus feature833929 136.578399
  ## 5 Acinetobacter haemolyticus feature910144 126.397715
  ## 6 Lactobacillus delbrueckii feature585608 95.479815
# Для каждого признака(feature) проставить порядковый номер (rank) 
# его значения (value) в порядке возрастания значений. 
# Причем сделать это для каждого вида(species) отдельно.

#Считаем файл
require(data.table)
species.dt <- fread("Downloads/task1/spec_dt.txt",header = T)

#Используем функцию rank чтобы проставить порядковый номер
res <- species.dt[,rank := rank(value), by = species]

#Отсортируем датафрэйм
res <- res[ order(species, rank) ]
