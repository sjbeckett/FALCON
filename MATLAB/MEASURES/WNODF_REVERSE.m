function [MEASURE]=WNODF_REVERSE(MATRIX)
%WNODF_REVERSE is an abstraction of the WNODF measure described in
%Almeida-Neto & Ulrich, 2011. But in reverse such that positive scores are
%assigned when specialists interact more strongly than generalists. This
%method is described in Beckett & Williams, in prep.

%M Almeida-Neto, W Ulrich. 2011.
%A straightforward computational approach for measuring nestedness using quantitative matrices
%Environmental Modelling & Software 26(2): 173 - 178. (http://dx.doi.org/10.1016/j.envsoft.2010.08.003)

rows=size(MATRIX,1);
cols=size(MATRIX,2);


colN=MATRIX.*0;
rowN=MATRIX.*0;

%Find WNODF-Reverse column score
for i=1:cols-1
	for j=i+1:cols
		if sum(MATRIX(:,i)>0)>sum(MATRIX(:,j)>0)
		count=0;
			for k=1:rows
				if MATRIX(k,i)>0
					if MATRIX(k,j)>0
						if MATRIX(k,i)<MATRIX(k,j)
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


%Find WNODF-Reverse row score
for i=1:rows-1
	for j=i+1:rows
		if sum(MATRIX(i,:)>0)>sum(MATRIX(j,:)>0)
		count=0;
			for k=1:cols
				if MATRIX(i,k)>0
					if MATRIX(j,k)>0
						if MATRIX(i,k)<MATRIX(j,k)
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


%Find WNODF-Reverse
WNODF=2*(sum(sum(rowN))+sum(sum(colN)))/(cols*(cols-1) +rows*(rows-1) );


MEASURE=WNODF;

end
