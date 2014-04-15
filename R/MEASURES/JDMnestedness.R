# JDMnestedness.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 11th April 2014

JDMnestedness <- function(MATRIX) {
#JDM are the author initials from which this nestedness measure is described
# which is Johnson et al., 2013.

#We thank Virginia Domínguez-García for help in assembling this measure.

#S Johnson, V Domínguez-García, MA Muñoz. 2013.
#Factors determining nestedness in complex networks.
#PLOS ONE (http://dx.doi.org/10.1371/journal.pone.0074025)


## STAGE 1 -  create bipartite configuration model
#Following notation given in Appendix A (Johnson et al., 2013)

#Make sure dealing with binary data!
MATRIX <- MATRIX>0;

#dimensions of MATRIX, n1 rows and n2 columns
r <- dim(MATRIX)[1]
c <- dim(MATRIX)[2]


k1AVG <- sum(rowSums(MATRIX))/r;  #Average row degrees per rows
k2AVG <- sum(colSums(MATRIX))/c; #Average column degrees per columns
k1sqAVG <- sum( rowSums(MATRIX)*rowSums(MATRIX) ) /r; #Average row degrees squared per rows
k2sqAVG <- sum( colSums(MATRIX)*colSums(MATRIX) ) /c; #Average column degrees squared per columns

#Predicted nestedness for bipartite network (Appendix SI 1.)
nbip <- (r*k2sqAVG + c*k1sqAVG)/(k1AVG*k2AVG*(r+c)*(r+c));



## STAGE 2 - Find unadjusted nestedness measure (nestedness overlap)

# Full nestedness measure: means building adjacency matrix to make
# bipartite data unipartite
tot <- r+c

#Build adjacency matrix
ADJ <- matrix(0,tot,tot)
ADJ[1:r, (r + 1):tot] <- MATRIX
ADJ <- ADJ+t(ADJ)

#Find overlap, by squaring adjacency matrix
ADJsq <- ADJ%*%ADJ;

#find degree information of the adjacency matrix
k <- rowSums(ADJ>0);
	

n <- 0*ADJ

#Then find unajusted nestedness value (eq. 2)
for (i in 1:tot) {
    for (j in 1:tot) {
        n[i,j] <- ADJsq[i,j] / (k[i]*k[j]);
    }
}

#Find global nestedness temperature and store in Nu (eq. 3)
Nu <- sum(n) / (tot*tot);

## STAGE 3 - normalise the nestedness overlap by the bipartite configuration
#model as in eq. 6 with nbip=nconf

#Bipartite config model version of eq. 6

MEASURE <- Nu / nbip

return(MEASURE)
}

