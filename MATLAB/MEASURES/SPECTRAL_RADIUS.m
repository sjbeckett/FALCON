function [MEASURE]=SPECTRAL_RADIUS(MATRIX)
%The spectral radius method is described in Staniczenko et al., 2013.

%PPA Staniczenko, JC Kopp, S Allesina. 2013.
%The ghost of nestedness in ecological networks
%Nature Communications 4(1391). (http://dx.doi.org/10.1038/ncomms2422)


[r,c]=size(MATRIX);
s=r+c;

%Build adjacency matrix
ADJ=zeros(s,s);
ADJ(1:r, (r + 1):s) = MATRIX;
ADJ=ADJ+ADJ';

%return the real eigenvalue with largest magnitude
MEASURE=max(abs(real(eig(ADJ))));

end
