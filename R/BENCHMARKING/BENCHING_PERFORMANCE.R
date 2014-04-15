# BENCHING_PERFORMANCE.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 27th March 2014


#BENCHMARKS FOR TIMES OF MEASURE CALLS AND NULL CALLS (without calling
#measures)
BENCHING_PERFORMANCE <- function() {


    file.sources <- list.files(c("../MISC/", "../MEASURES/"),pattern="*.R$",full.names=TRUE,ignore.case=TRUE)
    sapply(file.sources,source,.GlobalEnv)

    check <- require('vegan')
    if (check==TRUE){
    #choose measures and make function handles
    MEASURES <- c(NODF, SPECTRAL_RADIUS,MANHATTAN_DISTANCE,JDMnestedness,NTC,DISCREPANCY)
    Mnames <- c('NODF', 'SR','MD','JDM','NTC','BR')
    Nnames <- c('SS','FF','CC','DD','EE')
    }
    else {
    warning('Cannot load vegan package, cannot use the NTC. Continuing without it...')
    #choose measures and make function handles
    MEASURES <- c(NODF, SPECTRAL_RADIUS,MANHATTAN_DISTANCE,JDMnestedness,DISCREPANCY)
    Mnames <- c('NODF', 'SR','MD','JDM','BR')
    Nnames <- c('SS','FF','CC','DD','EE')
    }
        
## SET UP

numbertrials <- 10;
TIME_MEASURES <- matrix(0,numbertrials,length(MEASURES));
TIME_NULLS <- matrix(0,numbertrials,5);


for(TRIALS in 1:numbertrials) {
   #New matrix
   MATRIX <- 1*(array(runif(10*10), dim=c(10,10))>0.4)
   
   #sort
   MATRIX <- sortMATRIX(MATRIX,1,1)$sortMAT;

   ## MEASURE TIMES
   
   for(eachMeasure in 1:length(MEASURES)) {
            
       TIME_MEASURES[TRIALS,eachMeasure] <- system.time(    
        for ( MEASURESTOMAKE in 1:1000) {
            
		JAM <- MEASURES[[eachMeasure]](MATRIX)
            
        } )[3]
        print(c(eachMeasure, TRIALS))
   }
    


   
   ## NULL TIMES
   
  
   TIME_NULLS[TRIALS,1] <- system.time(testCREATEBINNULL1(MATRIX,1000,1,1,1))[3];
      
   TIME_NULLS[TRIALS,2] <- system.time(testCREATEBINNULL2(MATRIX,1000,1,1,1))[3];
   
   TIME_NULLS[TRIALS,3] <- system.time(testCREATEBINNULL3(MATRIX,1000,1,1,1))[3];
  
   TIME_NULLS[TRIALS,4] <- system.time(testCREATEBINNULL4(MATRIX,1000,1,1,1))[3];
   
   TIME_NULLS[TRIALS,5] <- system.time(testCREATEBINNULL5(MATRIX,1000,1,1,1))[3];
   
   
 
   
}

#save raw data
save.image('BENCHMARKING_PERFORMANCE.Rdata') 

timings <- list('time_nulls'=TIME_NULLS, 'time_measures'=TIME_MEASURES)
return(timings)
write.table(TIME_NULLS, file='TIME_NULLS.txt', row.names=FALSE, col.names=FALSE)
write.table(TIME_MEASURES, file='TIME_MEASURES.txt', row.names=FALSE, col.names=FALSE)

#convert data to per operation basis for plotting
TIME_MEASURES <- TIME_MEASURES/1000;
TIME_NULLS <- TIME_NULLS/1000;

#plotting

Lmean = 0.1;
Lstd = 0.25;


dev.new()
par(mfcol=c(1,2))
boxplot(log(TIME_MEASURES),names=Mnames)
boxplot(log(TIME_NULLS),names=Nnames)



}




# testCREATEBINNULL1.R
# Modified SS null model function, such that no measurements are made.

testCREATEBINNULL1 <- function(MATRIX,numbernulls,measures,binNull,sortVar) { #SS
#Swappable - Swappable null model
#has same dimensions and fill as original matrix,  but filled elements are
#randomly assigned independently of the initial ordering. The method presented
#ensures that matrices with zero rows/columns are not created and thus
#conserves the dimensions of the input matrix. Thus this null model is slightly more
#conservative than Test1 used in Staniczenko et al. 2013.

#PPA Staniczenko, JC Kopp, S Allesina. 2013.
#The ghost of nestedness in ecological networks
#Nature Communications 4(1391). (http://dx.doi.org/10.1038/ncomms2422)

r <- dim(MATRIX)[1]
c <- dim(MATRIX)[2]	#Sizes of rows and columns

MEASURES <- array(0, dim=c(length(measures),numbernulls))	#To store measure answers

for (aa in 1:numbernulls) {
	TEST<-0*MATRIX
	LENr<-1:r #vector of rows
	LENc<-1:c #vector of cols
	count1<-r 
	count2<-c
	FILL<-sum(MATRIX>0) #Filled positions


	#stage1a - fill in 1 element for each row&col such that dimensions will be
	#preserved (i.e. no chance of getting empty rows/cols and changing matrix
	#dimensions).

	while (count1>0 && count2>0) {
	  
	    randa<-sample(count1, 1)
	    randb<-sample(count2, 1)
	    
	    TEST[LENr[randa],LENc[randb]]=1
	    
	    LENr<-LENr[-randa]
	    LENc<-LENc[-randb]
	    
	    count1<-count1-1
	    count2<-count2-1
	    FILL<-FILL-1
				      }


#stage1b - once all rows(cols) have something in, need to fill in cols
#(rows) with completely random rows(cols)

	  if (count1>0) {
	      while (count1>0) {
		  randa<-1
		  randb<-sample(c,1)
	      
		  TEST[LENr[randa],randb]<-1
		  LENr<-LENr[-randa]
		  FILL<-FILL-1    
		  count1<-count1-1
				}
	 } else if (count2>0) {
	      while (count2>0) {
		  randb<-1
		  randa<-sample(r,1)
	      
		  TEST[randa,LENc[randb]]<-1
		  LENc<-LENc[-randb]
		  FILL<-FILL-1  
		  count2<-count2-1
				}
			      }

#stage2 - Once dimensions are conserved, need to add extra elements to
#preserve original matrix fill.

	  for (d in 1:FILL) {
	      
	      flag<-0;
	      while (flag==0) {
		  randa<-sample(r, 1)
		  randb<-sample(c, 1)
		  
		  if (TEST[randa,randb]==0) {
		      TEST[randa,randb]<-1
		      flag<-1
					    }
				}
			    }

#stage 3 - sort this created matrix
	  TEST<-sortMATRIX(TEST,binNull,sortVar)$sortMAT
	
#stage 4 - now save the measures of this matrix

#	  for (ww in 1:length(measures)) {
#	      MEASURES[ww,aa] <- measures[[ww]](TEST)
#					  }


		}


return(MEASURES)

}

# testCREATEBINNULL2.R
# Modified FF null model function, such that no measurements are made.

testCREATEBINNULL2 <- function(MATRIX,numbernulls,measures,binNull,sortVar) {#FF
#Fixed - Fixed sequential trial swap only. Using advice on trial-swapping
#from Miklos and Podani, 2004 and the number of trial swaps to perform from
#Gotelli and Ulrich, 2011. The first null model is found by performing
#30,000 trial swaps on the input matrix to escape oversampling the input
#matrix, subsequent null models are found by performing further trial swaps
#and sampling the matrix every 5,000 trial swaps.

#I Miklós, J Podani. 2004.
#Randomization of presence-absence matrices: comments and new algorithms
#Ecology 85(1): 86 – 92. (http://dx.doi.org/10.1890/03-0101)

#N Gotelli, W Ulrich. 2011.
#Over-reporting bias in null model analysis: A response to Fayle and
#Manica(2010)
#Ecological Modelling 222: 1337 - 1339. (http://dx.doi.org/10.1016/j.ecolmodel.2010.11.008)

MEASURES <- array(0,dim=c(length(measures),numbernulls)); #To store measure answers.
r<-dim(MATRIX)[1]
c<-dim(MATRIX)[2]
TEST<-MATRIX
sampleafterspinup <- 5000

#Stage 1) Check that swaps are possible - or else no point in trial swapping.
CHECKSWAPS<-0

if (r < c) { #Make sure check is made along the smallest dimension
    
    for (row1 in 1:(r-1)) {
        for (row2 in 2:r) {
            TESTrows<- TEST[row1,] - TEST[row2,]
            if (sum(TESTrows==-1)>0 && sum(TESTrows==1)>0) {
                CHECKSWAPS<-1 #swaps possible
                break
							    }
			    }
    
}} else {
    
     for (col1 in 1:(c-1)) {
        for (col2 in 2:c) {
            TESTcols<- TEST[,col1] - TEST[,col2]
            if (sum(TESTcols==-1)>0 && sum(TESTcols==1)>0) {
                CHECKSWAPS<-1 #swaps possible
                break
							    }
			}
			   }
     
      }

#If no swaps possible all will have the same score and nestedness should be
#insignificant.


if (CHECKSWAPS==0) {#If no swaps possible assign same score for each null matrix.
    
     TEST<-sortMATRIX(TEST,binNull,sortVar)$sortMAT 
        
     #measure
     #   for (ww in 1:length(measures)) {
      #      MEASURES[ww,] <- measures[[ww]](TEST)
	#				}

} else {#IF swaps are possible - need to find out!


ID1 <- diag(2)
ID2 <- ID1[c(2, 1),c(1,2)]

#Stage 2) Find first null matrix after an initial number of trial swaps

	if (r*c>30000) {
	    numberofswapstoattempt<-r*c
	} else {
	    numberofswapstoattempt<-30000
		}

	#Spin up with 30,000 trial swaps.
	    
	for (b in 1:numberofswapstoattempt) {

	     #Pick random cols and rows.
	    row <- sample(r, 2, replace=FALSE)
	    col <- sample(c, 2, replace=FALSE)

            if (  ( sum( TEST[row,col]==ID1 )==4  ) || ( sum( TEST[row,col]==ID2 )==4) ){
            	TEST[row,col] <- TEST[rev(row),col] 
	    }

					  }

	#Measure first matrix.
	#sort
	TEST<-sortMATRIX(TEST,binNull,sortVar)$sortMAT



	#measure
	#for (ww in 1:length(measures)) {
	 #   MEASURES[ww,1] <- measures[[ww]](TEST)
	#				}


#Stage 3) Use this first null matrix as a starting point to find subsequent null matrices from further trial swaps 
	
	for (cc in 2:numbernulls) {
	    
		for (b in 1:sampleafterspinup) {

		     #Pick random cols and rows.
	    row <- sample(r, 2, replace=FALSE)
	    col <- sample(c, 2, replace=FALSE)

            if (  ( sum( TEST[row,col]==ID1 )==4  ) || ( sum( TEST[row,col]==ID2 )==4) ){
            	TEST[row,col] <- TEST[rev(row),col] 
	    }


					      }

	#sort
	  TEST<-sortMATRIX(TEST,binNull,sortVar)$sortMAT

	#measure
	 #   for (ww in 1:length(measures)) {
	#	MEASURES[ww,cc] <- measures[[ww]](TEST)
	#				    }

				    }


      }

return(MEASURES)

}



# testCREATEBINNULL3.R
# Modified CC null model function, such that no measurements are made.

testCREATEBINNULL3 <- function(MATRIX,numbernulls,measures,binNull,sortVar) {#CC
#Cored - Cored null model
#has same dimensions and fill as initial matrix and has a similar degree
#distribution to the orginal matrix. The initial matrix is used as a
#guideline, where elements are randomly removed if the degree distributions
#of rows and columns will not fall to zero. These removed elements are then
#randomly reassigned to empty spaces in the matrix to conserve connectance
#of the input matrix. This method is described in Beckett & Williams, in prep.


MEASURES <- array(0, dim=c(length(measures),numbernulls)) #To store measure answers.

degr <- rowSums(MATRIX)
degc <- colSums(MATRIX)

rows <- dim(MATRIX)[1]
cols <- dim(MATRIX)[2]

for (aaa in 1:numbernulls) {

	  TEST<-MATRIX
	  degralt<-degr
	  degcalt<-degc
	  counting<-0

	  #remove elements while each row and each column still has at least one thing in it

	  for (e in 1:rows) {#%for each row
	      a<-sample(rows,1)
	      for (c in 1:cols) {#for each column
		  b<-sample(cols,1) 
		  
		  if (degralt[a]>=2 && degcalt[b]>=2 && TEST[a,b]==1) {
		    TEST[a,b]<-0
		    counting<-counting+1
		    degralt[a]<-degralt[a]-1
		    degcalt[b]<-degcalt[b]-1
								      }
		  
				}
			    }

	  #randomly reassign the removed elements
	  for (d in 1:counting) {
	      flag<-0
	      
	      while (flag==0) {
		  x<-sample(rows,1)
		  y<-sample(cols,1)
	      
		  if (TEST[x,y]==0) { 
		      TEST[x,y]<-1
		      flag<-1
				    }
				}
				  }

	  #sort
	  TEST<-sortMATRIX(TEST,binNull,sortVar)$sortMAT


	  #measure
	  #for (ww in 1:length(measures)) {
	   #   MEASURES[ww,aaa] <- measures[[ww]](TEST)
		#			  }

			    }
return(MEASURES)

}

# testCREATEBINNULL4.R
# Modified DD null model function, such that no measurements are made.

testCREATEBINNULL4 <- function(MATRIX,numbernulls,measures,binNull,sortVar) {#%DD
# Degreeprobable - Degreeprobable null model
#Proportionally fills matrix depending on size and degree distribution of
#rows and columns - as described in Bascompte et al. 2003.

#J Bascompte, P Jordano, CJ Melián, JM Olesen. 2003.
#The nested assembly of plant–animal mutualistic networks.
#PNAS 100: 9383–9387. (http://dx.doi.org/10.1073/pnas.1633576100)

#Find matrix dimensions and row and column degrees.
r<-dim(MATRIX)[1]
c<-dim(MATRIX)[2]
MEASURES <- array(0, dim=c(length(measures),numbernulls)) #To store measure answers.

coldegreesprop<-colSums(MATRIX>0)
rowdegreesprop<-rowSums(MATRIX>0)

for (aa in 1:numbernulls) {
	flag=0
        while (flag == 0) {

	#Fill up each matrix element probabilistically depending on the matrix dimensions and
	#degree distribution

	TEST<- 1* ( array(runif(r*c), dim=c(r,c)) < 0.5* array(rep(coldegreesprop,rep(r,c)), dim=c(r,c)) + array(rep(rowdegreesprop,c),dim=c(r,c)) ) 

	
	#sort
	TEST<-sortMATRIX(TEST,binNull,sortVar)$sortMAT
	
	flag=1
        if (length(dim(TEST)) < 2) {flag=0}
                            }
	#measure
	#for (ww in 1:length(measures)) {
	 #  MEASURES[ww,aa] <- measures[[ww]](TEST)
	#				}
			  }
return(MEASURES)
}

# testCREATEBINNULL5.R
# Modified EE null model function, such that no measurements are made.

testCREATEBINNULL5 <- function(MATRIX,numbernulls,measures,binNull,sortVar) {# EE
# This null model has assigns an equal probability of an edge appearing at
# any cell in a null model. The probability of an edge appearing is the
# same as the input matrix, but in the null model the number of edges is
# not conserved. Furthermore we do not constrain the solution space to
# only those null models that preserve the number of nodes in the input
# matrix i.e. some null models will have reduced dimensions to those in the
# input matrix.

#RR Sokal & FJ Rohlf. 1995.
#Biometry: The Principles and Practices of Statistics in Biological Research.
#W. H. Freeman and Company, New York.

MEASURES <- array(0, dim=c(length(measures),numbernulls)) #To store measure answers.

edges <- sum(MATRIX>0)
r <- dim(MATRIX)[1]
c <- dim(MATRIX)[2]
M <- edges/(r*c)

for (aa in 1:numbernulls) {
	flag=0
        while (flag == 0) {

	
	TEST<- 1*( array(runif(r*c), dim=c(r,c)) < M )	
	
 	#sort
      	TEST<-sortMATRIX(TEST,binNull,sortVar)$sortMAT
      	
	flag=1
        if (length(dim(TEST)) < 2) {flag=0}
                            }

 	#measure
        #for (ww in 1:length(measures)) {
         #   MEASURES[ww,aa] <- measures[[ww]](TEST)
        #				}
	

			}
return(MEASURES)

}





