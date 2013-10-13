function [MEASURE]=MANHATTAN_DISTANCE(MATRIX)
%The Tau-temperature method based on the Manhatton Distance is described in
%Corso & Britton, 2012. This function returns the Manhattan distance of a
%matrix. The Tau-temperature is calculated as the Manhattan distance of the
%test matrix divided by the expected Manhatton distance as calculated from
%the mean of an ensemble. In FALCON the Tau-temperature is shown as the
%NormalisedTemperature in the outputs.

%G Corso, NF Britton. 2012.
%Nestedness and τ-temperature in ecological networks
%Ecological Complexity 11: 137 - 143. (http://dx.doi.org/10.1016/j.ecocom.2012.05.003)


[rows cols]=size(MATRIX);



% TOTAL_DISTANCE_POSSIBLE=0;
% 
% for i=1:rows
%     for j=1:cols
%         TOTAL_DISTANCE_POSSIBLE=TOTAL_DISTANCE_POSSIBLE+i+j;
%     end
% end

% occupation = (sum(sum(MATRIX>0)))/(size(MATRIX,1)*size(MATRIX,2));


ind=MATRIX>0;
adjacency=0.*MATRIX;
adjacency(ind)=1;


%length of obj.rows
gamma1=sum(adjacency,2);
%length of obj.cols
gamma2=sum(adjacency,1);


Rindex=(1:rows)';
Cindex=1:cols;

ROWSORTER=[gamma1 Rindex];
sortR=flipud(sortrows(ROWSORTER));

COLSORTER=[gamma2;Cindex];
sortC=flipud(sortrows(COLSORTER'));

%SORT OUT PACKAGING- nearly there!!!
for a=1:rows
    for b=1:cols
        PACKAGE(a,b)=adjacency(sortR(a,2),sortC(b,2));
    end
end

%EQUATION4 
% for a=1:obj.rows
%     for b=1:obj.cols
%         distancematrix(a,b)=a+b;
%     end
% end

%EQUATION6
for a=1:rows
    for b=1:cols
        distancematrix_R(a,b)=a;
    end
end

for a=1:rows
    for b=1:cols
        distancematrix_C(a,b)=b;
    end
end

dx=sum(sum(distancematrix_R.*PACKAGE)) ;
dy=sum(sum(distancematrix_C.*PACKAGE)) ;

DISTANCE= dx + dy;



MEASURE=DISTANCE;

end
