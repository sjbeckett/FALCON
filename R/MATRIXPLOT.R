# MATRIXPLOT.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 3rd April 2014

MATRIXPLOT <- function(INMATRIX) {


#Graphic Control
BACKGROUNDCOLOR <- rgb(173,235,255,max=255)
offset <- 0.3 #max of 0.5,425

columns=1:dim(INMATRIX)[2]
rows=1:dim(INMATRIX)[1]

#flip matrix rows in reverse so can draw it onto grid.
INMATRIX <- t(INMATRIX[ nrow(INMATRIX):1, ] )


#determine if INMATRIX is binary
isbinary <- 0

if ( (sum(INMATRIX==0) + sum(INMATRIX==1)) == length(columns)*length(rows) )
{
	isbinary <- 1
}
else
{
	RANGE <- range(INMATRIX)
	minR <- RANGE[1]
	scalefactor <- 1/(RANGE[2]-RANGE[1])
	layout(t(c(1,1,1,1,2)), 1, 4) #If not binary - want a scale - make space for one
}


#Draw background and label axes
image(columns,rows,0*INMATRIX, col=BACKGROUNDCOLOR,xaxt='n',yaxt='n')
axis(1,at=columns)
axis(2,rev(rows),at=rows)
box()


#plot filled positions as rectangles
for (b in 1:length(rows)) {
	for (a in 1:length(columns)) { 

		if (INMATRIX[a,b]!=0){
			if (isbinary == 1)
				rect(a-offset,b-offset,a+offset,b+offset,col='white',border='NA')
			else { 
				COL <- 	1-(INMATRIX[a,b]-minR)*scalefactor
				rect(a-offset,b-offset,a+offset,b+offset,col=rgb(COL,COL,COL),border='NA')
			}
					}
					}
			}

if (isbinary==0)
{
    lut<- colorRampPalette(c("white", "black"))(100)
    scale <- (length(lut)-1)/(RANGE[2]-RANGE[1])
    plot(c(0,10), c(RANGE[1],RANGE[2]), type='n', bty='n', xaxt='n', xlab='', yaxt='n', ylab='')
    axis(2, seq(RANGE[1],RANGE[2], len=5), las=1)
    for (i in 1:(length(lut)-1)) {
     y = (i-1)/scale + RANGE[1]
     rect(0,y,10,y+1/scale, col=lut[i], border=NA)
}

}


}

