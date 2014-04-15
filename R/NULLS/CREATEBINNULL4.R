# CREATEBINNULL4.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 11th April 2014

CREATEBINNULL4 <- function(MATRIX,numbernulls,measures,binNull,sortVar) {#%DD
# Degreeprobable - Degreeprobable null model
#Proportionally fills matrix depending on size and degree distribution of
#rows and columns - as described in Bascompte et al. 2003.However, we do 
#prevent degenerate matrices being formed - i.e. those which are empty, 
#scalar or vectors.

#J Bascompte, P Jordano, CJ Melián, JM Olesen. 2003.
#The nested assembly of plant–animal mutualistic networks.
#PNAS 100: 9383–9387. (http://dx.doi.org/10.1073/pnas.1633576100)

#Find matrix dimensions and row and column degrees.
r<-dim(MATRIX)[1]
c<-dim(MATRIX)[2]
MEASURES <- array(0, dim=c(length(measures),numbernulls)) #To store measure answers.

coldegreesprop<-(colSums(MATRIX>0))/r
rowdegreesprop<-(rowSums(MATRIX>0))/c

for (aa in 1:numbernulls) {
	flag=0
	while (flag == 0) {


	#Fill up each matrix element probabilistically depending on the matrix dimensions and
	#degree distribution

	
	TEST<- 1* ( array(runif(r*c), dim=c(r,c)) < 0.5* (array(rep(coldegreesprop,rep(r,c)), dim=c(r,c)) + array(rep(rowdegreesprop,c),dim=c(r,c))) ) 
	
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

