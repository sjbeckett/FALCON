% JDMnestedness.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 12th March 2014

function [MEASURE]=JDMnestedness(MATRIX)
%JDM are the author initials from which this nestedness measure is described
% which is Johnson et al., 2013.

%We thank Virginia Domínguez-García for help in assembling this measure.

%S Johnson, V Domínguez-García, MA Muñoz. 2013.
%Factors determining nestedness in complex networks.
%PLOS ONE (http://dx.doi.org/10.1371/journal.pone.0074025)


%% STAGE 1 -  create bipartite configuration model
%Following notation given in Appendix A (Johnson et al., 2013)
%Make sure dealing with binary data!
MATRIX = MATRIX>0;

[r,c]=size(MATRIX); %dimensions of MATRIX, n1 rows and n2 columns

k1AVG=sum(sum(MATRIX,2))/r;  %Average row degrees per rows
k2AVG=sum(sum(MATRIX,1))/c; %Average column degrees per columns
k1sqAVG=sum( sum(MATRIX,2).*sum(MATRIX,2) ) /r; %Average row degrees squared per rows
k2sqAVG=sum( sum(MATRIX,1).*sum(MATRIX,1) ) /c; %Average column degrees squared per columns

%Predicted nestedness for bipartite network (Appendix SI 1.)
nbip = (r*k2sqAVG + c*k1sqAVG)/(k1AVG*k2AVG*(r+c)*(r+c));


%% STAGE 2 - Find unadjusted nestedness measure (nestedness overlap)

% Full nestedness measure: means building adjacency matrix to make
% bipartite data unipartite
s=r+c;

%Build adjacency matrix
ADJ=zeros(s,s);
ADJ(1:r, (r + 1):s) = MATRIX>0;
ADJ=ADJ+ADJ';

%Find overlap, by squaring adjacency matrix
ADJsq=ADJ*ADJ;

%find degree information of the adjacency matrix
k=sum(ADJ>0,1);

n=zeros(s,s);

%Then find unajusted nestedness value (eq. 2)
for i=1:s
    for j=1:s
        n(i,j)= ADJsq(i,j) / (k(i)*k(j));
    end
end

% %Find global nestedness temperature and store in Nu (eq. 3)
Nu=sum(sum(n)) / (s*s);

%% STAGE 3 - normalise the nestedness overlap by the bipartite configuration
%model as in eq. 6 with nbip=nconf

%Bipartite config model version of eq. 6

MEASURE = Nu / nbip;

end
