% MANHATTAN_DISTANCE.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 10th March 2014

function [MEASURE]=MANHATTAN_DISTANCE(MATRIX)
%The Tau-temperature method based on the Manhattan Distance is described in
%Corso & Britton, 2012. This function returns the Manhattan distance of a
%matrix. The Tau-temperature is calculated as the Manhattan distance of the
%test matrix divided by the expected Manhattan distance as calculated from
%the mean of an ensemble. In FALCON the Tau-temperature is shown as the
%NormalisedTemperature in the outputs.

%G Corso, NF Britton. 2012.
%Nestedness and τ-temperature in ecological networks
%Ecological Complexity 11: 137 - 143. (http://dx.doi.org/10.1016/j.ecocom.2012.05.003)


[rows cols]=size(MATRIX);

%make sure binary.
MATRIX=MATRIX>0;

%Find distance matrix for row and column indices

distancematrix_R = repmat( (1:rows)' ,1 ,cols);
distancematrix_C = repmat( (1:cols), rows,1);

%Find the sum of the distances for each index from the input matrix.

dx=sum(sum(distancematrix_R.*MATRIX)) ;
dy=sum(sum(distancematrix_C.*MATRIX)) ;

%Find Manhattan distance.

DISTANCE= dx + dy;


MEASURE=DISTANCE;

end
