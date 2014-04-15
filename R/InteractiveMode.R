# InteractiveMode.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 15th April 2014


# SHORT SCRIPT WHICH QUESTIONS USER TO ASSESS THE COMPUTATIONS THEY WISH TO
# RUN

source('PERFORM_NESTED_TEST.R')
source('MISC/sortMATRIX.R')

#Q1. WHERE IS YOUR MATRIX? WHAT IS IT'S VARIABLE NAME?
flagQ1=1;

while (flagQ1==1) {
	reply1 = readline(cat('\nEnter the variable name of the matrix you wish to test.\nIf a variable is not yet assigned type "restart" and create a matrix variable before continuing, or type \n"generate" to generate a random matrix to test the code:\n\n'))

	if (reply1 == 'restart') {
    		stop('Exiting to allow user to create/import matrix.')
	} else if (reply1 == 'generate') {
		testflag=0  # generate a random matrix that is not degenerate - does not reduce to a empty/scalar/vector
		while (testflag==0) {
    		MATRIX=matrix(1*(runif(20)>0.45), nrow=4)
		TEST = sortMATRIX(MATRIX,1,1)$sortMAT
		testflag=1
		if (length(dim(TEST)) < 2) {testflag=0}
					}		
    		flagQ1=0
	} else if (exists(reply1)) {
    		MATRIX=get(reply1)
    		flagQ1=0
	} else {
		print(paste(reply1,' not found, please try again', sep=""))
			}

		}

print(MATRIX)

MEASURES <- c()

#Q - sort. Do you wish to sort the matrix or use predetermined sorting?
flagQsort=1

while (flagQsort==1) {
	replyS = readline(cat('\n- Do you wish to use the current matrix ordering or sort to maximise nestedness?\nThe way the matrix is ordered makes a difference to the NODF, DISCREPANCY\nand MANHATTAN DISTANCE measures.\nThis choice is applied both to the input and null model matrices.\nSelect 1 to sort or 0 to use current matrix ordering:\n\n'))


	if ((replyS == '0') || (replyS == '1')) {
    		flagQsort=0
		SORT = as.numeric(replyS)
	} else {
     		print('Please answer the question properly.')
		}
    				}

MEASURE <- c()

#Q2. WHICH MEASURE(s) DO YOU WISH TO TEST?
flagQ2=1
count=0
reply2all <- c()
while (flagQ2==1) {
	reply2 = readline(cat('\n- Which measure do you wish to use to measure nestedness? \nIf unsure we suggest using NODF, one of the more popular nestedness measures.\nSelect 1 for NODF , 2 for SPECTRAL RADIUS, 3 for MANHATTAN DISTANCE \n(used to calculate TAU-TEMPERATURE), 4 for JDMnestedness, 5 for NTC \nor 6 for DISCREPANCY.\n\n'))


	if (reply2=='1') {
    		count=count+1;
    		MEASURE[count]='NODF'
		CHECKER=as.numeric(reply2)
		reply2all <- c(reply2all, reply2)
   		flagQ2a = 1
   		while (flagQ2a == 1) {
			reply2a = readline(cat('\n- Do you want to add another measure? (Y/N)'))
			if ((reply2a =='n') || (reply2a=='N') || (reply2a=='no') || (reply2a=='No') || (reply2a=='NO')) {
				flagQ2=0
				flagQ2a=0
			} else if ((reply2a=='y') || (reply2a=='Y') || (reply2a=='yes') || (reply2a=='Yes') || (reply2a=='YES')) {
				flagQ2a=0
			} else {print('Please answer (Y/N)')}
				      }
	} else if (reply2=='2') {
    		count=count+1
    		MEASURE[count]='SPECTRAL_RADIUS'
		CHECKER=as.numeric(reply2)
		reply2all <- c(reply2all, reply2)
		flagQ2a = 1
   		while (flagQ2a == 1) {
			reply2a = readline(cat('\n- Do you want to add another measure? (Y/N)'))
			if ((reply2a =='n') || (reply2a=='N') || (reply2a=='no') || (reply2a=='No') || (reply2a=='NO')) {
				flagQ2=0
				flagQ2a=0
			} else if ((reply2a=='y') || (reply2a=='Y') || (reply2a=='yes') || (reply2a=='Yes') || (reply2a=='YES')) {
				flagQ2a=0
			} else {print('Please answer (Y/N)')}
				      }
	} else if (reply2=='3') {
    		count=count+1
    		MEASURE[count]='MANHATTAN_DISTANCE'
		CHECKER=as.numeric(reply2)
		reply2all <- c(reply2all, reply2)    
		flagQ2a = 1
   		while (flagQ2a == 1) {
			reply2a = readline(cat('\n- Do you want to add another measure? (Y/N)'))
			if ((reply2a =='n') || (reply2a=='N') || (reply2a=='no') || (reply2a=='No') || (reply2a=='NO')) {
				flagQ2=0
				flagQ2a=0
			} else if ((reply2a=='y') || (reply2a=='Y') || (reply2a=='yes') || (reply2a=='Yes') || (reply2a=='YES')) {
				flagQ2a=0
			} else {print('Please answer (Y/N)')}
				      }
	} else if (reply2=='4') {
    		count=count+1
    		MEASURE[count]='JDMnestedness'
		CHECKER=as.numeric(reply2)
		reply2all <- c(reply2all, reply2)    
		flagQ2a = 1
   		while (flagQ2a == 1) {
			reply2a = readline(cat('\n- Do you want to add another measure? (Y/N)'))
			if ((reply2a =='n') || (reply2a=='N') || (reply2a=='no') || (reply2a=='No') || (reply2a=='NO')) {
				flagQ2=0
				flagQ2a=0
			} else if ((reply2a=='y') || (reply2a=='Y') || (reply2a=='yes') || (reply2a=='Yes') || (reply2a=='YES')) {
				flagQ2a=0
			} else {print('Please answer (Y/N)')}
				      }
	} else if (reply2=='5') {
    		count=count+1
    		MEASURE[count]='NTC'
 		CHECKER=as.numeric(reply2)
		reply2all <- c(reply2all, reply2)  
		flagQ2a = 1
   		while (flagQ2a == 1) {
			reply2a = readline(cat('\n- Do you want to add another measure? (Y/N)'))
			if ((reply2a =='n') || (reply2a=='N') || (reply2a=='no') || (reply2a=='No') || (reply2a=='NO')) {
				flagQ2=0
				flagQ2a=0
			} else if ((reply2a=='y') || (reply2a=='Y') || (reply2a=='yes') || (reply2a=='Yes') || (reply2a=='YES')) {
				flagQ2a=0
			} else {print('Please answer (Y/N)')}
				      }
	} else if (reply2=='6') {
    		count=count+1
    		MEASURE[count]='DISCREPANCY'
		CHECKER=as.numeric(reply2)
		reply2all <- c(reply2all, reply2)    
   		flagQ2a = 1
   		while (flagQ2a == 1) {
			reply2a = readline(cat('\n- Do you want to add another measure? (Y/N)'))
			if ((reply2a =='n') || (reply2a=='N') || (reply2a=='no') || (reply2a=='No') || (reply2a=='NO')) {
				flagQ2=0
				flagQ2a=0
			} else if ((reply2a=='y') || (reply2a=='Y') || (reply2a=='yes') || (reply2a=='Yes') || (reply2a=='YES')) {
				flagQ2a=0
			} else {print('Please answer (Y/N)')}
				      }
	} else {
		print('Please answer the question properly.')
		}
			}

MEASURETEXT <- MEASURE

#Q3. WHICH NULL MODELS DO YOU WISH TO TEST?
flagQ3=1
null=c()
COUNT=0
NULLTEXT=c()

while (flagQ3==1) {
	reply3 = readline(cat('\n- Which null model do you wish to use to measure nestedness? \nIf unsure you could try using 1, where size and fill are conserved but uniformly randomly shuffled.\nSelect 1 for SS , 2 for FF, 3 for CC, 4 for DD, 5 for EE.\n\n'))


	if (reply3=='1') {
		CHECKER=as.numeric(reply3)
    		null=c(null, 1)
    		COUNT=COUNT+1
    		NULLTEXT[COUNT] =  'SS'
    		flagQ3a = 1
    		while (flagQ3a == 1) {
			reply3a = readline(cat('\n- Do you want to add another null model? (Y/N)'))
			if ((reply3a =='n') || (reply3a=='N') || (reply3a=='no') || (reply3a=='No') || (reply3a=='NO')) {
				flagQ3=0
				flagQ3a=0
			} else if ((reply3a =='y') || (reply3a=='Y') || (reply3a=='yes') || (reply3a=='Yes') || (reply3a=='YES')) {
				flagQ3a=0
			} else {print('Please answer (Y/N)')}
				      }
	} else if (reply3=='2') {
		CHECKER=as.numeric(reply3)
    		null=c(null, 2)
    		COUNT=COUNT+1
    		NULLTEXT[COUNT] =  'FF'
		flagQ3a = 1
    		while (flagQ3a == 1) {
			reply3a = readline(cat('\n- Do you want to add another null model? (Y/N)'))
			if ((reply3a =='n') || (reply3a=='N') || (reply3a=='no') || (reply3a=='No') || (reply3a=='NO')) {
				flagQ3=0
				flagQ3a=0
			} else if ((reply3a =='y') || (reply3a=='Y') || (reply3a=='yes') || (reply3a=='Yes') || (reply3a=='YES')) {
				flagQ3a=0
			} else {print('Please answer (Y/N)')}
				      }
	} else if (reply3=='3') {
		CHECKER=as.numeric(reply3)
    		null=c(null, 3)
    		COUNT = COUNT +1
    		NULLTEXT[COUNT] =  'CC'
		flagQ3a = 1
    		while (flagQ3a == 1) {
			reply3a = readline(cat('\n- Do you want to add another null model? (Y/N)'))
			if ((reply3a =='n') || (reply3a=='N') || (reply3a=='no') || (reply3a=='No') || (reply3a=='NO')) {
				flagQ3=0
				flagQ3a=0
			} else if ((reply3a =='y') || (reply3a=='Y') || (reply3a=='yes') || (reply3a=='Yes') || (reply3a=='YES')) {
				flagQ3a=0
			} else {print('Please answer (Y/N)')}
				      }
	} else if (reply3=='4') {
		CHECKER=as.numeric(reply3)
    		null=c(null, 4)
    		COUNT= COUNT+1
    		NULLTEXT[COUNT] =  'DD'
		flagQ3a = 1
    		while (flagQ3a == 1) {
			reply3a = readline(cat('\n- Do you want to add another null model? (Y/N)'))
			if ((reply3a =='n') || (reply3a=='N') || (reply3a=='no') || (reply3a=='No') || (reply3a=='NO')) {
				flagQ3=0
				flagQ3a=0
			} else if ((reply3a =='y') || (reply3a=='Y') || (reply3a=='yes') || (reply3a=='Yes') || (reply3a=='YES')) {
				flagQ3a=0
			} else {print('Please answer (Y/N)')}
				      }
	} else if (reply3=='5') {
		CHECKER=as.numeric(reply3)
    		null=c(null, 5)
    		COUNT=COUNT+1
    		NULLTEXT[COUNT] = 'EE'
		flagQ3a = 1
    		while (flagQ3a == 1) {
			reply3a = readline(cat('\n- Do you want to add another null model? (Y/N)'))
			if ((reply3a =='n') || (reply3a=='N') || (reply3a=='no') || (reply3a=='No') || (reply3a=='NO')) {
				flagQ3=0
				flagQ3a=0
			} else if ((reply3a =='y') || (reply3a=='Y') || (reply3a=='yes') || (reply3a=='Yes') || (reply3a=='YES')) {
				flagQ3a=0
			} else {print('Please answer (Y/N)')}
				      }
	} else {
		print('Please answer the question properly.')
		}
			}

#Q4. WHICH SOLVER DO WANT TO USE?

flagQ4=1
while (flagQ4==1 ) {
    
	reply4 =readline(cat('\n- Are you happy to use the adaptive method? Adaptive method (Y), Fixed method (N).\n\n'))

    	if ((reply4 =='y') || (reply4=='Y') || (reply4=='yes') || (reply4=='Yes') || (reply4=='YES')) {
        	METHOD='ADAPTIVE'
        	ensembleNum=c()
        	flagQ4=0
    	} else if ((reply4=='n') || (reply4=='N') || (reply4=='no') || (reply4=='No') || (reply4=='NO')) {
        	METHOD='FIXED'
        	flagQ5=1
        
        	while (flagQ5==1) {
        		reply = readline(cat('\n- How many null models do you want to test against?\n Literature tends to use between 1,000 and 10,000.\n\n'))
        		ensembleNum=as.numeric(reply)
    
            	if (ensembleNum>0) {
            		flagQ5=0
            	} else {
            		print('Please answer the question properly.')
            		}
        				}
    
        		flagQ4=0
    	} else {
		print('Please answer the question properly.')
    		}
				}

text=(paste(cat('Now performing the calculations on ',reply1,' to find the ',MEASURETEXT,' score(s); \nand test it against null model(s) ',NULLTEXT,' using the ',METHOD,' method.\n\n', sep="")))

print('Hold on whilst your output is calculated!')

ind=PERFORM_NESTED_TEST(MATRIX,1,SORT,MEASURE,null,ensembleNum,1)

text=paste(cat('Measure shows the ',MEASURETEXT, ' score(s), whilst pvalue shows how likely a more nested\nmeasure can be achieved by following the rules of the selected\nnull model( 1 every time, 0 never).Mean shows the average measure from the null ensemble.\nOther statistics are also shown.\n\n',sep=""))

for (jj in 1:length(null)) {
   	text=paste(cat('Output for binary null model ',null[jj],' (',NULLTEXT[jj],') is as follows:\n\n'))
	print(get(paste('Bin_t',null[jj],sep=""), ind))

			}

if (sum(as.numeric(reply2all)==3)>=1) {
    print('The Tau-Temperature is shown here as the NormalisedTemperature and is calculated as Measure divided by Mean.')
    print('Tau-Temperature above 1 indicates the matrix was less nested than expected, whilst below 1 indicates it was')
    print('more nested than expected under the null ensemble.')
			}

Sys.sleep(2)

print('The nested configuration of your input matrix is:')

print(ind$NestedConfig$DegreeMatrix)

print("You can access everything by typing in 'ind' and navigating its structure")


