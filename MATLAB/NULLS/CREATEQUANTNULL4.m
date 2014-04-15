% CREATEQUANTNULL4.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 20th March 2014

function [MEASURES]=CREATEQUANTNULL4(MATRIX,numbernulls,measures,binNull,sortVar)%Average of conserving row and column totals
%Keeps positions of filled elements the same and conserves row totals, but
%changes element values randomly. This method is described in Beckett & Williams, in prep.

MEASURES = zeros(length(measures),numbernulls);
[r,c]=size(MATRIX);
Qrowdegree=sum(MATRIX,2);
Qcoldegree=sum(MATRIX,1);

 %Create empty matrix to be filled according to null model (randomly)
    ind=MATRIX>0;
    
    
    for aa = 1:numbernulls
    
    TEST1=MATRIX.*0;
    TEST1(ind)=1;
    TEST2 = TEST1;
    
    
    for b=1:r
       
        [~,indy]=find(MATRIX(b,:)); %non zero column indexes in this row.
                
        
        tot=Qrowdegree(b); %row sum
        
        
        MAKE = rand(1,length(indy)); % uniform random numbers
        MAKETOTAL = sum(MAKE);
        PROPORTION = MAKE./MAKETOTAL;
        NEW=PROPORTION.*tot;
        
        
        for d = 1:length(indy)
        TEST1(b,indy(d))=NEW(d);
        end
        
         
    end

    for b=1:c
       
        [indx,~]=find(MATRIX(:,b));             

        tot=Qcoldegree(b);        
                
        MAKE = rand(length(indx),1); % uniform random numbers
        MAKETOTAL = sum(MAKE);
        PROPORTION = MAKE./MAKETOTAL;
        NEW=PROPORTION.*tot;        
        
        for d = 1:length(indx)
        TEST2(indx(d),b)=NEW(d);
        end
        
        
    
    end
    
    TEST = 0.5*(TEST1+TEST2);
    
     %sort
       [TEST,~]=sortMATRIX(TEST,binNull,sortVar);


     %measure
        for ww=1:length(measures)
            MEASURES(ww,aa) = measures{ww}(TEST);
        end

    
    
    
    end

end
