TIME_MEASURESPLOT = TIME_MEASURES/1000;
TIME_NULLSPLOT= TIME_NULLS/1000;

TIME_MEASURESPLOTR = R_TIME_MEAS/1000;
TIME_NULLSPLOTR = R_TIME_NULL/1000;

% Lmean = 0.1;
% Lstd = 0.25;
% maximise = [ 0.0036    0.0287    0.9927    0.8722];

xwidth = 260;
ywidth = 650;

MEASUREvect = [1 3 4 5 6 2];

hfig = figure 
set(gcf,'PaperPositionMode','auto')
set(hfig, 'Position', [0 0 xwidth ywidth])
% set(gcf,'Units','normalized')
% set(gcf,'Position',maximise)
subplot(2,1,1)
for gthis=1:length(MEASURE)
    this = MEASUREvect(gthis);
gg=plot([gthis-Lmean gthis+Lmean],[log(mean(TIME_MEASURESPLOT(:,this))) log(mean(TIME_MEASURESPLOT(:,this)))]);
hold on
plot([gthis-Lstd gthis+Lstd],[log( mean(TIME_MEASURESPLOT(:,this)) + std(TIME_MEASURESPLOT(:,this)) ) log(mean(TIME_MEASURESPLOT(:,this)) + std(TIME_MEASURESPLOT(:,this)) )])
plot([gthis-Lstd gthis+Lstd],[log( mean(TIME_MEASURESPLOT(:,this)) - std(TIME_MEASURESPLOT(:,this)) ) log(mean(TIME_MEASURESPLOT(:,this)) - std(TIME_MEASURESPLOT(:,this)) )])
end

for gthis=1:length(MEASURE)
    this = MEASUREvect(gthis);
hh=plot([gthis-Lmean gthis+Lmean],[log(mean(TIME_MEASURESPLOTR(:,this))) log(mean(TIME_MEASURESPLOTR(:,this)))],'r');
hold on
plot([gthis-Lstd gthis+Lstd],[log( mean(TIME_MEASURESPLOTR(:,this)) + std(TIME_MEASURESPLOTR(:,this)) ) log(mean(TIME_MEASURESPLOTR(:,this)) + std(TIME_MEASURESPLOTR(:,this)) )],'r')
plot([gthis-Lstd gthis+Lstd],[log( mean(TIME_MEASURESPLOTR(:,this)) - std(TIME_MEASURESPLOTR(:,this)) ) log(mean(TIME_MEASURESPLOTR(:,this)) - std(TIME_MEASURESPLOTR(:,this)) )],'r')
end


set(gca,'XTick',[1 2 3 4 5 6])
set(gca,'XTicklabel',{'NODF','MD','JDM','NTC','BR','SR'},'FontSize',8)
xlim([0.5 6.5])
ylim([-11 -1])
ylabel('log(running time in seconds)','FontSize',8)

jj=legend([gg hh],'MATLAB','R','FontSize',8,'Location','NorthWest');

set(jj,'Box','off')
% set(jj,'Color','black')

subplot(2,1,2)
for this=1:5
plot([this-Lmean this+Lmean],[log(mean(TIME_NULLSPLOT(:,this))) log(mean(TIME_NULLSPLOT(:,this)))]);
hold on
plot([this-Lstd this+Lstd],[log(mean(TIME_NULLSPLOT(:,this)) + std(TIME_NULLSPLOT(:,this))) log(mean(TIME_NULLSPLOT(:,this)) + std(TIME_NULLSPLOT(:,this)))])
plot([this-Lstd this+Lstd],[log(mean(TIME_NULLSPLOT(:,this)) - std(TIME_NULLSPLOT(:,this))) log(mean(TIME_NULLSPLOT(:,this)) - std(TIME_NULLSPLOT(:,this)))])
end

for this=1:5
plot([this-Lmean this+Lmean],[log(mean(TIME_NULLSPLOTR(:,this))) log(mean(TIME_NULLSPLOTR(:,this)))],'r');
hold on
plot([this-Lstd this+Lstd],[log(mean(TIME_NULLSPLOTR(:,this)) + std(TIME_NULLSPLOTR(:,this))) log(mean(TIME_NULLSPLOTR(:,this)) + std(TIME_NULLSPLOTR(:,this)))],'r')
plot([this-Lstd this+Lstd],[log(mean(TIME_NULLSPLOTR(:,this)) - std(TIME_NULLSPLOTR(:,this))) log(mean(TIME_NULLSPLOTR(:,this)) - std(TIME_NULLSPLOTR(:,this)))],'r')
end

set(gca,'XTick',[1 2 3 4 5])
set(gca,'XTicklabel',{'SS', 'FF','CC','DD','EE'},'FontSize',8)
ylabel('log(running time in seconds)','FontSize',8)
xlim([0.5 5.5])
ylim([-11 -1])




% set(gcf,'PaperPositionMode','auto')
% set(hfig, 'Position', [0 0 xwidth ywidth],'Units','centimeters')
 print -depsc2 correlation.eps;
