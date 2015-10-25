#вспомогательный скрипт для пакета msm.
ID=unique(df1[,1])
df_pr=NULL
for (id in ID) {
  aux1=df1[df1[,1]==id,6]
  aux1=aux1[1]
  df1[df1[,1]==id,6]=df1[df1[,1]==id,6]-aux1
  aux=sum(df1[,1]==id)
  if(aux>1) {
    df_pr=rbind(df_pr,df1[df1[,1]==id,])
  }
}
