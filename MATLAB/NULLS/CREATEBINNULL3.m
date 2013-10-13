function [TEST]=CREATEBINNULL3(MATRIX)%RF-RF
%Relatively Fixed - Relatively Fixed null model
%has same dimensions and fill as initial matrix and has a similar degree
%distribution to the orginal matrix. The initial matrix is used as a
%guideline, where elements are randomly removed if the degree distributions
%of rows and columns will not fall to zero. These removed elements are then
%randomly reassigned to empty spaces in the matrix. This method is described
%in Beckett & Williams, in prep.

degr=sum(MATRIX,2);
degc=sum(MATRIX,1);

degralt=degr;
degcalt=degc;

BETA=MATRIX;
counting=0;

%remove elements while each row and each column still has at least one thing in it

for e=1:size(MATRIX,1)%for each row
    a=randi(size(MATRIX,1));
    for c=1:size(MATRIX,2)%for each column
        b=randi(size(MATRIX,2)); 
        
        if degralt(a)>=2 && degcalt(b)>=2 && BETA(a,b)==1
            BETA(a,b)=0;
           counting=counting+1;
           degralt(a)=degralt(a)-1;
           degcalt(b)=degcalt(b)-1;
        end
        
    end
end


%randomly reassign the removed elements
for d=1:counting
    flag=0;
    
    while flag==0;
        x=randi(size(MATRIX,1));
        y=randi(size(MATRIX,2));
    
        if BETA(x,y)==0 
            BETA(x,y)=1;
            flag=1;
        end
    
    end
end

TEST=BETA;

end
