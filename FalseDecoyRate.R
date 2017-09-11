#Есть таблица(2*10^6 строк следующего вида):
  
  ## element type value
  ## 1 elem1 control 14.580546
  ## 2 elem2 decoy 1.863077
  ## 3 elem3 control 15.595858
  ## 4 elem4 control 14.822892
  ## 5 elem5 decoy 8.922175
  ## 6 elem6 control 17.484545

#Нужно найти такое пороговое значение T для value, 
#при котором кол-во элементов с value>=T типа decoy будет составлять 5% от кол-ва элементов 
#с value>=T типа control. Другими словами, если представить, 
#что decoy - это ложные элементы, а control - действительные:
#"нужно определить пороговое значение value при FDR<=0.05"

require(ggplot2)
fdr.df <- read.table("Downloads/fdr.txt", header=TRUE)
min(fdr.df$value)
max(fdr.df$value)

#Моя идея в чём: Нужно взять отношение эмпирической(выборочной) функции распределения decoy 
#к эмпирической функции распределения control.
#Только если в эмпирической ф-ции распределения мы берем <=x, 
#то здесь мы берем обратную ф-цию распределения, то есть 1-F. 
#Там где отношение этих двух обратных эмпирических функций распределения будет равна 
#и есть нужное нам пороговое значение T.

#Вычислим обратные эмпирические функции распределения 
#и возьмем их отношения, а так же сгенерируем вектор от -15.5(min) до 28.55(max) и нарисуем график.

seq1 <- seq(-15.5,28.55,0.05)
decoy <- fdr.df$value[fdr.df$type == "decoy"]
control <- fdr.df$value[fdr.df$type == "control"]
res <- sapply(seq1, function(x) { sum1 <- sum(decoy>x); sum2 <- sum(control > x); div = sum1/sum2 })
Res<-cbind(seq1, res)
Res<-data.frame(Res)
plot(seq1,res,type = "p",xlab = "value",ylab = "1-F")

#Видим, что нужное нам значение находиться в районе от 11 до 12 по оси x
#Попробуем вывести эти значения

head(Res$seq1[Res$res <= 0.05])

#Пороговое значение T примерно равняется 11.9

#Проверим с помомщь ф-ции approx и построим график

ans <- approx(Res$seq1,Res$res,xout = 11.87)

ggplot(Res) + aes(seq1,res) + geom_line(colour = 'red') + xlab("value") + ylab("1-F")+
  ggtitle("Threshold for control/decoy")+
  geom_vline(xintercept = ans$x)
