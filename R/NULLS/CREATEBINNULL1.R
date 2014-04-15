# CREATEBINNULL1.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 22nd March 2014

CREATEBINNULL1 <- function(MATRIX,numbernulls,measures,binNull,sortVar) { #SS
#Swappable - Swappable null model
#has same dimensions and fill as original matrix,  but filled elements are
#randomly assigned independently of the initial ordering. The method presented
#ensures that matrices with zero rows/columns are not created and thus
#conserves the dimensions of the input matrix. Thus this null model is slightly more
#conservative than Test1 used in Staniczenko et al. 2013.

#PPA Staniczenko, JC Kopp, S Allesina. 2013.
#The ghost of nestedness in ecological networks
#Nature Communications 4(1391). (http://dx.doi.org/10.1038/ncomms2422)

r <- dim(MATRIX)[1]
c <- dim(MATRIX)[2]	#Sizes of rows and columns

MEASURES <- array(0, dim=c(length(measures),numbernulls))	#To store measure answers

for (aa in 1:numbernulls) {
	TEST<-0*MATRIX
	LENr<-1:r #vector of rows
	LENc<-1:c #vector of cols
	count1<-r 
	count2<-c
	FILL<-sum(MATRIX>0) #Filled positions


	#stage1a - fill in 1 element for each row&col such that dimensions will be
	#preserved (i.e. no chance of getting empty rows/cols and changing matrix
	#dimensions).

	while (count1>0 && count2>0) {
	  
	    randa<-sample(count1, 1)
	    randb<-sample(count2, 1)
	    
	    TEST[LENr[randa],LENc[randb]]=1
	    
	    LENr<-LENr[-randa]
	    LENc<-LENc[-randb]
	    
	    count1<-count1-1
	    count2<-count2-1
	    FILL<-FILL-1
				      }


#stage1b - once all rows(cols) have something in, need to fill in cols
#(rows) with completely random rows(cols)

	  if (count1>0) {
	      while (count1>0) {
		  randa<-1
		  randb<-sample(c,1)
	      
		  TEST[LENr[randa],randb]<-1
		  LENr<-LENr[-randa]
		  FILL<-FILL-1    
		  count1<-count1-1
				}
	 } else if (count2>0) {
	      while (count2>0) {
		  randb<-1
		  randa<-sample(r,1)
	      
		  TEST[randa,LENc[randb]]<-1
		  LENc<-LENc[-randb]
		  FILL<-FILL-1  
		  count2<-count2-1
				}
			      }

#stage2 - Once dimensions are conserved, need to add extra elements to
#preserve original matrix fill.

	  for (d in 1:FILL) {
	      
	      flag<-0;
	      while (flag==0) {
		  randa<-sample(r, 1)
		  randb<-sample(c, 1)
		  
		  if (TEST[randa,randb]==0) {
		      TEST[randa,randb]<-1
		      flag<-1
					    }
				}
			    }

#stage 3 - sort this created matrix
	  TEST<-sortMATRIX(TEST,binNull,sortVar)$sortMAT
	
#stage 4 - now save the measures of this matrix

	  for (ww in 1:length(measures)) {
	      MEASURES[ww,aa] <- measures[[ww]](TEST)
					  }


		}


return(MEASURES)

}









