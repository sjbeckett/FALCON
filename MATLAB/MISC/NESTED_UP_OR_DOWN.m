% NESTED_UP_OR_DOWN.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 12th March 2014

function [countup]=NESTED_UP_OR_DOWN(MEASURE)

%DECIDES WHETHER NESTEDNESS SHOULD BE COUNTED UP OR DOWN BY LOOKING AT
%PERFECT NESTED MATRIX MEASURE AND UN-NESTED (CHECKERBOARD) MATRIX MEASURES

PERFECTNEST= fliplr( triu(ones(10)) .* toeplitz([1 2 3 4 5 6 7 8 9 10]));

%An un-nested matrix based on checkerboard structure. 
CHECKERED=zeros(10);
CHECKERED1=1:10;
CHECKERED1=mod(CHECKERED1,2);
CHECKERED2=CHECKERED1;
CHECKERED2(CHECKERED1==1)=0;
CHECKERED2(CHECKERED1==0)=1;

CHECKERED([1,3,5,7,9],:)=[CHECKERED1; CHECKERED1; CHECKERED1; CHECKERED1; CHECKERED1];
CHECKERED([2,4,6,8,10],:)=[CHECKERED2; CHECKERED2; CHECKERED2; CHECKERED2; CHECKERED2];
%Add additional to give same fill as perfectly nested matrix
CHECKERED(1,2)=1;
CHECKERED(3,4)=1;
CHECKERED(5,6)=1;
CHECKERED(7,8)=1;
CHECKERED(9,10)=1;

%Increase so that sum of elements is equal to that in PERFECTNEST
CHECKERED=CHECKERED*4;


%See which way round nestedness is measured
if MEASURE(PERFECTNEST) > MEASURE(CHECKERED)
    countup=1;
else
    countup=-1;
end



end