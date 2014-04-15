% DISCREPANCY.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 21st December 2013

function [MEASURE] = DISCREPANCY(MATRIX)
%The discrepancy measure of Brualdi and Sanderson 1999 measures nestedness
%by counting the number of differences between an input matrix (sorted by
%row and column degree) and a perfectly nested matrix built from the row
%sums of this sorted input matrix. 

%RA Brualdi, JG Sanderson. 1999.
%Nested Species Subsets, Gaps, and Discrepancy.
%Oecologia 119(2): 256-264.  (http://dx.doi.org/10.1007/s004420050784)

%However, this was built under the notion of site-species data such that
%perfect nestedness only depends on the row sums and ignores the column
%sums. If however, column sums rather than row sums are used the
%discrepancy of the matrix is altered. Here, we use the perfect nested
%matrix produced from row sums and the perfect nested matrix produced from
%column sums and describe the discrepancy of the entire matrix as the
%minimum discrepancy of either the row or column sum perfect nested matrix.

%Make sure dealing with binary data!
MATRIX=MATRIX>0; 
%Find row sums
rowSum = sum(MATRIX>0,2);

%Construct a perfect matrix of same dimensions as input matrix with the
%same row sums
A = MATRIX.*0;

for aa=1:length(rowSum)
    A(aa,1:rowSum(aa))=1;
end

colSum = sum(MATRIX>0,1);

B=MATRIX.*0;

for bb = 1:length(colSum)
    B(1:colSum(bb),bb)=1;
end


%Find the differences between the two matrices (as have same dimensions and
%row sums, they have same fill, therefore for every missing element there
%is an additional element) which can be done by looking at number of 1's or
%-1's.

MEASURE = min(sum(sum((MATRIX-A)==1)),sum(sum((MATRIX-B)==1)));

end