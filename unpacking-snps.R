filenames<-list.files(path="C:/Users/Алексей/Documents/data/",pattern="*.snps") # Указываем где храниться наши файлы с расширением snps.
names<-substr(filenames,1,20) #Обрезаем расширение файла
for (i in names) {
  filepath<-file.path("C:/Users/Алексей/Documents/data/",paste(i,"snps",sep=""))  #Назначаем наш путь до файлов
  assign(i,read.table(filepath,header=TRUE))  #Считываем наши snps файлы и даем им имена согласно нашим файлам
}
list<-mget(ls(pattern='NC_.*delta')) #Создаем лист с нашими данными.
dfList<-lapply(list, function(df) { subset(df,!(X.SUB.=='.' | X.SUB..1=='.')) } ) #Убираем делеции "."
list2env(dfList,environment()) #Распаковываем наш лист в данные с теми же названиями.
