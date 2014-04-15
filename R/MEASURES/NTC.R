# NTC.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 20th March 2014

NTC <- function(MATRIX){
#The nestedness temperature calculator is orginally described in Atmar & Patterson, 1995
#We use the methodology of Oksanen et al. in the nestedtemp function for the vegan package in R to find the nestedess temperature score. This is described in vegan's vignettes.

#W Atmar & BD Patterson. 1993.
#The measure of order and disorder in the distribution of species in fragmented habitat.
# Oecologia 96(3):373-382. (http://dx.doi.org/10.1007/BF00317508)

#Oksanen, J., et al. 2013.
#vegan: community ecology package.
#R package version 2.0-10. (http://CRAN.R-project.org/package=vegan)

MEASURE <- nestedtemp(MATRIX)$statistic

return(MEASURE)
}

