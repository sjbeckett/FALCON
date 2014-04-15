% performEnsembleStats.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 15th April 2014

function indicator=performEnsembleStats(functhand,matrixmeasure,NANcount,EnsembleSize,LargerMeasureCount,countup,ENSEMBLESET)
%Uses ensemble information to calculate some statistics.

ENSEMBLETOTAL = sum(ENSEMBLESET,2);

indicator.MEASURE=functhand;
indicator.NANcount=NANcount; %Want this to be zero
indicator.Measure=matrixmeasure;
indicator.pvalue=LargerMeasureCount/EnsembleSize;
indicator.pvalueCorrected = 0;

if indicator.pvalue==0 %P-value cannot be zero, but is found to be less than:
    indicator.pvalueText='p cannot equal 0, conservatively assigning p < ';
    indicator.pvalue=1/EnsembleSize;
    indicator.pvalueCorrected=1;
end

indicator.Mean=(ENSEMBLETOTAL)/EnsembleSize;
indicator.StandardDeviation=std(ENSEMBLESET);
indicator.sampleZscore=(matrixmeasure-indicator.Mean)/indicator.StandardDeviation;
indicator.Median = median(ENSEMBLESET);
indicator.minimum = min(ENSEMBLESET);
indicator.maximum = max(ENSEMBLESET);


indicator.NormalisedTemperature=matrixmeasure/indicator.Mean;

if countup==1
    indicator.NestednessUpOrDown='Up';
else
    indicator.NestednessUpOrDown='Down';
end

end
