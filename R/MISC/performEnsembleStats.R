# performEnsembleStats.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 15th April 2014

performEnsembleStats <- function(functhand,matrixmeasure,NANcount,EnsembleSize,LargerMeasureCount,countup,ENSEMBLESET) {
#Uses ensemble information to calculate some statistics.
ENSEMBLETOTAL <- sum(ENSEMBLESET)

indicator <- list()
indicator$MEASURE <- functhand
indicator$NANcount <- NANcount #Want this to be zero
indicator$Measure <- matrixmeasure
indicator$pvalue <- LargerMeasureCount/EnsembleSize
indicator$pvalueCorrected <- 0

if (indicator$pvalue==0) { #P-value cannot be zero, but is found to be less than:
    indicator$pvalueText <- 'p cannot equal 0, conservatively assigning p < '
    indicator$pvalue <- 1/EnsembleSize
    indicator$pvalueCorrected <- 1
}


indicator$Mean <- (ENSEMBLETOTAL)/EnsembleSize
indicator$StandardDeviation <- sd(ENSEMBLESET)
indicator$sampleZscore <- (matrixmeasure-indicator$Mean)/indicator$StandardDeviation
indicator$minimum <- min(ENSEMBLESET)
indicator$maximum <- max(ENSEMBLESET)
indicator$Median <- median(ENSEMBLESET)


indicator$NormalisedTemperature <- matrixmeasure/indicator$Mean;

if (countup==1)
{
    indicator$NestednessUpOrDown <- 'Up'
}
else
{
    indicator$NestednessUpOrDown <- 'Down'
}

indicator$SignificanceTable <- rep(0, 5)

#Significance Table
if (indicator$pvalue < 0.05) { ##CHECK
	indicator$SignificanceTable[2] <- 1
	if (indicator$pvalue <= 0.001) {#CHECK
			indicator$SignificanceTable[1] <- 1
				      }
} else if (indicator$pvalue > 0.95) {
	indicator$SignificanceTable[4] <- 1
	if (indicator$pvalue >= 0.999) {
			indicator$SignificanceTable[5] <- 1
	} } else {
			indicator$SignificanceTable[3] <- 1
		} 

return(indicator)

}
