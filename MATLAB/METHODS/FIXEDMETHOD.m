% FIXEDMETHOD.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 31st March 2014

function [indicator]=FIXEDMETHOD(indicator,functhand,A,matrixmeasure,nullfuncthand,binNull,EnsembleNumber,sortVar,plotON)

%Creates a fixed number(EnsembleNumber) of null models to use in an ensemble 
%to compare against the test matrix for the given test.

%Returns summary statistical comparison between the test matrix and the ensemble.

NULLMODEL=str2func(nullfuncthand); %Converts null model strings to functions
for ww=1:length(functhand)
    MEASURE{ww}=str2func(functhand{ww}); %Converts measure strings to functions
end


%SETUP
LargerMeasureCount=zeros(1,length(MEASURE));%Initialise vector to store number of null matrices with greater or equal measure score to that being tested.
NANcount=zeros(1,length(MEASURE));%Initialise vector to store number of null matrices with a measure that returns NaN.


%WORK OUT WHETHER NESTEDNESS INCREASES/DECREASES WITH MEASURE
for ww=1:length(MEASURE)
    countup(ww)=NESTED_UP_OR_DOWN(MEASURE{ww});
end


%% STAGE 1 - Run a fixed ensemble
    %create progress bar
    disp([nullfuncthand ' is computing...']);
 
    TEST = NULLMODEL(A,EnsembleNumber,MEASURE,binNull,sortVar);
    EnsembleSize=EnsembleNumber;

   

    
%% STAGE 2 - Create statistics from the ensemble    
    
    %find number of null matrices with equal or greater nestedness score
    for aa = 1:length(countup)
        LargerMeasureCount(aa) = sum(countup(aa).*(TEST(aa,:)) >= countup(aa).*matrixmeasure(aa));
    end
    %find number of null matrices that failed to score correctly
    NANcount = sum(isnan(TEST),2);
    if NANcount>0
        warning('NaN`s found');
    end

    indicator.EnsembleSize = EnsembleSize;
    indicator.SignificanceTable = zeros(length(functhand),5);


    for ww=1:length(MEASURE)
        indicator.measures{ww}=performEnsembleStats(functhand{ww},matrixmeasure(ww),NANcount(ww),EnsembleSize,LargerMeasureCount(ww),countup(ww),TEST(ww,:));
        
        %Significance Table
        if indicator.measures{ww}.pvalue < 0.05
            indicator.SignificanceTable(ww,2)=1;
            if indicator.measures{ww}.pvalue <= 0.001
                indicator.SignificanceTable(ww,1)=1;
            end
         elseif indicator.measures{ww}.pvalue > 0.95
             indicator.SignificanceTable(ww,4)=1;
            if indicator.measures{ww}.pvalue >= 0.999
                indicator.SignificanceTable(ww,5)=1;
            end
        else
            indicator.SignificanceTable(ww,3)=1;
        end
         
%% STAGE 3 - Plotting
        if plotON==1
          plotEnsemble(TEST(ww,:),matrixmeasure(ww),countup(ww),functhand{ww},nullfuncthand);
        end

    end

end
