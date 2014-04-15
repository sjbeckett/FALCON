% NTC.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 28th February 2013

function [MEASURE]=NTC(MATRIX)
%%NTC - rewritten from nestedtemp script from the vegan package in R -
%%original credit to Jari Oksanen et al.


%% Oksanen, J., et al. 2013. vegan: community ecology package. R package version 2.0-9. http://CRAN.R-project.org/package=vegan


    %MAKE SURE DEALING WITH BINARY DATA
    MATRIX=MATRIX>0;
    
    [nrow,ncol]=size(MATRIX);
    rowSums = sum(MATRIX,2);
    colSums = sum(MATRIX,1);
    
    if (sum(sum(MATRIX))==nrow*ncol) %If the matrix is entirely made of 1's cannot measure, otherwise can:
        MEASURE = nan;
    else
    
    if ncol >= nrow
        ii = tiedrank(-rowSums);
    else
        jj = tiedrank(-colSums);
        ii = rowpack(MATRIX,jj);    
    end
    
    
    for k=1:8
        jj = colpack(MATRIX,ii);
        ii = rowpack(MATRIX,jj);
    end
    
    if  ncol < nrow
        jj = colpack(MATRIX,ii);
    end
   
    [~,orderii]=sort(ii);
    [~,orderjj]=sort(jj);
    
    TEST = MATRIX(orderii,orderjj);
    
              
    r = ((1:nrow) - 0.5)./(nrow +1 - 2*0.5);
    c = ((1:ncol) - 0.5)./(ncol +1 - 2*0.5);
    %repeat r across columns
    dis = repmat(r',1,ncol);
    
    crepe = repmat(c,nrow,1);
    totdis = 1 - abs(dis-crepe);
    
    fill = sum(TEST(:))/(ncol*nrow);
    

    lo = 0;
    hi = 20;
    flag = 0;
    while flag==0

        aha=0;

        try
          sol = fzero(@(p) intfunction(p,fill),[lo hi]);
        catch error
            aha=1;
        end
        

        
        if aha==1 
            if (hi >640)
                'matrix is too sparse';
            end
                lo=hi;
                hi=hi+hi;
        else
            break;
        end
    end
        
    
 
   p=sol;

    out = TEST.*0;
    for aa =1:nrow
        for bb = 1:ncol
            a = c(bb)-r(aa);
                   

            f = @(x) fillfunction(x,p)-a-x;
            out(aa,bb) = fzero(f,[0 1]);

        end
    end
    
    
    x = 0:1/50:1;

    xline = fillfunction(x,p);


    u = (dis - out) ./totdis;
    u(u<0 & TEST==1) = 0; %dont count suprises above
    u(u>0 & TEST==0) = 0; %dont count suprises below 
    
    u=u.*u;
    
    
    MEASURE = 100 * sum(u(:))/(nrow*ncol)/0.04145;
    end
   
end


function [st]=colpack(x, rr)

[nrow,ncol]=size(x);

ind = repmat(rr,1,ncol);

s = -sum((x.*ind).*(x.*ind),1);
t = -sum((nrow - (1-x).*ind +1).*(nrow - (1-x).*ind +1),1);

jam=tiedrank(s+t);


%randomise order of tied ranks!
ham=unique(jam);
if length(ham)<length(jam)
    for a=1:length(ham)
    
        if sum(ham(a)==jam)>1
           list = find(jam==ham(a));
           seq=(length(list)-1)*(-0.5):(length(list)-1)*(0.5)';
           seq=seq(randperm(length(seq))); %randomise

               jam(list)=jam(list)+seq;
        end
    end   
end

st=jam;

end

function [st]=rowpack(x, cr)
%cr has a value in each column
%ind is this row vector repeated for number of rows

[nrow,ncol]=size(x);

ind = repmat(cr,nrow,1);

s = -sum((x.*ind).*(x.*ind),2);
t = -sum((ncol - (1-x).*ind +1).*(ncol - (1-x).*ind +1),2);

jam=tiedrank(s+t);


%randomise order of tied ranks!
ham=unique(jam);
if length(ham)<length(jam)
    for a=1:length(ham)
    
        if sum(ham(a)==jam)>1
           list = find(jam==ham(a));
           seq=((length(list)-1)*(-0.5):(length(list)-1)*(0.5))';
           seq=seq(randperm(length(seq))); %randomise

               jam(list)=jam(list)+seq;
        end
    end   
end

st=jam;

end

function [y] = fillfunction(x,p)

y = 1- (1-(1-x).^p).^(1/p);

end

function [y]=intfunction(p,fill)

y = quadl(@(x)fillfunction(x,p),0,1) -fill;


end

