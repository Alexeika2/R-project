
#Расчет недель начиная от первой даты наблюдения.
#Сначала посчитать разницу между датами и датой рождения(и отсортировать а потом применять скрипт)
library(msm)

ID <- unique(subs_df_semi[,1]) #Получение уникальных ID пациента
subs_df_semi1 <- NULL #Пустой фрейм
for (id in ID) {
  aux1 <- subs_df_semi[subs_df_semi[,1]==id,6]
  aux1 <- aux1[1]
  df1_w[subs_df_semi[,1]==id,6] <- subs_df_semi[subs_df_semi[,1]==id,6]-aux1
  aux <- sum(subs_df_semi[,1]==id)
  if(aux>1) {
    #Удаление записей с единственным наблюдением.
    subs_df_semi1 <- rbind(subs_df_semi1,subs_df_semi[subs_df_semi[,1]==id,])
  }
}

#Общее количество переходов между состояниями
statetable.msm(state, ID, data=subs_df_semi1)

#Матрица интенсивностей перехода
qmatr1 <- rbind(c(0, 0.25, 0.25, 0.25), c(0.34, 0, 0.25, 0.34),
              c(0.1, 0.25, 0, 0.25), c(0, 0, 0, 0))
Q.crude <- crudeinits.msm(state~weeks,subject = ID, qmatrix=qmatr1)

#Матрица ошибок для модели с ошибкой классификации
ematr1 <- rbind(c(0, 0.4, 0.3, 0),
                c(0.2, 0, 0.4, 0),
                c(0.4, 0.5, 0, 0),
                c(0, 0, 0, 0))

#Расчет многостадийной модели с ковариатой возраста
model_msm_age <- msm(state~weeks, data=subs_df_semi1, subject = ID, covariates = ~age, qmatrix = Q.crude,death = 4, 
                    control = list(trace = 2,
                                   REPORT=1,
                                  fnscale=15000))
#Модель с ошибкой классификации
model_msm_misclass <- msm(state ~ weeks, data = subs_df_semi1, subject = ID, covariates = ~age,
                          qmatrix = Q.crude, ematrix = ematr1, death = 4, initprobs = c(0.5,0.4,0.1,0),
                          control = list(trace=2, REPORT=1,fnscale = 13500))

#Пребывание в состоянии(из одного в другое)
for (id in ID) { 
  totlos<-totlos.msm(model_msm_age,start=id); 
  totlos_model1=rbind(totlos_model1,totlos)
  }

sojourn <- sojourn.msm(model_msm_age) #Среднее время нахождения в каждом состоянии

