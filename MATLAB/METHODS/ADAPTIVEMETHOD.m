% ADAPTIVEMETHOD.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 9th April 2014

function [indicator]=ADAPTIVEMETHOD(indicator,functhand,A,matrixmeasure,nullfuncthand,binNull,~,sortVar,plotON)

%Creates an adaptive number of null models to use in an ensemble
%to compare against the test matrix for the given test, by comparing
%summary statistics for two sampling groups from the same null
%population. Method is described in Beckett & Williams, in prep.

%Returns summary statistical comparison between the test matrix and the ensemble.

NULLMODEL=str2func(nullfuncthand);%Converts null model strings to functions
for ww=1:length(functhand)
    MEASURE{ww}=str2func(functhand{ww});%Converts measure strings to functions
end

%CONDITIONS
maxEnsemble=100000; %Maximum number possible is 100,000.
GroupEnsemble=25; %When comparisons begin, how many extra nulls to add to each group between comparisons
minEnsemble=500-GroupEnsemble; %Minimum number per group before comparison stage is entered.


%SETUP
flag=0; %flag to check success of comparison between two groups
LargerMeasureCount=zeros(1,length(MEASURE)); %Initialise vector to store number of null matrices with greater or equal measure score to that being tested.
NANCount=zeros(1,length(MEASURE)); %Initialise vector to store number of null matrices with a measure that returns NaN.

%WORK OUT WHETHER NESTEDNESS INCREASES/DECREASES WITH MEASURE
for ww=1:length(MEASURE)
    countup(ww)=NESTED_UP_OR_DOWN(MEASURE{ww});
end


%% STAGE 1 - minimum ensemble
    BLIND = NULLMODEL(A,minEnsemble,MEASURE,binNull,sortVar); %group one
    TEST = NULLMODEL(A,minEnsemble,MEASURE,binNull,sortVar); %group two
    EnsembleSize=2*minEnsemble;

%create progress bar
 reverseStr='';
fprintf(['\n' nullfuncthand ' is computing...']);
        percentDone = 100*(EnsembleSize / maxEnsemble);
        msg = sprintf('Percent complete: %3.1f', percentDone); %Don't forget this semicolon
        fprintf([reverseStr, [msg '%%']]);
        reverseStr = repmat(sprintf('\b'), 1, length(msg)+1);
        
%% STAGE 2 - comparison ensemble stage

    while flag == 0
        BLIND = [BLIND NULLMODEL(A,GroupEnsemble,MEASURE,binNull,sortVar)];
        TEST = [TEST NULLMODEL(A,GroupEnsemble,MEASURE,binNull,sortVar)];
        EnsembleSize = EnsembleSize + 2*GroupEnsemble;
	
         
        percentDone = 100*(EnsembleSize / maxEnsemble);
        msg = sprintf('Percent complete: %3.1f', percentDone); %Don't forget this semicolon
        fprintf([reverseStr, [msg '%%']]);
        reverseStr = repmat(sprintf('\b'), 1, length(msg)+1);
  
        
        if (EnsembleSize>=maxEnsemble) %if too many
            flag=1;
        else %else need to check whether to continue to sample from null models or not
            ww=1;
            checkflag=0; %flag for whether to continue Mann-Whitney U test comparisons in this iteration
            while checkflag==0
            %Test whether the two sample groups appear to have come from the same distribution with 0.99 probability.
		mwutest = MWWtest(BLIND(ww,:),TEST(ww,:));                

                if mwutest==0
                    ww=ww+1;
                    if ww==length(functhand)+1;
                        flag=1;
                        checkflag=1;
                    end
                else
                    checkflag=1;
                end
            end
        end
    end
    
    msg = sprintf('Percent complete: %3.1f', 100); %Don't forget this semicolon
    fprintf([reverseStr, [msg '%%']]);


%% STAGE 3 - Create statistics from the ensemble

    %find number of null matrices with equal or greater nestedness score
    for aa = 1:length(countup)
        LargerMeasureCount(aa) = sum(countup(aa).*([TEST(aa,:) BLIND(aa,:)]) >= countup(aa).*matrixmeasure(aa));
    end
    %find number of null matrices that failed to score correctly
    NANCount = sum(isnan([BLIND TEST]),2);
    if sum(NANCount)>0
        warning('NaN`s found');
    end


    indicator.EnsembleSize = EnsembleSize;
    indicator.SignificanceTable = zeros(length(functhand),5);


    for ww=1:length(MEASURE)
        
    
        indicator.measures{ww}=performEnsembleStats(functhand{ww},matrixmeasure(ww),NANCount(ww),EnsembleSize,LargerMeasureCount(ww),countup(ww),[TEST(ww,:) BLIND(ww,:)]);
        
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
         
%% STAGE 4 - Plotting

        if plotON==1
          plotEnsemble([TEST(ww,:) BLIND(ww,:)],matrixmeasure(ww),countup(ww),functhand{ww},nullfuncthand);
        end

    end



end
