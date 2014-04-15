% plotEnsemble.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 15th April 2014

function []=plotEnsemble(NULLS,matrixmeasure,countup,functhand,nullfuncthand)
%plots histograms of scores found in null ensembles

figure
uniques = length(unique(NULLS));
MAX = max(hist(NULLS,uniques));

plot( [matrixmeasure matrixmeasure],[0 1.1*MAX],'r--')%Test matrix score
hold on
s=plot(matrixmeasure,1.1*MAX,'r*');

hist(NULLS,uniques);
xlabel(strrep([functhand ' score'],'_',' '));

ylabel('Number')
title(strcat('Nestedness in ensemble for null model: ', nullfuncthand))
legend(s,'Test Matrix')

ymin=0;
ymax=1.3*MAX;

ylim([ymin ymax])

xmin=min(matrixmeasure,min(NULLS))-0.0000001;
xmax=max(matrixmeasure,max(NULLS))+0.0000001;

xlim([xmin xmax])
 
 
 xcord = [0.4 0.7];
 if countup == -1
     xcord = [0.6 0.3];
 end
 

xrange = (xmax-xmin);

xcord = xcord*xrange+xmin;

ycord = [1.15*MAX 1.15*MAX];

plot(xcord,ycord,'k')%line
plot([xcord(2) xcord(2)-countup*0.05*xrange],[ycord(1) ycord(1)+0.04*ymax],'k')%arrow head 1
plot([xcord(2) xcord(2)-countup*0.05*xrange],[ycord(1) ycord(1)-0.04*ymax],'k')%arrow head 2
text(xmin+0.5*xrange,ycord(1)+0.03*ymax,'nestedness')
 
 
end
