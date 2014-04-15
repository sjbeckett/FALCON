# CREATEQUANTNULL1.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 11th April 2014

CREATEQUANTNULL1 <- function(MATRIX,numbernulls,measures,binNull,sortVar) { #%Shuffle
#Keeps binary position the same as in the initial matrix, but shuffles the
#positions of the filled elements randomly. This method was used in Staniczenko et al., 2013.

#PPA Staniczenko, JC Kopp, S Allesina. 2013.
#The ghost of nestedness in ecological networks
#Nature Communications 4(1391). (http://dx.doi.org/10.1038/ncomms2422)

MEASURES <- array(0, dim=c(length(measures),numbernulls))

rowdegree<-rowSums(MATRIX>0)
Fill<-sum(rowdegree)

ind<-MATRIX>0
INDEXES<-which(ind==1)

for (aa in 1:numbernulls) {
    
    TEST<-MATRIX*0
    TEST[ind]<-1
    ELEMENTS<-MATRIX[which(MATRIX>0)]
   
    
    for (b in 1:Fill) {

       #Find empty cell  
       num<-sample(length(ELEMENTS), 1)
       TEST[INDEXES[b]]<-ELEMENTS[num] 
       #reduce possible switches left
       ELEMENTS<-ELEMENTS[-num]
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
    
    

