
function indicator=performEnsembleStats(indicator,matrixmeasure,NANcount,EnsembleSize,LargerMeasureCount,countup,ENSEMBLESET,ENSEMBLETOTAL)


indicator.NANcount=NANcount; %Want this to be zero
indicator.EnsembleNum=EnsembleSize;
indicator.pvalue=LargerMeasureCount/EnsembleSize;

if indicator.pvalue==0 %P-value cannot be zero, but is found to be less than:
    indicator.pvalue=1/EnsembleSize;
end

indicator.Mean=(ENSEMBLETOTAL)/EnsembleSize;
indicator.NormalisedTemperature=matrixmeasure/indicator.Mean;
indicator.StandardDeviation=std(ENSEMBLESET);
indicator.sampleZscore=(matrixmeasure-indicator.Mean)/indicator.StandardDeviation;
indicator.Measure=matrixmeasure;

if countup==1
    indicator.NestednessUpOrDown='Up';
    indicator.AdjustedNormalisedTemperature=indicator.NormalisedTemperature;
else
    indicator.NestednessUpOrDown='Down';
    indicator.AdjustedNormalisedTemperature=1/indicator.NormalisedTemperature;
end

end