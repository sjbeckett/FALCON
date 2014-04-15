% CREATEQUANTNULL2.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 12th March 2014

function [MEASURES]=CREATEQUANTNULL2(MATRIX,numbernulls,measures,binNull,sortVar)%ConserveRowTotals
%Keeps positions of filled elements the same and conserves row totals, but
%changes element values randomly. This method is described in Beckett & Williams, in prep.

MEASURES = zeros(length(measures),numbernulls);
[r,~]=size(MATRIX);
Qrowdegree=sum(MATRIX,2);

 %Create empty matrix to be filled according to null model (randomly)
    ind=MATRIX>0;
    
    
    for aa = 1:numbernulls
    
    TEST=MATRIX.*0;
    TEST(ind)=1;
    
    
    for b=1:r
       
        [~,indy]=find(MATRIX(b,:)); %non zero column indexes in this row.
                
        
        tot=Qrowdegree(b); %row sum
        
        
        MAKE = rand(1,length(indy)); % uniform random numbers
        MAKETOTAL = sum(MAKE);
        PROPORTION = MAKE./MAKETOTAL;
        NEW=PROPORTION.*tot;
        
        
        for d = 1:length(indy)
        TEST(b,indy(d))=NEW(d);
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
