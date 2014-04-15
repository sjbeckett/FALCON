# CREATEQUANTNULL4.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 11th April 2014

CREATEQUANTNULL4 <- function(MATRIX,numbernulls,measures,binNull,sortVar) {#Average of ConserveRowTotals and ConserveColTotals
#Keeps positions of filled elements the same and averages a null matrix found via the conserves row totals method
#(Quant. null 2) with that found via the conserves column totals method (Quant. null 3)
#This method is described in Beckett & Williams, in prep.

MEASURES = array(0, dim=c(length(measures),numbernulls))
r<-dim(MATRIX)[1]
c<-dim(MATRIX)[2]
Qrowdegree<-rowSums(MATRIX)
Qcoldegree<-colSums(MATRIX)

#Create empty matrix to be filled according to null model (randomly)
ind<-MATRIX>0

for (aa in 1:numbernulls) {
    
    TEST1<-MATRIX*0
    TEST1[ind]<-1
    TEST2<-TEST1
    
    for (b in 1:r) {
       
        indy<-which(MATRIX[b,] > 0) #non zero column indexes in this row. ##CHECK
                
        tot<-Qrowdegree[b] #row sum
             
        MAKE <- runif(length(indy)) # uniform random numbers
        MAKETOTAL <- sum(MAKE)
        PROPORTION <- MAKE/MAKETOTAL
        NEW <- PROPORTION*tot
        
        for (d in 1:length(indy)) {
        	TEST1[b,indy[d]] <- NEW[d]
        					}
        		}
	        
    for (b in 1:c) {
       
        indx<-which(MATRIX[,b] > 0)             

        tot<-Qcoldegree[b]        
                
        MAKE <- array(runif(length(indx)),dim=c(length(indx),1)) # uniform random numbers ##MAY NOT BE NEEDED TO MAKE ARRAY
        MAKETOTAL <- sum(MAKE)
        PROPORTION <- MAKE/MAKETOTAL
        NEW<-PROPORTION*tot        
        
        for (d in 1:length(indx)) {
        	TEST2[indx[d],b]<-NEW[d]
        					}
        		}
	
     TEST <- 0.5*(TEST1+TEST2) 
     #sort
     TEST <- sortMATRIX(TEST,binNull,sortVar)$sortMAT


     #measure
     for (ww in 1:length(measures)) {
            MEASURES[ww,aa] <- measures[[ww]](TEST)
        					}
				}
return(MEASURES)
}



