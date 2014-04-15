% CREATEBINNULL5.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 11th April 2014

function [MEASURES]=CREATEBINNULL5(MATRIX,numbernulls,measures,binNull,sortVar) %% EE
% This null model has assigns an equal probability of an edge appearing at
% any cell in a null model. The probability of an edge appearing is the
% same as the input matrix, but in the null model the number of edges is
% not conserved. Furthermore we do not constrain the solution space to
% only those null models that preserve the number of nodes in the input
% matrix i.e. some null models will have reduced dimensions to those in the
% input matrix. However, we do prevent degenerate matrices being formed -
% i.e. those which are empty, scalar or vectors.


MEASURES = zeros(length(measures),numbernulls); %To store measure answers.

edges = sum(MATRIX(:)>0);
[r,c]=size(MATRIX);
M = edges/(r*c);

for aa = 1:numbernulls

    flag=0;
    while flag==0
        TEST = rand(r,c)  < M;


        %sort
        [TEST,~]=sortMATRIX(TEST,binNull,sortVar);
        
        flag=1;
        if min(size(TEST))<=1 %If empty/scalar/vector - don't want!
            flag = 0;
        end
        
    end

        %measure
        for ww=1:length(measures)
            MEASURES(ww,aa) = measures{ww}(TEST);
        end


end


end
