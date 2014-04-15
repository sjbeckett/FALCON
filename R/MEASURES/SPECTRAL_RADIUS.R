# SPECTRAL_RADIUS.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 12th March 2014

SPECTRAL_RADIUS <- function(MATRIX){
#The spectral radius method is described in Staniczenko et al., 2013.

#PPA Staniczenko, JC Kopp, S Allesina. 2013.
#The ghost of nestedness in ecological networks
#Nature Communications 4(1391). (http://dx.doi.org/10.1038/ncomms2422)


r <- dim(MATRIX)[1]
c <- dim(MATRIX)[2]

tot <- r+c

#Build adjacency matrix
ADJ <- matrix(0,tot,tot)
ADJ[1:r, (r + 1):tot] <- MATRIX
ADJ <- ADJ+t(ADJ)

#return the real eigenvalue with largest magnitude
MEASURE <- Re(eigen(ADJ)$value[1])

return(MEASURE)
}

