% CREATEQUANTNULL3.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 12th March 2014

function [MEASURES]=CREATEQUANTNULL3(MATRIX,numbernulls,measures,binNull,sortVar)%ConserveColTotals
%Conserves column totals and binary positions, but changes element values.
%This method is described in Beckett & Williams, in prep.

MEASURES = zeros(length(measures),numbernulls);
[~,c]=size(MATRIX);
Qcoldegree=sum(MATRIX,1);

 %Create empty matrix to be filled according to null model (randomly)
    ind=MATRIX>0;
    
    
    for aa = 1:numbernulls
    
    TEST=MATRIX.*0;
    TEST(ind)=1;
    
    for b=1:c
       
        [indx,~]=find(MATRIX(:,b));             

        tot=Qcoldegree(b);        
                
        MAKE = rand(length(indx),1); % uniform random numbers
        MAKETOTAL = sum(MAKE);
        PROPORTION = MAKE./MAKETOTAL;
        NEW=PROPORTION.*tot;        
        
        for d = 1:length(indx)
        TEST(indx(d),b)=NEW(d);
        end
        
        
    
    end
    
    
     %sort
           [TEST,~]=sortMATRIX(TEST,binNull,sortVar);

     %measure
        for ww=1:length(measures)
            MEASURES(ww,aa) = measures{ww}(TEST);
        end

    
    
    end

end
