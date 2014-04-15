# plotEnsemble.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 15th April 2014

plotEnsemble <- function(NULLS,matrixmeasure,countup,functhand,nullfuncthand) {
#plots histograms of scores found in null ensembles

dev.new()
uniques <- unique(NULLS)
a <- hist(NULLS,breaks=length(uniques))
maxfreq <- max(a$counts)

hist(NULLS,breaks=length(uniques),xlab=paste(functhand,' score'),xaxs='r',ylim=c(0,1.3*maxfreq),xlim=c( min(matrixmeasure,min(NULLS)),max(matrixmeasure,max(NULLS))),main=paste('Nestedness in ensemble for null model: ', nullfuncthand),col='blue')
lines(c(matrixmeasure,matrixmeasure),c(0,1.1*maxfreq),col='red')
points(matrixmeasure,1.1*maxfreq,col='red',pch=8)
legend("topright",legend='Test Matrix',pch=8,col='red')

MIN <- min(matrixmeasure,min(NULLS))-0.0000001
MAX <- max(matrixmeasure,max(NULLS))+0.0000001
RANGE <- MAX-MIN


 xcord <- c(MIN+0.4*RANGE, MIN+0.7*RANGE)
 if (countup == -1) {
     xcord <- c(MIN+0.6*RANGE, MIN+0.3*RANGE)
 }

arrows(x0=xcord[1],y0=1.15*maxfreq, x1=xcord[2],y1=1.15*maxfreq )
text(MIN+0.5*RANGE,1.18*maxfreq,'nestedness')

 
}



