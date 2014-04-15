% CREATEBINNULL3.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 12th March 2014

function [MEASURES]=CREATEBINNULL3(MATRIX,numbernulls,measures,binNull,sortVar)%CC
%Cored - Cored null model
%has same dimensions and fill as initial matrix and has a similar degree
%distribution to the orginal matrix. The initial matrix is used as a
%guideline, where elements are randomly removed if the degree distributions
%of rows and columns will not fall to zero. These removed elements are then
%randomly reassigned to empty spaces in the matrix to conserve connectance
%of the input matrix. This method is described in Beckett & Williams, in prep.


MEASURES = zeros(length(measures),numbernulls); %To store measure answers.

degr=sum(MATRIX,2);
degc=sum(MATRIX,1);

[rows,cols] = size(MATRIX);


for aaa = 1:numbernulls

TEST=MATRIX;
degralt=degr;
degcalt=degc;
counting=0;

%remove elements while each row and each column still has at least one thing in it

for e=1:rows%for each row
    a=randi(rows);
    for c=1:cols%for each column
        b=randi(cols); 
        
        if degralt(a)>=2 && degcalt(b)>=2 && TEST(a,b)==1
            TEST(a,b)=0;
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
        x=randi(rows);
        y=randi(cols);
    
        if TEST(x,y)==0 
            TEST(x,y)=1;
            flag=1;
        end
    
    end
end


 %sort
  [TEST,~]=sortMATRIX(TEST,binNull,sortVar);


 %measure
      for ww=1:length(measures)
          MEASURES(ww,aaa) = measures{ww}(TEST);
      end

end

end