% CREATEQUANTNULL1.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 12th March 2014

function [MEASURES]=CREATEQUANTNULL1(MATRIX,numbernulls,measures,binNull,sortVar)%Shuffle
%Keeps binary position the same as in the initial matrix, but shuffles the
%positions of the filled elements randomly. This method was used in Staniczenko et al., 2013.

%PPA Staniczenko, JC Kopp, S Allesina. 2013.
%The ghost of nestedness in ecological networks
%Nature Communications 4(1391). (http://dx.doi.org/10.1038/ncomms2422)

MEASURES = zeros(length(measures),numbernulls);

    rowdegree=sum(MATRIX>0,1);
    Fill=sum(rowdegree);


    ind=MATRIX>0;
    INDEXES=find(MATRIX>0);
    
    
    for aa =1:numbernulls
    
    TEST=MATRIX.*0;
    TEST(ind)=1;
    ELEMENTS=MATRIX(MATRIX>0);
    
    
    for b=1:Fill
       %Find empty cell  
       num=randi(length(ELEMENTS));
       TEST(INDEXES(b))=ELEMENTS(num); 
       %reduce possible switches left
       ELEMENTS=ELEMENTS([1:num-1 num+1:length(ELEMENTS)]);
       
    end

    
     %sort
       [TEST,~]=sortMATRIX(TEST,binNull,sortVar);


     %measure
        for ww=1:length(measures)
            MEASURES(ww,aa) = measures{ww}(TEST);
        end

    
    end
    
end
