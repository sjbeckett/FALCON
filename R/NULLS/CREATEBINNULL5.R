# CREATEBINNULL5.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 11th April 2014

CREATEBINNULL5 <- function(MATRIX,numbernulls,measures,binNull,sortVar) {# EE
# This null model has assigns an equal probability of an edge appearing at
# any cell in a null model. The probability of an edge appearing is the
# same as the input matrix, but in the null model the number of edges is
# not conserved. Furthermore we do not constrain the solution space to
# only those null models that preserve the number of nodes in the input
# matrix i.e. some null models will have reduced dimensions to those in the
# input matrix.

MEASURES <- array(0, dim=c(length(measures),numbernulls)) #To store measure answers.

edges <- sum(MATRIX>0)
r <- dim(MATRIX)[1]
c <- dim(MATRIX)[2]
M <- edges/(r*c)


for (aa in 1:numbernulls) {
	flag=0
	while (flag==0) {
	
	TEST<- 1*( array(runif(r*c), dim=c(r,c)) < M )
	
 	#sort
      	TEST<-sortMATRIX(TEST,binNull,sortVar)$sortMAT
      	
      	flag=1
	if (length(dim(TEST)) < 2) {flag=0}
			    }

 	#measure
        for (ww in 1:length(measures)) {
            MEASURES[ww,aa] <- measures[[ww]](TEST)
        				}
	

			}
return(MEASURES)

}
