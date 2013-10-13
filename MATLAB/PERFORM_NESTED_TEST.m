function [indicators]=PERFORM_NESTED_TEST(MAT, bintest, functhand ,nullmodels,THRESHOLD_IN,EnsembleNumber,plotON)

indicators=[];
%echo back user inputs
indicators.binary=bintest;
indicators.MEASURE=functhand;
indicators.nulls=nullmodels;
indicators.thresh=THRESHOLD_IN;
indicators.ensNum=EnsembleNumber;


%Include path to where required functions are stored
g = genpath('../MATLAB/');
addpath(g);


%% ARGUMENT DESCRIPTIONS

%- indicators is a structure to store results of ensembles in

%- MAT is the matrix array to be analysed

%- bintest is a value to indicate whether the test is binary(1) or not(0). If not
%quantitative measures are not calculated. If it can be both (spectral
%radius) then bintest should take a value of 2

%- functhand is a string that corresponds to the measure being analysed and
%should be one of the function names in the measures section e.g. to run
%the analysis on the NODF method, functhand='NODF'

%- nullmodels is a vector argument to set which null models should be
%performed. e.g. nullmodels=[1,3] will lead to the first and third null
%models being performed. If it is left as empty (nullmodels=[]), then all
%models(according to metric type) will be performed. To reduce confusion
%binary null models are labelled with positive and increasing integers,
%whilst quantitative null models are labelled with negative decreasing integers

%- THRESHOLD_IN is the inputted value for threshold tolerance when
%comparing the two ensemble groups, it is used in function ADAPTIVESOLVER

%- EnsembleNumber is an argument which defines whether or not to use the
%adaptive ensemble number framework. This is used when set as empty ([]),
%otherwise a fixed ensemble number of null model comparisons is made. It is
%used in function FIXEDSOLVER

%- plotON is the variable that determines whether a histogram should be
%made displaying the measures found in the null ensemble and comparing it
%to the measure of the test matrix. 1 indicates the plot should be created,
%0 indicates the plot should not be created.

%% REFERENCES

%If you use this code to perform analysis you can cite it as:

%Beckett S.J., Williams H.T.P., 2013. FALCON for Nestedness Analysis.


%Please also cite the appropriate papers(listed below) for the
%measures/null models you choose to evaluate.


%Current measures and papers to cite in brackets

%NODF (Almeida-Neto et al., 2008 : Oikos, 117(8):1227-1239)
%WNODF (Almeida-Neto & Ulrich, 2011 : Environmental Modelling & Software, 26(2):173-178)
%WNODF_REVERSE (Beckett & Williams, in prep.)
%TAU_TEMPERATURE (Corso & Britton, 2012 : Ecological Complexity 11:137-143)
%SPECTRAL_RADIUS (Staniczenko et al., 2013 : Nature Communications 4:1391)

%Current null models and papers to cite in brackets
BnullNumber=3;
%CREATEBINNULL1
%CREATEBINNULL2 (Miklos & Podani, 2004 : Ecology, 85(1):86-92)
%CREATEBINNULL3 (Beckett & Williams, in prep.)
QnullNumber=3;
%CREATEQUANTNULL1 (Staniczenko et al., 2013 : Nature Communications 4:1391)
%CREATEQUANTNULL2 (Beckett & Williams, in prep.)
%CREATEQUANTNULL3 (Beckett & Williams, in prep.)



%% ERROR HANDLING & SETUP

if plotON~=0 && plotON~=1
    error('Error in value of plotON variable. Should be 1 (plot) or 0 (no plot).')
end

if sum(nullmodels>BnullNumber)>0 || sum(nullmodels<-QnullNumber)>0 || sum(nullmodels==0)>0
    error('Have you set the argument nullmodels correctly? Should be the empty set([]) or vector containing the null model number(s) you wish to compute. If you have extended the code are the variables BnullNumber and QnullNumber set correctly?')
end

if bintest~=0 && bintest~=1 && bintest~=2
    error('Check variable bintest. Is the metric you want to evaluate a binary test? Choose 1 for binary testing, 0 for quantitative testing and 2 for both.')
end

if EnsembleNumber<=0
    error('Cannot perform that number of runs in the ensemble. Set as positive integer to perform that many null model test comparisons, else leave as the empty set([]) to run using the adaptive solver')
end
    

if isempty(EnsembleNumber)
    SOLVER=str2func('ADAPTIVESOLVER');
    extraArg=THRESHOLD_IN;
else
    SOLVER=str2func('FIXEDSOLVER');
    extraArg=EnsembleNumber;
end

%% Sort Matrix
[BinarySortedMAT,QSortedMAT,info]=sortMAT(MAT,bintest);
indicators.Matrix=MAT; %input matrix
indicators.NestedConfig=indicators.Matrix(info.index_rows,info.index_cols);%nested matrix
indicators.index_rows=info.index_rows;%nested matrix row indices
indicators.index_cols=info.index_cols;%nested matrix column indices

%% PERFORM TESTS 

MEASURE=str2func(functhand);

%measure and solvers
if bintest==1 || bintest==2
    Bmeasure=MEASURE(BinarySortedMAT);
    if sum(nullmodels==1)>0 || isempty(nullmodels)
    indicators.Bin_t1=[];
    indicators.Bin_t1=SOLVER(indicators.Bin_t1,functhand,BinarySortedMAT,Bmeasure,'CREATEBINNULL1',1,extraArg,plotON);
    end
    if sum(nullmodels==2)>0 || isempty(nullmodels)
    indicators.Bin_t2=[];
    indicators.Bin_t2=SOLVER(indicators.Bin_t2,functhand,BinarySortedMAT,Bmeasure,'CREATEBINNULL2',1,extraArg,plotON);
    end
    if sum(nullmodels==3)>0 || isempty(nullmodels)
    indicators.Bin_t3=[];
    indicators.Bin_t3=SOLVER(indicators.Bin_t3,functhand,BinarySortedMAT,Bmeasure,'CREATEBINNULL3',1,extraArg,plotON);
    end
end

if bintest==0 || bintest==2
    Qmeasure=MEASURE(QSortedMAT);
    if sum(nullmodels==-1)>0 || isempty(nullmodels)
    indicators.Qua_t1=[];
    indicators.Qua_t1=SOLVER(indicators.Qua_t1,functhand,QSortedMAT,Qmeasure,'CREATEQUANTNULL1',0,extraArg,plotON);
    end
    if sum(nullmodels==-2)>0 || isempty(nullmodels)
    indicators.Qua_t2=[];
    indicators.Qua_t2=SOLVER(indicators.Qua_t2,functhand,QSortedMAT,Qmeasure,'CREATEQUANTNULL2',0,extraArg,plotON);
    end
    if sum(nullmodels==-3)>0 || isempty(nullmodels)
    indicators.Qua_t3=[];
    indicators.Qua_t3=SOLVER(indicators.Qua_t3,functhand,QSortedMAT,Qmeasure,'CREATEQUANTNULL3',0,extraArg,plotON);
    end
end


end
