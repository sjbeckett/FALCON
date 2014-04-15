# CREATEBINNULL3.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 22nd March 2014

CREATEBINNULL3 <- function(MATRIX,numbernulls,measures,binNull,sortVar) {#CC
#Cored - Cored null model
#has same dimensions and fill as initial matrix and has a similar degree
#distribution to the orginal matrix. The initial matrix is used as a
#guideline, where elements are randomly removed if the degree distributions
#of rows and columns will not fall to zero. These removed elements are then
#randomly reassigned to empty spaces in the matrix to conserve connectance
#of the input matrix. This method is described in Beckett & Williams, in prep.


MEASURES <- array(0, dim=c(length(measures),numbernulls)) #To store measure answers.

degr <- rowSums(MATRIX)
degc <- colSums(MATRIX)

rows <- dim(MATRIX)[1]
cols <- dim(MATRIX)[2]

for (aaa in 1:numbernulls) {

	  TEST<-MATRIX
	  degralt<-degr
	  degcalt<-degc
	  counting<-0

	  #remove elements while each row and each column still has at least one thing in it

	  for (e in 1:rows) {#%for each row
	      a<-sample(rows,1)
	      for (c in 1:cols) {#for each column
		  b<-sample(cols,1) 
		  
		  if (degralt[a]>=2 && degcalt[b]>=2 && TEST[a,b]==1) {
		    TEST[a,b]<-0
		    counting<-counting+1
		    degralt[a]<-degralt[a]-1
		    degcalt[b]<-degcalt[b]-1
								      }
		  
				}
			    }

	  #randomly reassign the removed elements
	  for (d in 1:counting) {
	      flag<-0
	      
	      while (flag==0) {
		  x<-sample(rows,1)
		  y<-sample(cols,1)
	      
		  if (TEST[x,y]==0) { 
		      TEST[x,y]<-1
		      flag<-1
				    }
				}
				  }

	  #sort
	  TEST<-sortMATRIX(TEST,binNull,sortVar)$sortMAT


	  #measure
	  for (ww in 1:length(measures)) {
	      MEASURES[ww,aaa] <- measures[[ww]](TEST)
					  }

			    }
return(MEASURES)

}


