% sortMAT.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 11th March 2014

function [sortMAT,info]=sortMATRIX(MATRIX,binary,sortvar)

[rows cols] = size(MATRIX);

%% STAGE 1  - remove zero rows/columns

%Sorts the binary positions of matrix MAT in terms of row and column degree.
BMAT=1.*(MATRIX~=0);

colsum=sum(BMAT,1);
rowsum=sum(BMAT,2);


JJ= colsum==0;%Find indexes of columns with no interactions
KK= rowsum==0;%Find indexes of rows with no interactions

info.index_rows = 1:rows;
info.index_cols = 1:cols;

%remove these
sortMAT=MATRIX;
sortMAT(:,JJ)=[];
sortMAT(KK,:)=[];
%and remove from index positions called
info.index_rows(KK)=[];
info.index_cols(JJ)=[];

%% STAGE 2 -- maximal sorting

if sortvar==1 %If want to package matrices in degree ordered way

%BINARY SORTMAT.
BMAT = 1.*(sortMAT~=0);
    
%Sort rows and columns in decending order to find zero rows, columns.
%This is the sort for entire matrix which may contain zero rows and
%columns.
[~, new.index_rows] = sort(sum(BMAT,2),'descend');
[~, new.index_cols] = sort(sum(BMAT,1),'descend');


info.index_rows = info.index_rows(new.index_rows);
info.index_cols = info.index_cols(new.index_cols);


sortMAT=MATRIX(info.index_rows,info.index_cols);

%% STAGE 3 - If input matrix not binary

if (sum(sum( (MATRIX==0) + (MATRIX==1)))~=rows*cols) && (binary~=1)
    BMAT = 1.*(sortMAT~=0);
    
    colsum=sum(BMAT,1);
    rowsum=sum(BMAT,2);

    JJ=unique(colsum);
    KK=unique(rowsum);

    if length(JJ) < size(BMAT,2) %If more than 1 column with same degree choose ordering
  
        for aa = 1:length(JJ)
            if sum(colsum==JJ(aa))>1 %If more than one occurance
                indexes = find(colsum==JJ(aa));
                
                HH=zeros(length(indexes));
                               
                for RR=1:size(HH,1)
                    for CC=1:size(HH,2)
                        HH(RR,CC) = sum(sortMAT(:,indexes(RR))>sortMAT(:,indexes(CC)));
                    end
                end
                
                
                select = sum(HH,1);
                unis=unique(select);
                if length(unis) < length(select)
                    for uu =1:length(unis)
                        if sum(select==unis(uu))>1 %if more than 1 value of this
                            nextind = find(select==unis(uu));
                            select(nextind) = 0.5.*(sum(sortMAT(:,nextind),1)./(sum(sum(sortMAT(:,nextind)))));
                        end
                    end
                
                end
                
                [~,ind]=sort(sum(HH,1),'ascend');
                
                                
                info.index_cols(indexes) = info.index_cols(indexes(ind));
                
                
                sortMAT(:,indexes)=sortMAT(:,indexes(ind));
                    
                
            end
        end
    end

if length(KK) < size(BMAT,1) %If more than 1 row with same degree choose ordering

    for aa = 1:length(KK)
            if sum(rowsum==KK(aa))>1 %If more than one occurance
                indexes = find(rowsum==KK(aa));
                
                HH=zeros(length(indexes));
                               
                for RR=1:size(HH,1)
                    for CC=1:size(HH,2)
                        HH(RR,CC) = sum(sortMAT(indexes(RR),:)>sortMAT(indexes(CC),:));
                    end
                end
                
                select = sum(HH,2);
                unis=unique(select);
                if length(unis) < length(select)
                    for uu =1:length(unis)
                        if sum(select==unis(uu))>1 %if more than 1 value of this
                            nextind = find(select==unis(uu));
                            select(nextind) = 0.5.*(sum(sortMAT(nextind,:),2)./(sum(sum(sortMAT(nextind,:)))));
                        end
                    end
                
                end
                
                [~,ind]=sort(select,'descend');
                
                info.index_rows(indexes) = info.index_rows(indexes(ind));
                
                
                sortMAT(indexes,:)=sortMAT(indexes(ind),:);
                    
                
            end
                    
    end
    
    

end

sortMAT = MATRIX(info.index_rows,info.index_cols);


end

end




%FINALLY IF WANT TO RETURN A BINARY MATRIX
if binary==1
    sortMAT=1.*(sortMAT~=0);
end



end





