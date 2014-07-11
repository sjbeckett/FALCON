% CREATEBINNULL2.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 10th July 2014

function [MEASURES]=CREATEBINNULL2(MATRIX,numbernulls,measures,binNull,sortVar)
% Fixed - Fixed null model
%Creates null matrices that conserve the same number of elements per row
%and column (the degree) as in the input matrix using the fast and robust
%curveball algorithm of Strona et al. 2014.


%G Strona, D Nappo, F Boccacci, S Fattorini, J San-Miguel-Ayanz. 2014.
%A fast and unbiased procedure to randomize ecological binary matrices with
%fixed row and column totals.
%Nature Communications 5: 4114. (http://dx.doi.org/10.1038/ncomms5114)


    [r,c]=size(MATRIX);
    MEASURES = zeros(length(measures),numbernulls); %To store measure answers.
    ROW = zeros(1,c);
    
    
    for aa =1:numbernulls %for each null matrix
        
        TEST = MATRIX; %start with the input matrix

        for rep = 1:5*r
    
            AB = randsample(1:r,2); %choose two rows
            A = TEST(AB(1),:); %vector of elements in row 1
            J = A - TEST(AB(2),:);% difference between row 1 and row 2
    
            if (max(J) - min(J)) == 2 %if uniques(a column with 1 in one row, 0 in other) in both rows can perform a swap.
                tot = find(abs(J)==1);  %all unique indices
                l_tot = length(tot); %num uniques
                tot= tot(randperm(l_tot));  %shuffled uniques
                both = find(J==0 & A==1);  %things that appear (precenses) in both rows
                L=sum(J==1); %sum of uniques in row 1. ( 1-0 )
                ROW1 = [both tot(1:L)];  %row1 presences
                ROW2 = [both tot(L+1:l_tot)]; %new row 2 presences
                
                
                I = ROW;
                I(ROW1)=1;
                K = ROW;
                K(ROW2)=1;
                TEST(AB,:) = [I; K]; 
                
            end
    
            
        end
    
        [TEST,~]=sortMATRIX(TEST,binNull,sortVar);
    
        %measure
        for ww=1:length(measures)
              MEASURES(ww,aa) = measures{ww}(TEST);
        end

    end
        
end

