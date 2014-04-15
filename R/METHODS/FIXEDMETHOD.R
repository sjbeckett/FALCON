# FIXEDMETHOD.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 4th April 2014

FIXEDMETHOD <- function(indicator,functhand,A,matrixmeasure,nullfuncthand,binNull,EnsembleNumber,sortVar,plotON) {

#Creates a fixed number(EnsembleNumber) of null models to use in an ensemble 
#to compare against the test matrix for the given test.

#Returns summary statistical comparison between the test matrix and the ensemble.

NULLMODEL <- get(nullfuncthand) #Converts null model strings to functions

MEASURE <- mget(functhand,envir=as.environment(1)) #Converts measure strings to functions
				

#SETUP
LargerMeasureCount <- rep(0,length(MEASURE)) #Initialise vector to store number of null matrices with greater or equal measure score to that being tested.
NANcount <- rep(0,length(MEASURE)) #Initialise vector to store number of null matrices with a measure that returns NaN.

countup <- rep(0,length(MEASURE))
#WORK OUT WHETHER NESTEDNESS INCREASES/DECREASES WITH MEASURE
for (ww in 1:length(MEASURE)) {
    countup[ww] <- NESTED_UP_OR_DOWN(MEASURE[[ww]])
}

## STAGE 1 - Run a fixed ensemble

# create progress bar
pb <- txtProgressBar(min = 0, max = EnsembleNumber, style = 3)
 
    TEST <- NULLMODEL(A,EnsembleNumber,MEASURE,binNull,sortVar)
    EnsembleSize <- EnsembleNumber

setTxtProgressBar(pb,EnsembleNumber) # update progress bar
close(pb)

## STAGE 2 - Create statistics from the ensemble    
	

    #find number of null matrices with equal or greater nestedness score
    for (aa in 1:length(countup)) {
        LargerMeasureCount[aa] <- sum(countup[aa]*(TEST[aa,]) >= countup[aa]*matrixmeasure[aa]) 
    }
    #find number of null matrices that failed to score correctly
    NANcount <- rowSums(is.na(TEST))
    if (sum(NANcount)>0) {
        warning('NaN`s found')
    }

    indicator <- list()
    indicator$EnsembleSize <- EnsembleSize
    indicator$SignificanceTable <- array(0, dim=c(length(functhand),5))

    for (ww in 1:length(MEASURE)) {
        indicator[[functhand[ww]]] <- performEnsembleStats(functhand[ww],matrixmeasure[ww],NANcount[ww],EnsembleSize,LargerMeasureCount[ww],countup[ww],TEST[ww,])
        
	indicator$SignificanceTable[ww,] <- indicator[[functhand[ww]]]$SignificanceTable

## STAGE 3 - Plotting
        if (plotON==1) {
          plotEnsemble(TEST[ww,],matrixmeasure[ww],countup[ww],functhand[ww],nullfuncthand) 
        }

    }

return(indicator)
}

##CHECK DIFFERENCE BETWEEN '.' and '$'





