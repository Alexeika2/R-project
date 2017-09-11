#Данный фрагмент из скрипта по подсчету доверительных интревалов. К сожалению я не могу
#Предоставить полную версию скрипта из - за договоренностей с организацией, для которой это писалось.

#Author: Kalinkin A.

output3 <- NULL # variable for output
for (k in levels(input$group)) # loop by mainFactor
{
  if (!silent) message("Starting cond ", k, " ...") 
  
  sum_output2 <- NULL  # summary output for some mainFac
  for (var_i in y.col) ### loop on variables
  {
    if (!silent) message("Variable: ", var_i, " ...", appendLF =F)
    
    input_k_i<-subset(input, group == k, c(x.col, var_i, nos.col, "isopt"))  # subset with particular group and variable 
    time0 <- proc.time() # Time measurement
    # Is parallel calculation enabled?
    if (par_calc) # parallel calulation is used
    {
      mat_i<-foreach::foreach(i = unique(input_k_i[,3]) , .combine=cbind)%dopar%
      {
        mat_i.inter<-stats::approxfun(input_k_i[input_k_i[,3] == i,1], input_k_i[input_k_i[,3]==i,2])
        mat_i.inter(x.seq)
      } # foreach by iters
    }	else	{  # parallel calulation is not used
      mat_i <- NULL
      for (i in unique(input_k_i[,3])) 
      {
        mat_i.inter <- stats::approxfun(input_k_i[input_k_i[,3] == i,1], input_k_i[input_k_i[,3] == i,2])
        mat_i<-cbind(mat_i, mat_i.inter(x.seq))
      } # for i
    }	
    #search the column with isopt=1
    t1 <- unique(input_k_i[,3:4])[,2] == 1
    
    output2 <- data.frame(x.seq, var_i)   																# create output 
    names(output2) <- c(x.col, "var_id") # 
    output2[,paste0("quant_",q.seq)]<-t(apply(mat_i[,!t1], MARGIN=1, FUN=stats::quantile, probs = q.seq, ...)) #append quantile
    # append optimal here
    if (include.optimal) output2[,"simulation"]<-mat_i[,t1]
    
    sum_output2<-rbind(sum_output2, output2) 									# add output2 to summary output (sum_output2)
    
    time3<-proc.time()-time0 																	# Calculation timer
    if (!silent) message("Calc time, sec: ", round(time3[3],2)) 
    
  } # loop on variables
  
  if (!is.null(factor.col))  sum_output2[,factor.col]<-subset(input, subset=group==k, select=factor.col)[1,]  	# Add "factor" columns
  sum_output2$group<-k																		# Add "group" column
  
  output3<-rbind(output3,sum_output2)
} # loop by mainFactor
