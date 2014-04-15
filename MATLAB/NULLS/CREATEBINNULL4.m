% CREATEBINNULL4.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 9th April 2014

function [MEASURES]=CREATEBINNULL4(MATRIX,numbernulls,measures,binNull,sortVar) %DD
% Degreeprobable - Degreeprobable null model
%Proportionally fills matrix depending on size and degree distribution of
%rows and columns - as described in Bascompte et al. 2003. However, we do 
%prevent degenerate matrices being formed - i.e. those which are empty, 
%scalar or vectors.

%J Bascompte, P Jordano, CJ Melián, JM Olesen. 2003.
%The nested assembly of plant–animal mutualistic networks.
%PNAS 100: 9383–9387. (http://dx.doi.org/10.1073/pnas.1633576100)


%Find matrix dimensions and row and column degrees.
[r,c]=size(MATRIX);
MEASURES = zeros(length(measures),numbernulls); %To store measure answers.

    coldegreesprop=sum(MATRIX>0,1)./r;
    rowdegreesprop=sum(MATRIX>0,2)./c;


for aa = 1:numbernulls

    flag=0;
    while flag==0
        %Fill up each matrix element probabilistically depending on the matrix dimensions and
        %degree distribution
    
        TEST = rand(r,c) < 0.5.*( coldegreesprop(ones(r,1),:) + rowdegreesprop(:,ones(1,c)) );
 
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