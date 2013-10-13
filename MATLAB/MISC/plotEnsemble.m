function []=plotEnsemble(NULLS,matrixmeasure,functhand,nullfuncthand)

figure
hist(NULLS,50)
hold on
plot( [matrixmeasure matrixmeasure],[0 1.1*max(hist(NULLS,50))],'r')
s=plot(matrixmeasure,1.1*max(hist(NULLS,50)),'r*');
h=xlabel([functhand ' score']);
 set(h,'interpreter','none');
ylabel('Number')
title(strcat('Histogram of nestedness scores in ensemble for null model: ', nullfuncthand))
 legend(s,'Test Matrix')
 ylim([0 1.3*max(hist(NULLS,50))])
 
end