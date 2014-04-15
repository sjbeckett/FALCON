# ADAPTIVEMETHOD.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 11th April 2014

ADAPTIVEMETHOD <- function(indicator,functhand,A,matrixmeasure,nullfuncthand,binNull,EnsembleNumber,sortVar,plotON) {

#Creates an adaptive number of null models to use in an ensemble
#to compare against the test matrix for the given test, by comparing
#summary statistics for two sampling groups from the same null
#population. Method is described in Beckett & Williams, in prep.

#Returns summary statistical comparison between the test matrix and the ensemble.

NULLMODEL <- get(nullfuncthand) #Converts null model strings to functions

MEASURE <- mget(functhand,envir=as.environment(1)) #Converts measure strings to functions

#CONDITIONS
maxEnsemble <- 100000 #Maximum number possible is 100,000.
GroupEnsemble <- 25 #When comparisons begin, how many extra nulls to add to each group between comparisons
minEnsemble <- 500-GroupEnsemble #Minimum number per group before comparison stage is entered.

#SETUP
flag <- 0 #flag to check success of comparison between two groups
LargerMeasureCount <- rep(0,length(MEASURE)) #Initialise vector to store number of null matrices with greater or equal measure score to that being tested.
NANcount <- rep(0,length(MEASURE)) #Initialise vector to store number of null matrices with a measure that returns NaN.

countup <- rep(0,length(MEASURE))

#WORK OUT WHETHER NESTEDNESS INCREASES/DECREASES WITH MEASURE
for (ww in 1:length(MEASURE)) {
    countup[ww] <- NESTED_UP_OR_DOWN(MEASURE[[ww]]) 
			      }

## STAGE 1 - minimum ensemble
    #BLIND <- c() #group one
    #TEST <- c() #group two
    BLIND <- NULLMODEL(A,minEnsemble,MEASURE,binNull,sortVar)
    TEST <-  NULLMODEL(A,minEnsemble,MEASURE,binNull,sortVar)
    EnsembleSize <- 2*minEnsemble

## STAGE 2 - comparison ensemble stage

# create progress bar
pb <- txtProgressBar(min = 0, max = maxEnsemble, style = 3)


    while (flag == 0) {
        BLIND <- cbind(BLIND, NULLMODEL(A,GroupEnsemble,MEASURE,binNull,sortVar))
        TEST <- cbind(TEST, NULLMODEL(A,GroupEnsemble,MEASURE,binNull,sortVar))
        EnsembleSize <- EnsembleSize + 2*GroupEnsemble
	setTxtProgressBar(pb,EnsembleSize)# update progress bar

        if (EnsembleSize>=maxEnsemble) {#if too many
            flag <- 1
        }
	else { #else need to check whether to continue to sample from null models or not
            ww <- 1
            checkflag <- 0 #flag for whether to continue Mann-Whitney U test comparisons in this iteration
            while (checkflag==0) {
                 #Test whether the two sample groups appear to have come from the same distribution with 10% significance test (H0: Same distribution, H1: Different distributions)
		 mwutest <- wilcox.test(BLIND[ww,],TEST[ww,])
                 if ((is.na(mwutest$p.value) == TRUE) || ((mwutest$p.value<=0.1)==0)) {
                     ww <- ww+1
                     if (ww == length(functhand)+1) {
                         flag <- 1
                         checkflag <- 1
						    }
											}
		 else {
                         checkflag <- 1
                      }
            }
	}
     }

setTxtProgressBar(pb,maxEnsemble) # update progress bar
close(pb)

## STAGE 3 - Create statistics from the ensemble

    #find number of null matrices with equal or greater nestedness score
    for (aa in 1:length(countup)) {
        LargerMeasureCount[aa] <- sum(countup[aa]*(c(TEST[aa,], BLIND[aa,])) >= countup[aa]*matrixmeasure[aa])
    						}
    #find number of null matrices that failed to score correctly
    NANcount <- rowSums(is.na(cbind(BLIND, TEST)))
    if (sum(NANcount)>0) {
        warning('NaN`s found')
    				}

    indicator <- list()
    indicator$EnsembleSize <- EnsembleSize
    indicator$SignificanceTable <- array(0, dim=c(length(functhand),5))

  
    for (ww in 1:length(MEASURE)) {
        indicator[[functhand[ww]]] <- performEnsembleStats(functhand[ww],matrixmeasure[ww],NANcount[ww],EnsembleSize,LargerMeasureCount[ww],countup[ww],c(TEST[ww,], BLIND[ww,]))

	indicator$SignificanceTable[ww,] <- indicator[[functhand[ww]]]$SignificanceTable
        
## STAGE 4 - Plotting
        if (plotON==1) {
          plotEnsemble(c(TEST[ww,], BLIND[ww,]),matrixmeasure[ww],countup[ww],functhand[ww],nullfuncthand)
        		}

				}

	


return(indicator)
}
