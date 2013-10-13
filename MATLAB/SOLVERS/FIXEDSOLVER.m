function [indicator]=FIXEDSOLVER(indicator,functhand,A,matrixmeasure,nullfuncthand,binNull,EnsembleNumber,plotON)

%Creates a fixed number(EnsembleNumber) of null models to use in an ensemble 
%to compare against the test matrix for the given test.

%Returns summary statistical comaprison between the test matrix and the ensemble.

NULLMODEL=str2func(nullfuncthand);
MEASURE=str2func(functhand);

%CONDITIONS
maxEnsemble=EnsembleNumber;

%SETUP

testINDEX=0;
TOTAL_TEST=0;
LargerMeasureCount=0;
NANcount=0;

%WORK OUT WHETHER NESTEDNESS INCREASES/DECREASES WITH MEASURE


countup=NESTED_UP_OR_DOWN(MEASURE);

%% ITERATIONS

    %GROUP TEST
    
    for test=1:maxEnsemble
        testINDEX=testINDEX+1;
        B=NULLMODEL(A);
    
        if binNull==1
            [B,~,~]=sortMAT(B,1);
        else
            [~,B,~]=sortMAT(B,0);
        end
    
        TEST(testINDEX)=MEASURE(B);%measure
        TOTAL_TEST=TOTAL_TEST+TEST(testINDEX);
        
        if isnan(TEST(testINDEX))==1
            NANcount=NANcount+1;
        end
        
        if countup*TEST(testINDEX)>=countup*matrixmeasure %This ensures that matrices that generate no permutations in nulls have p=1. Delta function case.
            LargerMeasureCount=LargerMeasureCount+1;
        end
    end

    EnsembleSize=maxEnsemble;

    
    %Create statistics based on the ensemble set
    indicator=performEnsembleStats(indicator,matrixmeasure,NANcount,EnsembleSize,LargerMeasureCount,countup,TEST,TOTAL_TEST);



if plotON==1

    plotEnsemble(TEST,matrixmeasure,functhand,nullfuncthand);
    
end

end
