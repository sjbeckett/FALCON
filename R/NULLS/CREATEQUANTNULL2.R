# CREATEQUANTNULL2.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 11th April 2014

CREATEQUANTNULL2 <- function(MATRIX,numbernulls,measures,binNull,sortVar) {#%ConserveRowTotals
#Keeps positions of filled elements the same and conserves row totals, but
#changes element values randomly. This method is described in Beckett & Williams, in prep.

MEASURES <- array(0, dim=c(length(measures),numbernulls))
r<-dim(MATRIX)[1]
Qrowdegree<-rowSums(MATRIX) 

#Create empty matrix to be filled according to null model (randomly)
ind<-MATRIX>0

for (aa in 1:numbernulls) {
    
    TEST<-MATRIX*0
    TEST[ind]<-1
    
    for (b in 1:r) {
       
        indy<-which(MATRIX[b,] > 0) #non zero column indexes in this row. ##CHECK
                
        tot<-Qrowdegree[b] #row sum
             
        MAKE <- runif(length(indy)) # uniform random numbers
        MAKETOTAL <- sum(MAKE)
        PROPORTION <- MAKE/MAKETOTAL
        NEW<-PROPORTION*tot
        
        for (d in 1:length(indy)) {
        	TEST[b,indy[d]]<-NEW[d]
        					}
        		}
      
     #sort
     TEST<-sortMATRIX(TEST,binNull,sortVar)$sortMAT


     #measure
     for (ww in 1:length(measures)) {
            MEASURES[ww,aa] <- measures[[ww]](TEST)
        					}
				}
return(MEASURES)
}



