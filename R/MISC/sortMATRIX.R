# sortMAT.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 9th April 2014

sortMATRIX <- function(MATRIX,binary,sortvar) {


rows <- dim(MATRIX)[1]
cols <- dim(MATRIX)[2]

## STAGE 1  - remove zero rows/columns

#Sorts the binary positions of matrix MAT in terms of row and column degree.
BMAT <- 1*(MATRIX!=0);

colsum <- colSums(BMAT)
rowsum <- rowSums(BMAT)


JJ <- which(colsum==0);#Find indexes of columns with no interactions
KK <- which(rowsum==0);#Find indexes of rows with no interactions

index_rows <- 1:rows;
index_cols <- 1:cols;

#remove these
sortMAT <- MATRIX;
if (sum(JJ) > 0) {
sortMAT <- sortMAT[,-JJ]
index_cols<-index_cols[-JJ];
}

if (length(dim(sortMAT)) < 2) {
	sortMAT <- sortMAT[-KK]
	index_rows<-index_rows[-KK]
	} else if (sum(KK) >0) {
	sortMAT <- sortMAT[-KK,]
	index_rows<-index_rows[-KK]
				}


## STAGE 2 -- maximal sorting

if (sortvar==1) {#If want to package matrices in degree ordered way

#BINARY SORTMAT.
	  BMAT <- 1*(sortMAT!=0);
    
#Sort rows and columns in decending order to find zero rows, columns.
#This is the sort for entire matrix which may contain zero rows and
#columns.
	  if (length(dim(BMAT)) == 2) { #if not a matrix after removing rows and columns, then sortMAT is not changed 
		  new<-sort(rowSums(BMAT),decreasing=TRUE,index.return=TRUE)
		  new.index_rows <- new$ix
		  new<-sort(colSums(BMAT),decreasing=TRUE,index.return=TRUE)
		  new.index_cols <-new$ix

		  index_rows = index_rows[new.index_rows];
		  index_cols = index_cols[new.index_cols];

		  sortMAT <- MATRIX[index_rows,index_cols];
			     

## STAGE 3 - If input matrix not binary

		  if ((sum(sum( (MATRIX==0) + (MATRIX==1)))!=rows*cols) && (binary!=1)) {
			  BMAT <- 1*(sortMAT!=0)
			  
			  colsum <- colSums(BMAT);
			  rowsum <- rowSums(BMAT);

			  JJ <- unique(colsum);
			  KK <- unique(rowsum);

			  if (length(JJ) < dim(BMAT)[2]) { #If more than 1 column with same degree choose ordering
  
				    for (aa in 1:length(JJ)) {
					if (sum(colsum==JJ[aa])>1) { #If more than one occurance
					    indexes <- which(colsum==JJ[aa]);
					    
					    HH <- matrix(0,length(indexes),length(indexes));
							  
					    for (RR in 1:dim(HH)[1]) {
						for (CC in 1:dim(HH)[2]) {
						    HH[RR,CC] <- sum(sortMAT[,indexes[RR]]>sortMAT[,indexes[CC]]);
						}
					    }
                
                
				      select <- colSums(HH);
				      unis <- unique(select);
				      if (length(unis) < length(select)) {
					  for (uu in 1:length(unis)) {
					      if (sum(select==unis[uu])>1) {#if more than 1 value of this
						  nextind <- which(select==unis[uu]);
						  select[nextind] <- 0.5*(colSums(sortMAT[,nextind])/(sum(sortMAT[,nextind])));
					      }
					  }
				      
				      }
                
					      new <- sort(colSums(HH),index.return=TRUE);
					      ind <- new$ix
					      
							      
					      index_cols[indexes] <- index_cols[indexes[ind]];
					      
					      
					      sortMAT[,indexes] <- sortMAT[,indexes[ind]];
		      
                
								      }
								}
							    }

			  if (length(KK) < dim(BMAT)[1]) { #If more than 1 row with same degree choose ordering

			      for (aa in 1:length(KK)) {
				      if (sum(rowsum==KK[aa])>1) { #If more than one occurance
					  indexes <- which(rowsum==KK[aa]);
					  
					  HH <- matrix(0,length(indexes),length(indexes));
							
					  for (RR in 1:dim(HH)[1]) {
					      for (CC in 1:dim(HH)[2]) {
						  HH[RR,CC] <- sum(sortMAT[indexes[RR],]>sortMAT[indexes[CC],]);
					      }
					  }
					  
					  select <- rowSums(HH);
					  unis <- unique(select);
					  if (length(unis) < length(select)) {
					      for (uu in 1:length(unis)) {
						  if (sum(select==unis[uu])>1) { #if more than 1 value of this
						      nextind <- which(select==unis[uu]);
						      select[nextind] <- 0.5*(rowSums(sortMAT[nextind,])/(sum(sortMAT[nextind,])));
						  }
					      }
					  
					  }
					  
					  
					  new <- sort(colSums(HH),index.return=TRUE);
					  ind <- new$ix
					  
					  index_rows[indexes] <- index_rows[indexes[ind]];
					  
					  
					  sortMAT[indexes,] <- sortMAT[indexes[ind],];
					      
					  
				      }
					      
			      }
			      
			      

			  }

			sortMAT <- MATRIX[index_rows,index_cols];


			  }

	}
	
		
		      
		      
}



#FINALLY IF WANT TO RETURN A BINARY MATRIX
if (binary==1) {
    sortMAT <- 1*(sortMAT!=0);
		}
		
return(list(sortMAT=sortMAT,index_rows=index_rows,index_cols=index_cols))

}









