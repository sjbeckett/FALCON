# CREATEBINNULL2.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 11th July 2014

CREATEBINNULL2 <- function(MATRIX,numbernulls,measures,binNull,sortVar) { #FF
# Fixed - Fixed null model
#Creates null matrices that conserve the same number of elements per row
#and column (the degree) as in the input matrix using the fast and robust
#curveball algorithm of Strona et al. 2014.


#G Strona, D Nappo, F Boccacci, S Fattorini, J San-Miguel-Ayanz. 2014.
#A fast and unbiased procedure to randomize ecological binary matrices with
#fixed row and column totals.
#Nature Communications 5: 4114. (http://dx.doi.org/10.1038/ncomms5114)


    
	MEASURES <- array(0,dim=c(length(measures),numbernulls)) #To store measure answers.
	r<-dim(MATRIX)[1]
	c<-dim(MATRIX)[2]
	ROW <- rep(0,c)
    
    
    for(aa in 1:numbernulls) {#for each null matrix
        
        TEST <- MATRIX; #start with the input matrix

        for(rep in 1:5*r) {
    
            AB <- sample(1:r,2) #choose two rows
            A <- TEST[AB[1],] #vector of elements in row 1
            J <- A - TEST[AB[2],]# difference between row 1 and row 2
    
            if((max(J) - min(J)) == 2) { #if uniques(a column with 1 in one row, 0 in other) in both rows can perform a swap.
                tot <- which(abs(J)==1)  #all unique indices
                l_tot <- length(tot) #num uniques
                tot <- sample(tot,l_tot)  #shuffled uniques
                both <- which(J==0 & A==1)  #things that appear (precenses) in both rows
                L <- sum(J==1) #sum of uniques in row 1. ( 1-0 )
                ROW1 <- c(both, tot[1:L])  #row1 presences
                ROW2 <- c(both, tot[(L+1):l_tot]) #new row 2 presences
                
                
                I <- ROW
                I[ROW1] <- 1
                K <- ROW
                K[ROW2] <- 1
                TEST[AB,] <- rbind(I,K)
                
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


