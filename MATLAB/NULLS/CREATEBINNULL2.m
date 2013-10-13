function [TEST]=CREATEBINNULL2(MATRIX) %FF
%Fixed-Fixed null model
%has the same dimensions, fill and degree distributions (rows and columns)
%as the initial matrix. This condition is fulfilled by employing the trial
%swap algorithm of Miklos and Podani, 2004.

%I Miklós, J Podani. 2004.
%Randomization of presence-absence matrices: comments and new algorithms
%Ecology 85(1): 86 – 92. (http://dx.doi.org/10.1890/03-0101)


    [r,c]=size(MATRIX);
    numberofswapstoattempt=1000;
    %Create empty matrix to be filled according to null model (randomly)
    ind=MATRIX>0;
    TEST=MATRIX.*0;
    TEST(ind)=1;
    
    for b=1:numberofswapstoattempt

        %Pick random cols and rows.
        row1=randi(r);
        row2=row1;
        while row2==row1
            row2=randi(r);
        end
    
        col1=randi(c);
        
        if TEST(row1,col1)==TEST(row2,col1) %If both these positions contain same valued element swap cannot be made - move on now!
            continue
        end
        
        col2=col1;
        while col2==col1
            col2=randi(c);
        end

        %swappable?
        if (TEST(row1,col1)==0 && TEST(row1,col2)==1 && TEST(row2,col1)==1 && TEST(row2,col2)==0)
            %swap
            TEST(row1,col1)=1;
            TEST(row1,col2)=0;
            TEST(row2,col2)=1;
            TEST(row2,col1)=0;
        
        elseif( TEST(row1,col1)==1 && TEST(row1,col2)==0 && TEST(row2,col1)==0 && TEST(row2,col2)==1 )
            %swap
            TEST(row1,col2)=1;
            TEST(row1,col1)=0;
            TEST(row2,col1)=1;
            TEST(row2,col2)=0;
        end
    end

end
