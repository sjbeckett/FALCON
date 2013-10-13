function [TEST]=CREATEQUANTNULL2(MATRIX)%ConserveRowTotals
%Keeps positions of filled elements the same and conserves row totals, but
%changes element values randomly. This method is described in Beckett & Williams, in prep.


[r,~]=size(MATRIX);
Qrowdegree=sum(MATRIX,2);

 %Create empty matrix to be filled according to null model (randomly)
    ind=MATRIX>0;
    TEST=MATRIX.*0;
    TEST(ind)=1;
    
    
    for b=1:r
       
        [~,indy]=find(MATRIX(b,:));
        
        indy=shuffleVector(indy);
        
        
        tot=Qrowdegree(b);
        
        if length(indy)>1
            for d=1:length(indy)-1
                use=tot*rand;
                TEST(b,indy(d))=use;
                tot=tot-use;        
            end
            
            TEST(b,indy(length(indy)))=tot;    
        end
         
    end

end
