# NESTED_UP_OR_DOWN.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 22nd March 2014

NESTED_UP_OR_DOWN <- function(MEASURE) {

#DECIDES WHETHER NESTEDNESS SHOULD BE COUNTED UP OR DOWN BY LOOKING AT
#PERFECT NESTED MATRIX MEASURE AND UN-NESTED (CHECKERBOARD) MATRIX MEASURES

PERFECTNEST <- upper.tri(matrix(0,10,10),diag=TRUE) * toeplitz(c(1,2,3,4,5, 6,7,8, 9, 10))
PERFECTNEST <- PERFECTNEST[,ncol(PERFECTNEST):1]



#An un-nested matrix based on checkerboard structure. 
CHECKERED1 <- 1:10;
CHECKERED1 <- CHECKERED1 %% 2;
CHECKERED2 <- CHECKERED1;
CHECKERED2[CHECKERED1==1] <- 0;
CHECKERED2[CHECKERED1==0] <-1;

CHECKERED<- matrix(rep(c(CHECKERED1,CHECKERED2),5),nrow=10)
#Add additional to give same fill as perfectly nested matrix
CHECKERED[1,2]<-1;
CHECKERED[3,4]<-1;
CHECKERED[5,6]<-1;
CHECKERED[7,8]<-1;
CHECKERED[9,10]<-1;

#Increase so that sum of elements is equal to that in PERFECTNEST
CHECKERED <- CHECKERED*4;


#See which way round nestedness is measured
if (MEASURE(PERFECTNEST) > MEASURE(CHECKERED))
{
    countup <-1;
}
else
{
    countup<- -1;
}


return(countup)

}
