#Есть таблица(2*10^6 строк следующего вида):
  ##   element    type     value
  ## 1   elem1 control 14.580546
  ## 2   elem2   decoy  1.863077
  ## 3   elem3 control 15.595858
  ## 4   elem4 control 14.822892
  ## 5   elem5   decoy  8.922175
  ## 6   elem6 control 17.484545
#Нужно найти такое пороговое значение T для value, при котором кол-во элементов с value>=T типа decoy будет составлять 5% от кол-ва элементов с value>=T типа control. Другими словами, если представить, что decoy - это ложные элементы, а control - действительные: "нужно определить пороговое значение value при FDR<=0.05"

fdr.df<-read.table(file="C://Users/Алексей/Documents/fdr.txt",header=TRUE)
seq1<-seq(-15.5,28.55,0.05)
decoy <- fdr.df$value[fdr.df$type=="decoy"]
control <- fdr.df$value[fdr.df$type=="control"]
res=sapply(seq1, function(x) { sum1<-sum(decoy>x); sum2<-sum(control>x); div=sum1/sum2 })
Res<-cbind(seq1,res)
Res<-data.frame(Res)
plot(seq1,res,type="p",xlab="value",ylab="1-F")
aaa<-approx(Res$seq1,Res$res,xout=11.87)
plot(seq1,res,type="s",xlab="value",ylab="1-F")
points(aaa$x,aaa$y,color='red')
