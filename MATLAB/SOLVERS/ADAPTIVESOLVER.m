function [indicator]=ADAPTIVESOLVER(indicator,functhand,A,matrixmeasure,nullfuncthand,binNull,THRESHOLD_IN,plotON)

%Creates an adaptive number of null models to use in an ensemble
%to compare against the test matrix for the given test, by comparing
%summary statistics for two sampling groups from the same null
%population. Method is described in Beckett & Williams, in prep.

%Returns summary statistical comaprison between the test matrix and the ensemble.

NULLMODEL=str2func(nullfuncthand);
MEASURE=str2func(functhand);

%CONDITIONS
maxEnsemble=10000;
GroupEnsemble=25;
minEnsemble=250-GroupEnsemble;
THRESHOLD=THRESHOLD_IN;

%SETUP
flag=0;
blindINDEX=0;
testINDEX=0;
TOTAL_BLIND=0;
TOTAL_TEST=0;
LargerMeasureCount=0;
NANcount=0;

%WORK OUT WHETHER NESTEDNESS INCREASES/DECREASES WITH MEASURE


countup=NESTED_UP_OR_DOWN(MEASURE);


%%FIRST ITERATION


    %GROUP BLIND
    for blind=1:minEnsemble
        blindINDEX=blindINDEX+1;
        B=NULLMODEL(A);
    
        if binNull==1
            [B,~,~]=sortMAT(B,1);
        else
            [~,B,~]=sortMAT(B,0);
        end
    
        BLIND(blindINDEX)=MEASURE(B);%measure        
        TOTAL_BLIND=TOTAL_BLIND+BLIND(blindINDEX);
        
        if isnan(BLIND(blindINDEX))==1
            NANcount=NANcount+1;
        end
        
        if countup*BLIND(blindINDEX)>=countup*matrixmeasure%This ensures that matrices that generate no permutations in nulls have p=1. Delta function case.
            LargerMeasureCount=LargerMeasureCount+1;
        end
        
    end

    %GROUP TEST
    
    for test=1:minEnsemble
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
        
        if countup*TEST(testINDEX)>=countup*matrixmeasure%This ensures that matrices that generate no permutations in nulls have p=1. Delta function case.
            LargerMeasureCount=LargerMeasureCount+1;
        end
    end




%%PROCEEDING ITERATIONS

while flag==0    
    
    %BLIND
    
    for blind=1:GroupEnsemble
        blindINDEX=blindINDEX+1;
        B=NULLMODEL(A);
        
    
        if binNull==1
            [B,~,~]=sortMAT(B,1);
        else
            [~,B,~]=sortMAT(B,0);
        end
    
        BLIND(blindINDEX)=MEASURE(B);%measure        
        TOTAL_BLIND=TOTAL_BLIND+BLIND(blindINDEX);
        
        if isnan(BLIND(blindINDEX))==1
            NANcount=NANcount+1;
        end
        
        if countup*BLIND(blindINDEX)>=countup*matrixmeasure%This ensures that matrices that generate no permutations in nulls have p=1. Delta function case.
            LargerMeasureCount=LargerMeasureCount+1;
        end
        
    end

    %TEST
    
    for test=1:GroupEnsemble
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

    
    % CONTINUE??
    if abs(matrixmeasure/(TOTAL_BLIND/blindINDEX)-matrixmeasure/(TOTAL_TEST/testINDEX))<=THRESHOLD || blindINDEX+testINDEX>=maxEnsemble
        EnsembleSize=blindINDEX+testINDEX;
        flag=1; 
    end  
end



indicator=performEnsembleStats(indicator,matrixmeasure,NANcount,EnsembleSize,LargerMeasureCount,countup,[TEST BLIND],TOTAL_TEST+TOTAL_BLIND);




if plotON==1

    plotEnsemble([TEST BLIND],matrixmeasure,functhand,nullfuncthand);   


end

end
