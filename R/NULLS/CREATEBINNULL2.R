# CREATEBINNULL2.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 3rd April 2014

CREATEBINNULL2 <- function(MATRIX,numbernulls,measures,binNull,sortVar) {#FF
#Fixed - Fixed sequential trial swap only. Using advice on trial-swapping
#from Miklos and Podani, 2004 and the number of trial swaps to perform from
#Gotelli and Ulrich, 2011. The first null model is found by performing
#30,000 trial swaps on the input matrix to escape oversampling the input
#matrix, subsequent null models are found by performing further trial swaps
#and sampling the matrix every 5,000 trial swaps.

#I Miklós, J Podani. 2004.
#Randomization of presence-absence matrices: comments and new algorithms
#Ecology 85(1): 86 – 92. (http://dx.doi.org/10.1890/03-0101)

#N Gotelli, W Ulrich. 2011.
#Over-reporting bias in null model analysis: A response to Fayle and
#Manica(2010)
#Ecological Modelling 222: 1337 - 1339. (http://dx.doi.org/10.1016/j.ecolmodel.2010.11.008)



MEASURES <- array(0,dim=c(length(measures),numbernulls)); #To store measure answers.
r<-dim(MATRIX)[1]
c<-dim(MATRIX)[2]
TEST<-MATRIX
sampleafterspinup <- 5000


#Stage 1) Check that swaps are possible - or else no point in trial swapping.
CHECKSWAPS<-0

if (r < c) { #Make sure check is made along the smallest dimension
    
    for (row1 in 1:(r-1)) {
        for (row2 in 2:r) {
            TESTrows<- TEST[row1,] - TEST[row2,]
            if (sum(TESTrows==-1)>0 && sum(TESTrows==1)>0) {
                CHECKSWAPS<-1 #swaps possible
                break
							    }
			    }
    
}} else {
    
     for (col1 in 1:(c-1)) {
        for (col2 in 2:c) {
            TESTcols<- TEST[,col1] - TEST[,col2]
            if (sum(TESTcols==-1)>0 && sum(TESTcols==1)>0) {
                CHECKSWAPS<-1 #swaps possible
                break
							    }
			}
			   }
     
      }

#If no swaps possible all will have the same score and nestedness should be
#insignificant.


if (CHECKSWAPS==0) {#If no swaps possible assign same score for each null matrix.
    
     TEST<-sortMATRIX(TEST,binNull,sortVar)$sortMAT 
        
     #measure
        for (ww in 1:length(measures)) {
            MEASURES[ww,] <- measures[[ww]](TEST)
					}

} else {#IF swaps are possible - need to find out!

ID1 <- diag(2)
ID2 <- ID1[c(2, 1),c(1,2)]

#Stage 2) Find first null matrix after an initial number of trial swaps

	if (r*c>30000) {
	    numberofswapstoattempt<-r*c
	} else {
	    numberofswapstoattempt<-30000
		}

	#Spin up with 30,000 trial swaps.
	    
	for (b in 1:numberofswapstoattempt) {

	    #Pick random cols and rows.
	    row <- sample(r, 2, replace=FALSE)
	    col <- sample(c, 2, replace=FALSE)


            if (  ( sum( TEST[row,col]==ID1 )==4  ) || ( sum( TEST[row,col]==ID2 )==4) ){
            	TEST[row,col] <- TEST[rev(row),col] 
	    									    }
	    
	    
					  }

	#Measure first matrix.
	#sort
	TEST<-sortMATRIX(TEST,binNull,sortVar)$sortMAT



	#measure
	for (ww in 1:length(measures)) {
	    MEASURES[ww,1] <- measures[[ww]](TEST)
					}


#Stage 3) Use this first null matrix as a starting point to find subsequent null matrices from further trial swaps 
	
	for (cc in 2:numbernulls) {
	    
		for (b in 1:sampleafterspinup) {

		     #Pick random cols and rows.
	    row <- sample(r, 2, replace=FALSE)
	    col <- sample(c, 2, replace=FALSE)

            if (  ( sum( TEST[row,col]==ID1 )==4  ) || ( sum( TEST[row,col]==ID2 )==4) ){
            	TEST[row,col] <- TEST[rev(row),col] 
	    										}
	    
					      }

	#sort
	  TEST<-sortMATRIX(TEST,binNull,sortVar)$sortMAT

	#measure
	    for (ww in 1:length(measures)) {
		MEASURES[ww,cc] <- measures[[ww]](TEST)
					    }

				    }


      }

return(MEASURES)

}
