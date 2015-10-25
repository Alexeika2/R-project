species.dt<-read.delim("C://Users/Алексей/Documents/spec_dt.txt",header=TRUE) #Считываем файл txt
species.dt<-species.dt[ order(species.dt$species,species.dt$value),] #cортируем по value и species
species.dt$rank<-ave(species.dt$value,species.dt$species,FUN=rank) #используем ave и rank
