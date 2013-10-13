function [sorted,QsortMAT,info]=sortMAT(MAT,bintest)


%REMOVE zero rows and columns




%Sorts the binary positions of matrix MAT in terms of row and column degree.
BMAT=1.*(MAT>0);


[~, info.index_rows] = sort(sum(BMAT,2),'descend');
[~, info.index_cols] = sort(sum(BMAT,1),'descend');


JAMCOL=sum(MAT,1);%column degree
JAMROW=sum(MAT,2);%row degree

if sum(JAMCOL==0)>0%If zero columns exist
    x=find(JAMCOL==0);
    for cols=1:sum(JAMCOL==0)
    MAT(:,x(1+length(x)-cols))=[];
    info.index_cols(length(info.index_cols))=[];
    end
end

if sum(JAMROW==0)>0%If zero rows exist
    x=find(JAMROW==0);
    for cols=1:sum(JAMROW==0)
    MAT(x(1+length(x)-cols),:)=[];
    info.index_rows(length(info.index_rows))=[];
    end
end

BMAT=1.*(MAT>0);

[~, newinfo.index_rows] = sort(sum(BMAT,2),'descend');
[~, newinfo.index_cols] = sort(sum(BMAT,1),'descend');
                        
sorted = BMAT(newinfo.index_rows,newinfo.index_cols);

Qsorted= MAT(newinfo.index_rows,newinfo.index_cols);
QsortMAT=0;

if bintest==0 || bintest==2 %If matrix is being tested against weighted measures

%For weighted matrices, want to maximise nestedness measures, although
%order is invariant in SR methods, due to properties of the formed adjacency
%matrix, this is could be important for WNODF. The following code works towards
%satisfying this condition by using the binary matrix to identify rows and
%columns that are binary identical(same 0 and 1 positions) and shuffles
%rows such that the row/column with most number of elements larger than the
%other has precedence.


%ROWS

mark=1:size(Qsorted,1);

QsortMAT=Qsorted;


for a=1:size(QsortMAT,1)

    if mark(a)~=0
    
        mark(a)=0;
    
    sameMAT=[];
    SAME=[];
    dummy=[];
    
    
    A=(QsortMAT(a,:)>0).*1; %BINARY STRUCT
    
    sameMAT=QsortMAT(a,:);
    SAME=a;
    dummy=info.index_rows(a);
    
    for b=a+1:size(QsortMAT,1) %Check future rows to see if same structure
        B=(QsortMAT(b,:)>0).*1;
            if sum(A==B)==length(A)
                
                SAME=[SAME b];%row index
                dummy=[dummy info.index_rows(b)];
                sameMAT=[sameMAT; QsortMAT(b,:)];%row elements
                mark(b)=0;
            end
    end

    
    %NOW FOUND ALL ROWS WITH SAME BINARY STRUCTURE
    %NEED TO SORT THEM! - Do it by row total? or by total greater than.
    %This is an open question.
    
    H=zeros(length(SAME));
    for J=1:length(SAME)
       for K=1:length(SAME)
          
           H(J,K)=sum(QsortMAT(SAME(J),:)>QsortMAT(SAME(K),:));
           
       end     
    end
    
    
    [~,ind]=sort(sum(H,2),'descend');
    

    for q=1:length(SAME)

    QsortMAT(SAME(q),:)=sameMAT(ind(q),:);
    if isempty(dummy)~=1
        info.index_rows(SAME(q))=dummy(ind(q));
    end
    end
    
    

    
    end  
end

%COLUMNS

mark=1:size(QsortMAT,2);

for a=1:size(QsortMAT,2)
    
    if mark(a)~=0
    
        mark(a)=0;
    
        sameMAT=[];
        SAME=[];
        dummy=[];
    
        A=(QsortMAT(:,a)>0).*1; %BINARY STRUCT
    
        sameMAT=QsortMAT(:,a);
        SAME=a;
        dummy=info.index_cols(a);
    
        for b=a+1:size(QsortMAT,2)
            B=(QsortMAT(:,b)>0).*1;
                if sum(A==B)==length(A)            
                    SAME=[SAME b];
                    dummy=[dummy info.index_cols(b)];
                    sameMAT=[sameMAT QsortMAT(:,b)];
                    mark(b)=0;
                end
        end
    
        %NOW FOUND ALL ROWS WITH SAME BINARY STRUCTURE
        %NEED TO SORT THEM! - Do it by row total? or by total greater than.
        %This is an open question.
    
        H=zeros(length(SAME));
        for J=1:length(SAME)
            for K=1:length(SAME)
                H(J,K)=sum(QsortMAT(:,SAME(J))>QsortMAT(:,SAME(K)));
            end     
        end
    
        [~,ind]=sort(sum(H,2),'descend');
           

        for q=1:length(SAME)
            
            QsortMAT(:,SAME(q))=sameMAT(:,ind(q));
        if isempty(dummy)~=1
            info.index_cols(SAME(q))=dummy(ind(q));
        end
        end
    
    end  
end


end


end
