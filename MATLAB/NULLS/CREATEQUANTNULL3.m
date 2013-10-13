function [TEST]=CREATEQUANTNULL3(MATRIX)%ConserveColTotals
%Conserves column totals and binary positions, but changes element values.
%This method is described in Beckett & Williams, in prep.

[~,c]=size(MATRIX);
Qcoldegree=sum(MATRIX,1);

 %Create empty matrix to be filled according to null model (randomly)
    ind=MATRIX>0;
    TEST=MATRIX.*0;
    TEST(ind)=1;
    
    for b=1:c
       
        [indx,~]=find(MATRIX(:,b));
        
        indx=shuffleVector(indx);
        

        tot=Qcoldegree(b);
        
        if length(indx)>1
            for d=1:length(indx)-1
                use=tot*rand;
                TEST(indx(d),b)=use;
                tot=tot-use;        
            end
            
            TEST(indx(length(indx)),b)=tot;
        end
        
    
    end

end
