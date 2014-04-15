% MWWtest.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 11th April 2014

function [sus] = MWWtest(Xs,Ys)
%Mann-Whitney-Wilcoxon test for use in ADAPTIVEMETHOD in FALCON using a
%normal approximation, testing distributions at the 0.001 significance level.

alpha = 0.1;


NumX = length(Xs);
NumY = length(Ys);

%Find tied ranks in these vectors and account for them
ALL = [Xs(:); Ys(:)];

[rank, indx]=sort(ALL);
Lone = unique(ALL);
[~,indy] = sort(indx);
numties = 1;

for aa = 1:length(Lone)
    if sum(rank==Lone(aa))>1 %if ties
        indexes = find(rank==Lone(aa));
        indy(indx(indexes)) = sum(indy(indx(indexes)))/length(indexes);
        numties = numties+length(indexes);
    end
end

ranks=indy;
AdjTies = numties*(numties-1)/2;

%Find z-score of this test
xrank = ranks(1:NumX);
w = sum(xrank);
w_mean = NumX*(NumX + NumY + 1)/2;
tie_score = 2 * AdjTies / ((NumX+NumY) * (NumX+NumY-1));
w_var  = NumX*NumY*(NumX + NumY + 1 - tie_score)/12;
w_c = w - w_mean;
z = (w_c - 0.5 * sign(w_c))/sqrt(w_var);


%Use z-score to find p score using a normal distribution approximation
X = -abs(z);
zpconv = (X - 0) / 1;
pconv = 0.5 * erfc( -zpconv/ sqrt(2) );
p = 2*pconv;

%Evaluate whether test is accepted/rejected by comparing p to alpha level.
sus = (p <= alpha);

end