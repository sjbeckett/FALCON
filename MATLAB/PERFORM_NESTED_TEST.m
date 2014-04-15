% PERFORM_NESTED_TEST.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 15th April 2014


function [indicators]=PERFORM_NESTED_TEST(MAT, bintest, sortVar, functhand ,nullmodels,EnsembleNumber,plotON)

more off; %Turns paging off (useful for displaying computations in Octave)


indicators=[];
%echo back user inputs
indicators.binary=bintest;
indicators.sorting=sortVar;
indicators.MEASURE=functhand;
indicators.nulls=nullmodels;
indicators.ensNum=EnsembleNumber;
indicators.plot=plotON;
disp(indicators)


%Include path to where required functions are stored
g = genpath('../MATLAB/');
addpath(g);


%% ARGUMENT DESCRIPTIONS

%- indicators is a structure to store results of ensembles in

%- MAT is the matrix array to be analysed

%- bintest is a value to indicate whether the test is binary(1) or not(0). If not
%quantitative measures are not calculated. If it can be both (spectral
%radius) then bintest should take a value of 2

%- sortVar is a value to indicate whether matrices should be sorted to maximise
%nestedness (1) before being measured, or to be left as input/created (0). This
%makes a difference to NODF, MANHATTAN_DISTANCE and DISCREPANCY measures only.

%- functhand is a string that corresponds to the measure being analysed and
%should be one of the function names in the measures section e.g. to run
%the analysis on the NODF method, functhand={'NODF'}; to run the analysis using
% NODF and the NTC, functhand={'NODF','NTC'}

%- nullmodels is a vector argument to set which null models should be
%performed. e.g. nullmodels=[1,3] will lead to the first and third null
%models being performed. If it is left as empty (nullmodels=[]), then all
%models(according to metric type) will be performed. To reduce confusion
%binary null models are labelled with positive and increasing integers,
%whilst quantitative null models are labelled with negative decreasing integers

%- EnsembleNumber is an argument which defines whether or not to use the
%adaptive ensemble number framework. This is used when set as empty ([]),
%otherwise a fixed ensemble number of null model comparisons is made. It is
%used in function FIXEDMETHOD

%- plotON is the variable that determines whether a histogram should be
%made displaying the measures found in the null ensemble and comparing it
%to the measure of the test matrix. 1 indicates the plot should be created,
%0 indicates the plot should not be created.

%% REFERENCES

%If you use this code to perform analysis you can cite it as:


%Beckett S.J., Boulton C.A., Williams H.T.P., 2014. FALCON: nestedness statistics for bipartite networks. figshare. (http://dx.doi.org/10.6084/m9.figshare.999117)


%Please also cite the appropriate papers(listed below) for the
%measures/null models you choose to evaluate.


%Current measures and papers to cite in brackets

%NODF (Almeida-Neto et al., 2008 : Oikos, 117(8):1227-1239 (http://dx.doi.org/10.1111/j.0030-1299.2008.16644.x)  )
%WNODF (Almeida-Neto & Ulrich, 2011 : Environmental Modelling & Software, 26(2):173-178  (http://dx.doi.org/10.1016/j.envsoft.2010.08.003))
%MANHATTAN_DISTANCE (Corso & Britton, 2012 : Ecological Complexity 11:137-143  (http://dx.doi.org/10.1016/j.ecocom.2012.05.003))
%SPECTRAL_RADIUS (Staniczenko et al., 2013 : Nature Communications 4:1391 (http://dx.doi.org/10.1038/ncomms2422))
%NTC (Oksanen et al., 2013 : vegan: community ecology package. R package version 2.0-9. http://CRAN.R-project.org/package=vegan))
%DISCREPANCY (Brualdi & Sanderson, 1999 : Oecologia 119(2): 256-264 (http://dx.doi.org/10.1007/s004420050784))

%Current null models and papers to cite in brackets
BnullNumber=5;
%CREATEBINNULL1 (Gotelli, 2000 : Ecology 81: 2606-2621)
%CREATEBINNULL2 (Miklos & Podani, 2004 : Ecology, 85(1):86-92  (http://dx.doi.org/10.1890/03-0101);
%Gotelli & Ulrich, 2011 : Ecological Modelling 222:1337–1339 (http://dx.doi.org/10.1016/j.ecolmodel.2010.11.008))
%CREATEBINNULL3 (Beckett, Boulton & Williams, in prep.) ()
%CREATEBINNULL4 (Bascompte et al., 2003 : PNAS 100(16):9383-9387  (http://dx.doi.org/10.1073/pnas.1633576100)
%CREATEBINNULL5 
QnullNumber=4;
%CREATEQUANTNULL1 (Staniczenko et al., 2013 : Nature Communications 4:1391 (http://dx.doi.org/10.1038/ncomms2422))
%CREATEQUANTNULL2 (Beckett, Boulton & Williams, in prep.) ()
%CREATEQUANTNULL3 (Beckett, Boulton & Williams, in prep.) ()
%CREATEQUANTNULL4 (Beckett, Boulton & Williams, in prep.) ()



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

if sortVar~=0 && sortVar~=1
    error('Error in sortVar value. Should be 1 (sort) or 0 (no sort).')
end

if EnsembleNumber<=0
    error('Cannot perform that number of runs in the ensemble. Set as positive integer to perform that many null model test comparisons, else leave as the empty set([]) to run using the adaptive solver')
end
    

if isempty(EnsembleNumber)
    SOLVER=str2func('ADAPTIVEMETHOD');
    extraArg=[];
else
    SOLVER=str2func('FIXEDMETHOD');
    extraArg=EnsembleNumber;
end

%% Sort Matrix
[~, info] = sortMATRIX(MAT,0,1);
[QuantitativeMAT ~] = sortMATRIX(MAT,0,sortVar);
BinaryMAT=1*(QuantitativeMAT~=0);

if min(size(BinaryMAT))<=1 %If empty/scalar/vector - don't want!
    error('Error in entered matrix - matrix is degenerate (reduces to empty/scalar/vector value). Cannot perform nestedness analysis on this matrix.')
end


indicators.Matrix.Matrix=MAT; %input matrix
indicators.Matrix.fill = sum(sum(MAT~=0));
indicators.Matrix.connectance = indicators.Matrix.fill/(size(MAT,1)*size(MAT,2));
indicators.NestedConfig.DegreeMatrix=indicators.Matrix.Matrix(info.index_rows,info.index_cols);%nested matrix
indicators.NestedConfig.Degreeindex_rows=info.index_rows;%nested matrix row indices
indicators.NestedConfig.Degreeindex_cols=info.index_cols;%nested matrix column indices


%% PERFORM TESTS 

for ww=1:length(functhand)
MEASURE{ww}=str2func(functhand{ww});
end

summarytableaddition=zeros(1,5);

%measure and solvers
if bintest==1 || bintest==2
    for ww=1:length(functhand)
    Bmeasure(ww)=MEASURE{ww}(BinaryMAT);
    end
    if sum(nullmodels==1)>0 || isempty(nullmodels)
    indicators.Bin_t1=[];
    indicators.Bin_t1=SOLVER(indicators.Bin_t1,functhand,BinaryMAT,Bmeasure,'CREATEBINNULL1',1,extraArg,sortVar,plotON);
    summarytableaddition = summarytableaddition + sum(indicators.Bin_t1.SignificanceTable,1);
    end
    if sum(nullmodels==2)>0 || isempty(nullmodels)
    indicators.Bin_t2=[];
    indicators.Bin_t2=SOLVER(indicators.Bin_t2,functhand,BinaryMAT,Bmeasure,'CREATEBINNULL2',1,extraArg,sortVar,plotON);
    summarytableaddition = summarytableaddition + sum(indicators.Bin_t2.SignificanceTable,1);
    end
    if sum(nullmodels==3)>0 || isempty(nullmodels)
    indicators.Bin_t3=[];
    indicators.Bin_t3=SOLVER(indicators.Bin_t3,functhand,BinaryMAT,Bmeasure,'CREATEBINNULL3',1,extraArg,sortVar,plotON);
    summarytableaddition = summarytableaddition + sum(indicators.Bin_t3.SignificanceTable,1);
    end
    if sum(nullmodels==4)>0 || isempty(nullmodels)
    indicators.Bin_t4=[];
    indicators.Bin_t4=SOLVER(indicators.Bin_t4,functhand,BinaryMAT,Bmeasure,'CREATEBINNULL4',1,extraArg,sortVar,plotON);
    summarytableaddition = summarytableaddition + sum(indicators.Bin_t4.SignificanceTable,1);
    end
    if sum(nullmodels==5)>0 || isempty(nullmodels)
    indicators.Bin_t5=[];
    indicators.Bin_t5=SOLVER(indicators.Bin_t5,functhand,BinaryMAT,Bmeasure,'CREATEBINNULL5',1,extraArg,sortVar,plotON);
    summarytableaddition = summarytableaddition + sum(indicators.Bin_t5.SignificanceTable,1);
    end
end

if bintest==0 || bintest==2
    for ww=1:length(functhand)
    Qmeasure(ww)=MEASURE{ww}(QuantitativeMAT);
    end
    if sum(nullmodels==-1)>0 || isempty(nullmodels)
    indicators.Qua_t1=[];
    indicators.Qua_t1=SOLVER(indicators.Qua_t1,functhand,QuantitativeMAT,Qmeasure,'CREATEQUANTNULL1',0,extraArg,sortVar,plotON);
    summarytableaddition = summarytableaddition + sum(indicators.Qua_t1.SignificanceTable,1);
    end
    if sum(nullmodels==-2)>0 || isempty(nullmodels)
    indicators.Qua_t2=[];
    indicators.Qua_t2=SOLVER(indicators.Qua_t2,functhand,QuantitativeMAT,Qmeasure,'CREATEQUANTNULL2',0,extraArg,sortVar,plotON);
    summarytableaddition = summarytableaddition + sum(indicators.Qua_t2.SignificanceTable,1);
    end
    if sum(nullmodels==-3)>0 || isempty(nullmodels)
    indicators.Qua_t3=[];
    indicators.Qua_t3=SOLVER(indicators.Qua_t3,functhand,QuantitativeMAT,Qmeasure,'CREATEQUANTNULL3',0,extraArg,sortVar,plotON);
    summarytableaddition = summarytableaddition + sum(indicators.Qua_t3.SignificanceTable,1);
    end
    if sum(nullmodels==-4)>0 || isempty(nullmodels)
    indicators.Qua_t4=[];
    indicators.Qua_t4=SOLVER(indicators.Qua_t4,functhand,QuantitativeMAT,Qmeasure,'CREATEQUANTNULL4',0,extraArg,sortVar,plotON);
    summarytableaddition = summarytableaddition + sum(indicators.Qua_t4.SignificanceTable,1);
    end
end

%Significance summary table
indicators.SignificanceTableSummary = summarytableaddition;

end
