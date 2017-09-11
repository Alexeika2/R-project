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
species.dt <- read.delim("Downloads/task1/spec_dt.txt",header = T)

#Отсортируем датафрэйм
species.dt<-species.dt[ order(species.dt$species,species.dt$value),]

#Используем функцию ave и rank
species.dt$rank<-ave(species.dt$value,species.dt$species,FUN=rank)

#проверка
head(species.dt$rank[species.dt$species=="Neisseria subflava"])
head(species.dt$rank[species.dt$species=="Streptococcus pneumoniae"])
