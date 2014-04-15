# CREATEQUANTNULL3.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 11th April 2014

CREATEQUANTNULL3 <- function(MATRIX,numbernulls,measures,binNull,sortVar){#%ConserveColTotals
#Conserves column totals and binary positions, but changes element values.
#This method is described in Beckett & Williams, in prep.

MEASURES <- array(0, dim=c(length(measures),numbernulls))
c<-dim(MATRIX)[2]
Qcoldegree<-colSums(MATRIX)

#Create empty matrix to be filled according to null model (randomly)
ind<-MATRIX>0

for (aa in 1:numbernulls) {
    
TEST<-MATRIX*0
TEST[ind]<-1
    
for (b in 1:c) {
       
        indx<-which(MATRIX[,b] > 0)             

        tot<-Qcoldegree[b]        
                
        MAKE <- array(runif(length(indx)),dim=c(length(indx),1)) # uniform random numbers ##MAY NOT BE NEEDED TO MAKE ARRAY
        MAKETOTAL <- sum(MAKE)
        PROPORTION <- MAKE/MAKETOTAL
        NEW<-PROPORTION*tot        
        
        for (d in 1:length(indx)) {
        	TEST[indx[d],b]<-NEW[d]
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


    

