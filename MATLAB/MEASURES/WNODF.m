% WNODF.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 11th April 2014

function [MEASURE]=WNODF(MATRIX)
%WNODF is the weighted NODF measure designed for use on quantitative data
% and is described in Almeida-Neto & Ulrich, 2011.

%M Almeida-Neto, W Ulrich. 2011.
%A straightforward computational approach for measuring nestedness using quantitative matrices
%Environmental Modelling & Software 26(2): 173 - 178. (http://dx.doi.org/10.1016/j.envsoft.2010.08.003)

rows=size(MATRIX,1);
cols=size(MATRIX,2);


colN=zeros(cols,cols);
rowN=zeros(rows,rows);

%Find WNODF column score
for i=1:cols-1
	for j=i+1:cols
		if sum(MATRIX(:,i)>0)>sum(MATRIX(:,j)>0)
		count=0;
			for k=1:rows
				if MATRIX(k,i)>0
					if MATRIX(k,j)>0
						if MATRIX(k,i)>MATRIX(k,j)
							count=count+1;
						end
					end
				end
            end
		colN(i,j)=count/(sum(MATRIX(:,j)>0));
		end
	end
end

colN=100.*colN;

WNODF_COL = 2*sum(sum(colN))/(cols*(cols-1));

%Find WNODF row score
for i=1:rows-1
	for j=i+1:rows
		if sum(MATRIX(i,:)>0)>sum(MATRIX(j,:)>0)
		count=0;
			for k=1:cols
				if MATRIX(i,k)>0
					if MATRIX(j,k)>0
						if MATRIX(i,k)>MATRIX(j,k)
							count=count+1;
						end
					end
				end
            end
		rowN(i,j)=count/(sum(MATRIX(j,:)>0));
		end
	end
end


rowN=rowN.*100;

WNODF_ROW = 2*sum(sum(rowN))/(rows*(rows-1));

%Find WNODF
WNODF=2*(sum(sum(rowN))+sum(sum(colN)))/(cols*(cols-1) +rows*(rows-1));



MEASURE=WNODF;

end
