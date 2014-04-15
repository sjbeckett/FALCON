# NODF.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 9th March 2014

NODF <- function(MATRIX) {
#NODF stands for nestedness by overlap and decreasing fill and is described
#in Almeida-Neto et al., 2008.

#M Almeida‐Neto, P Guimaraes, PR Guimaraes Jr, RD Loyola, W Ulrich. 2008.
#A consistent metric for nestedness analysis in ecological systems: reconciling concept and measurement
#Oikos 117(8): 1227 - 1239. (http://dx.doi.org/10.1111/j.0030-1299.2008.16644.x)

MATRIX <- (MATRIX>0)*1

rows <- dim(MATRIX)[1]
cols <- dim(MATRIX)[2]


colN <- matrix(0,cols,cols)
rowN <- matrix(0,rows,rows)

#Find NODF column score

for( i in 1:cols-1)
{
	for( j in (i+1):cols)
{
		if( sum(MATRIX[,i])>sum(MATRIX[,j]) )
{
			count <- 0
			for(k in 1:rows)
{
				if( (MATRIX[k,i]>0) && (MATRIX[k,j]>0) )
{
				count <- count + 1
}
}
			 colN[j,i] <- count/ sum(MATRIX[,j])
}
}
}

				

colN <- 100*colN
NODF_COL <- 2*sum(sum(colN))/(cols*(cols-1));

#Find NODF row score

for( i in 1:rows-1)
{
	for( j in (i+1):rows)
{
		if( sum(MATRIX[i,])>sum(MATRIX[j,]) )
{
			count <- 0
			for(k in 1:cols)
{
				if( (MATRIX[i,k]>0) && (MATRIX[j,k]>0) )
{
				count <- count + 1
}
}
			 rowN[i,j] <- count/ sum(MATRIX[j,])
}
}
}

rowN <- rowN*100
NODF_ROW = 2*sum(sum(rowN))/(rows*(rows-1))

#Find NODF
NODF <- 2*(sum(sum(rowN))+sum(sum(colN)))/(cols*(cols-1) +rows*(rows-1) );

return(NODF)

}
