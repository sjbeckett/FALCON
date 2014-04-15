# PERFORM_NESTED_TEST.R
# Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
# Nestedness) package: https://github.com/sjbeckett/FALCON
# Last updated: 15th April 2014


PERFORM_NESTED_TEST <- function(MAT, bintest=1, sortVar=1, functhand ,nullmodels=c(),EnsembleNumber=c(),plotON=1) {

indicators <- list()         
#echo back user inputs
indicators$binary <- bintest
print(paste('Binary = ',indicators$binary,sep=""))
indicators$sorting <- sortVar
print(paste('Sorting = ',indicators$sorting,sep=""))
indicators$MEASURE <-functhand
print(paste('Measures = ',indicators$MEASURE, sep=""))
indicators$nulls <- nullmodels
if (length(nullmodels) == 0) {
	  print('Nulls = All')
	} else {
	  print(paste('Nulls = ',indicators$nulls,sep=""))
	      }
indicators$ensNum <- EnsembleNumber
if (length(EnsembleNumber) == 0) {
	  print('EnsembleNumber = Adaptive')
	} else {
	  print(paste('EnsembleNumber = ',indicators$ensNum, sep=""))
		}
indicators$plot <- plotON
print(paste('Plotting = ',indicators$plot,sep=""))

if("NTC" %in% functhand == TRUE) {
	if("vegan" %in% rownames(installed.packages()) == FALSE) {
		      print("Attempting to install 'vegan' package to run NTC")
		      install.packages('vegan')
		      library('vegan')
	 } else {
		      library('vegan')
				  }
				  }


#Include path to where required functions are stored
    file.sources <- list.files(c("MISC", "MEASURES","NULLS","METHODS"),pattern="*.R$",full.names=TRUE,ignore.case=TRUE)
    for (i in 1:length(file.sources)) {
	      source(file.sources[i])
				      }


## ARGUMENT DESCRIPTIONS

#- indicators is a structure to store results of ensembles in

#- MAT is the matrix array to be analysed

#- bintest is a value to indicate whether the test is binary(1) or not(0). If not
#quantitative measures are not calculated. If it can be both (spectral
#radius) then bintest should take a value of 2

#- sortVar is a value to indicate whether matrices should be sorted to maximise
#nestedness (1) before being measured, or to be left as input/created (0). This
#makes a difference to NODF, MANHATTAN_DISTANCE and DISCREPANCY measures only.

#- functhand is a string that corresponds to the measure being analysed and
#should be one of the function names in the measures section e.g. to run
#the analysis on the NODF method, functhand='NODF'; to run the analysis using
# NODF and the NTC, functhand=c('NODF','NTC')

#- nullmodels is a vector argument to set which null models should be
#performed. e.g. nullmodels=c(1,3) will lead to the first and third null
#models being performed. If it is left as empty (nullmodels=c()), then all
#models(according to metric type) will be performed. To reduce confusion
#binary null models are labelled with positive and increasing integers,
#whilst quantitative null models are labelled with negative decreasing integers

#- EnsembleNumber is an argument which defines whether or not to use the
#adaptive ensemble number framework. This is used when set as empty (c()),
#otherwise a fixed ensemble number of null model comparisons is made. It is
#used in function FIXEDMETHOD

#- plotON is the variable that determines whether a histogram should be
#made displaying the measures found in the null ensemble and comparing it
#to the measure of the test matrix. 1 indicates the plot should be created,
#0 indicates the plot should not be created.

## REFERENCES

#If you use this code to perform analysis you can cite it as:

#Beckett S.J., Boulton C.A., Williams H.T.P., 2014. FALCON: nestedness statistics for bipartite networks. figshare. (http://dx.doi.org/10.6084/m9.figshare.999117)


#Please also cite the appropriate papers(listed below) for the
#measures/null models you choose to evaluate.


#Current measures and papers to cite in brackets

#NODF (Almeida-Neto et al., 2008 : Oikos, 117(8):1227-1239 (http://dx.doi.org/10.1111/j.0030-1299.2008.16644.x)  )
#WNODF (Almeida-Neto & Ulrich, 2011 : Environmental Modelling & Software, 26(2):173-178  (http://dx.doi.org/10.1016/j.envsoft.2010.08.003))
#MANHATTAN_DISTANCE (Corso & Britton, 2012 : Ecological Complexity 11:137-143  (http://dx.doi.org/10.1016/j.ecocom.2012.05.003))
#SPECTRAL_RADIUS (Staniczenko et al., 2013 : Nature Communications 4:1391 (http://dx.doi.org/10.1038/ncomms2422))
#NTC (Oksanen et al., 2013 : vegan: community ecology package. R package version 2.0-9. http://CRAN.R-project.org/package=vegan))
#DISCREPANCY (Brualdi & Sanderson, 1999 : Oecologia 119(2): 256-264 (http://dx.doi.org/10.1007/s004420050784))

#Current null models and papers to cite in brackets
BnullNumber=5;
#CREATEBINNULL1 (Gotelli, 2000 : Ecology 81: 2606-2621)
#CREATEBINNULL2 (Miklos & Podani, 2004 : Ecology, 85(1):86-92  (http://dx.doi.org/10.1890/03-0101);
#Gotelli & Ulrich, 2011 : Ecological Modelling 222:1337–1339 (http://dx.doi.org/10.1016/j.ecolmodel.2010.11.008))
#CREATEBINNULL3 (Beckett, Boulton & Williams, in prep.) ()
#CREATEBINNULL4 (Bascompte et al., 2003 : PNAS 100(16):9383-9387  (http://dx.doi.org/10.1073/pnas.1633576100)
#CREATEBINNULL5
QnullNumber=4;
#CREATEQUANTNULL1 (Staniczenko et al., 2013 : Nature Communications 4:1391 (http://dx.doi.org/10.1038/ncomms2422))
#CREATEQUANTNULL2 (Beckett, Boulton & Williams, in prep.) ()
#CREATEQUANTNULL3 (Beckett, Boulton & Williams, in prep.) ()
#CREATEQUANTNULL4 (Beckett, Boulton & Williams, in prep.) ()



## ERROR HANDLING & SETUP

if (plotON!=0 && plotON!=1)
    stop('Error in value of plotON variable. Should be 1 (plot) or 0 (no plot).')


if (sum(nullmodels>BnullNumber)>0 || sum(nullmodels< -QnullNumber)>0 || sum(nullmodels==0)>0)
    stop('Have you set the argument nullmodels correctly? Should be the empty set([]) or vector containing the null model number(s) you wish to compute. If you have extended the code are the variables BnullNumber and QnullNumber set correctly?')


if (bintest!=0 && bintest!=1 && bintest!=2)
    stop('Check variable bintest. Is the metric you want to evaluate a binary test? Choose 1 for binary testing, 0 for quantitative testing and 2 for both.')


if (sortVar!=0 && sortVar!=1)
    stop('Error in sortVar value. Should be 1 (sort) or 0 (no sort).')


if ((length(EnsembleNumber)==1 && EnsembleNumber <= 0) || (length(EnsembleNumber) > 1))
    stop('Cannot perform that number of runs in the ensemble. Set as positive integer to perform that many null model test comparisons, else leave as the empty set([]) to run using the adaptive solver')


if (length(EnsembleNumber)==0) {
    SOLVER=get('ADAPTIVEMETHOD')
    extraArg <- NULL
}
else {
    SOLVER <- get('FIXEDMETHOD')
    extraArg <- EnsembleNumber
}

## Sort Matrix
info <- sortMATRIX(MAT,0,sortVar)
QuantitativeMAT <- info$sortMAT
BinaryMAT <- 1*(QuantitativeMAT!=0)

indicators$Matrix$Matrix <- MAT; #input matrix
indicators$Matrix$fill <- sum(MAT!=0)
indicators$Matrix$connectance <- indicators$Matrix$fill/(dim(MAT)[1]*dim(MAT)[2])
indicators$NestedConfig$DegreeMatrix <- indicators$Matrix$Matrix[info$index_rows,info$index_cols]#nested matrix
indicators$NestedConfig$Degreeindex_rows <- info$index_rows#nested matrix row indices
indicators$NestedConfig$Degreeindex_cols <- info$index_cols#nested matrix column indices

## PERFORM TESTS 

MEASURE <- mget(functhand,envir=as.environment(1)) #Converts measure strings to functions

summarytableaddition <- rep(0,5)


#measure and solvers
if (bintest==1 || bintest==2) {
    Bmeasure <- rep(0,length(functhand))

    for (ww in 1:length(functhand))
	Bmeasure[ww] <- MEASURE[[ww]](BinaryMAT)
    
    if (sum(nullmodels==1)>0 || length(nullmodels)==0) {  
    print('Binary null 1:')
    indicators$Bin_t1 <- SOLVER(indicators$Bin_t1,functhand,BinaryMAT,Bmeasure,'CREATEBINNULL1',1,extraArg,sortVar,plotON)
    summarytableaddition <- summarytableaddition + colSums(indicators$Bin_t1$SignificanceTable) 
    }
    if (sum(nullmodels==2)>0 || length(nullmodels)==0) {
    print('Binary null 2:')
    indicators$Bin_t2 <- SOLVER(indicators$Bin_t2,functhand,BinaryMAT,Bmeasure,'CREATEBINNULL2',1,extraArg,sortVar,plotON)
    summarytableaddition <- summarytableaddition + colSums(indicators$Bin_t2$SignificanceTable)
    }
    if (sum(nullmodels==3)>0 || length(nullmodels)==0) {
    print('Binary null 3:')
    indicators$Bin_t3 <- SOLVER(indicators$Bin_t3,functhand,BinaryMAT,Bmeasure,'CREATEBINNULL3',1,extraArg,sortVar,plotON)
    summarytableaddition <- summarytableaddition + colSums(indicators$Bin_t3$SignificanceTable)
    }
    if (sum(nullmodels==4)>0 || length(nullmodels)==0) {
    print('Binary null 4:')
    indicators$Bin_t4 <- SOLVER(indicators$Bin_t4,functhand,BinaryMAT,Bmeasure,'CREATEBINNULL4',1,extraArg,sortVar,plotON)
    summarytableaddition <- summarytableaddition + colSums(indicators$Bin_t4$SignificanceTable)
    }
    if (sum(nullmodels==5)>0 || length(nullmodels)==0) {
    print('Binary null 5:')
    indicators$Bin_t5 <- SOLVER(indicators$Bin_t5,functhand,BinaryMAT,Bmeasure,'CREATEBINNULL5',1,extraArg,sortVar,plotON)
    summarytableaddition <- summarytableaddition + colSums(indicators$Bin_t5$SignificanceTable)
    }
}

if (bintest==0 || bintest==2) {
    Qmeasure <- rep(0,length(functhand))

    for (ww in 1:length(functhand))
    	Qmeasure[ww] <- MEASURE[[ww]](QuantitativeMAT)
    
    if (sum(nullmodels==-1)>0 || length(nullmodels)==0) {
    print('Quantitative null 1:')
    indicators$Qua_t1 <- SOLVER(indicators$Qua_t1,functhand,QuantitativeMAT,Qmeasure,'CREATEQUANTNULL1',0,extraArg,sortVar,plotON)
    summarytableaddition <- summarytableaddition + colSums(indicators$Qua_t1$SignificanceTable)
    }
    if (sum(nullmodels==-2)>0 || length(nullmodels)==0) {
    print('Quantitative null 2:')
    indicators$Qua_t2 <- SOLVER(indicators$Qua_t2,functhand,QuantitativeMAT,Qmeasure,'CREATEQUANTNULL2',0,extraArg,sortVar,plotON)
    summarytableaddition <- summarytableaddition + colSums(indicators$Qua_t2$SignificanceTable)
    }
    if (sum(nullmodels==-3)>0 || length(nullmodels)==0) {
    print('Quantitative null 3:')
    indicators$Qua_t3 <- SOLVER(indicators$Qua_t3,functhand,QuantitativeMAT,Qmeasure,'CREATEQUANTNULL3',0,extraArg,sortVar,plotON)
    summarytableaddition <- summarytableaddition + colSums(indicators$Qua_t3$SignificanceTable)
    }
    if (sum(nullmodels==-4)>0 || length(nullmodels)==0) {
    print('Quantitative null 4:')
    indicators$Qua_t4 <- SOLVER(indicators$Qua_t4,functhand,QuantitativeMAT,Qmeasure,'CREATEQUANTNULL4',0,extraArg,sortVar,plotON)
    summarytableaddition <- summarytableaddition + colSums(indicators$Qua_t4$SignificanceTable)
    }
}

#Significance summary table
indicators$SignificanceTableSummary <- summarytableaddition  

return(indicators)
}
