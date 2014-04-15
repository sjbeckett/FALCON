% BENCHING_PERFORMANCE.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 10th April 2014


%BENCHMARKS FOR TIMES OF MEASURE CALLS AND NULL CALLS (without calling
%measures)
function [TIME_MEASURES,TIME_NULLS] = BENCHING_PERFORMANCE
    %add FALCON to path
    g = genpath('../');
    addpath(g);

    %choose measures and make function handles
    functhand = {'NODF', 'SPECTRAL_RADIUS','MANHATTAN_DISTANCE','JDMnestedness','NTC','DISCREPANCY'};    
    for ww=1:length(functhand)
        MEASURE{ww}=str2func(functhand{ww});
    end
    
    
    
%% SET UP

numbertrials = 10;
TIME_MEASURES = zeros(numbertrials,length(MEASURE));
TIME_NULLS = zeros(numbertrials,5);


for TRIALS = 1:numbertrials
   %New matrix
   MATRIX = 1.*(rand(10,10)>0.4);
   
   %sort
   [MATRIX,~]=sortMATRIX(MATRIX,1,1);

   %% MEASURE TIMES
   
   for eachMeasure = 1:length(MEASURE)
            
        tic
    
        for MEASURESTOMAKE = 1:1000
            
            JAM = MEASURE{eachMeasure}(MATRIX);
            
        end
        TIME_MEASURES(TRIALS,eachMeasure)=toc;
        [eachMeasure TRIALS]
   end
    
   
   %% NULL TIMES
   
   tic
   testCREATEBINNULL1(MATRIX,1000,1,1,1);
   TIME_NULLS(TRIALS,1)=toc;
   
   tic
   testCREATEBINNULL2(MATRIX,1000,1,1,1);
   TIME_NULLS(TRIALS,2)=toc;
   
   tic
   testCREATEBINNULL3(MATRIX,1000,1,1,1);
   TIME_NULLS(TRIALS,3)=toc;
   
   tic
   testCREATEBINNULL4(MATRIX,1000,1,1,1);
   TIME_NULLS(TRIALS,4)=toc;
   
   tic
   testCREATEBINNULL5(MATRIX,1000,1,1,1);
   TIME_NULLS(TRIALS,5)=toc;
   
   
   
   
end


 

% save raw data
save('BENCHMARKING_PERFORMANCE')

%convert data to per operation basis for plotting
TIME_MEASURES = TIME_MEASURES./1000;
TIME_NULLS = TIME_NULLS./1000;

%plotting

Lmean = 0.1;
Lstd = 0.25;
maximise = [ 0.0036    0.0287    0.9927    0.8722];

figure
set(gcf,'Units','normalized')
set(gcf,'Position',maximise)
subplot(1,2,1)
for this=1:length(MEASURE)
plot([this-Lmean this+Lmean],[log(mean(TIME_MEASURES(:,this))) log(mean(TIME_MEASURES(:,this)))])
hold on
plot([this-Lstd this+Lstd],[log( mean(TIME_MEASURES(:,this)) + std(TIME_MEASURES(:,this)) ) log(mean(TIME_MEASURES(:,this)) + std(TIME_MEASURES(:,this)) )])
plot([this-Lstd this+Lstd],[log( mean(TIME_MEASURES(:,this)) - std(TIME_MEASURES(:,this)) ) log(mean(TIME_MEASURES(:,this)) - std(TIME_MEASURES(:,this)) )])
end
set(gca,'XTick',[1 2 3 4 5 6])
set(gca,'XTicklabel',{'NODF','SR','MD','JDM','NTC','BR'})
xlim([0.5 6.5])
ylim([-9 -1])
ylabel('log(running time in seconds)')

subplot(1,2,2)
for this=1:5
plot([this-Lmean this+Lmean],[log(mean(TIME_NULLS(:,this))) log(mean(TIME_NULLS(:,this)))])
hold on
plot([this-Lstd this+Lstd],[log(mean(TIME_NULLS(:,this)) + std(TIME_NULLS(:,this))) log(mean(TIME_NULLS(:,this)) + std(TIME_NULLS(:,this)))])
plot([this-Lstd this+Lstd],[log(mean(TIME_NULLS(:,this)) - std(TIME_NULLS(:,this))) log(mean(TIME_NULLS(:,this)) - std(TIME_NULLS(:,this)))])
end
set(gca,'XTick',[1 2 3 4 5])
set(gca,'XTicklabel',{'SS', 'FF','CC','DD','EE'})
xlim([0.5 5.5])
ylim([-9 -1])


end

% testCREATEBINNULL1.m
% Modified SS null model function, such that no measurements are made.

function [MEASURES]=testCREATEBINNULL1(MATRIX,numbernulls,measures,binNull,sortVar) %SS
%Swappable - Swappable null model
%has same dimensions and fill as original matrix,  but filled elements are
%randomly assigned independently of the initial ordering. The method presented
%ensures that matrices with zero rows/columns are not created and thus
%conserves the input matrix's dimensions.


[r,c]=size(MATRIX); %sizes of rows, columns


MEASURES = zeros(length(measures),numbernulls); %To store measure answers.


for aa = 1:numbernulls

TEST=0.*(MATRIX);% Matrix to fill in null model
LENr=1:r; %vector of rows
LENc=1:c;% vector of cols
count1=r; 
count2=c;
FILL=sum(sum(MATRIX>0));%Filled positions 
  
%stage1a - fill in 1 element for each row&col such that dimensions will be
%preserved (i.e. no chance of getting empty rows/cols and changing matrix
%dimensions).




while count1>0 && count2>0
   
    randa=randi(count1);
    randb=randi(count2);
    
    TEST(LENr(randa),LENc(randb))=1;
    
    LENr(randa)=[];
    LENc(randb)=[];
    
    count1=count1-1;
    count2=count2-1;
    FILL=FILL-1;
end

%stage1b - once all rows(cols) have something in, need to fill in cols
%(rows) with completely random rows(cols)

if count1>0
    while count1>0
        randa=1;
        randb=randi(c);
    
        TEST(LENr(randa),randb)=1;
        LENr(randa)=[];
        FILL=FILL-1;    
        count1=count1-1;
    end
elseif count2>0
    while count2>0
        randb=1;
        randa=randi(r);
    
        TEST(randa,LENc(randb))=1;
        LENc(randb)=[];
        FILL=FILL-1;  
        count2=count2-1;
    end
end

%stage2 - Once dimensions are conserved, need to add extra elements to
%preserve original matrix fill.

for d=1:FILL
    
    flag=0;
    while flag==0
       randa=randi(r);
       randb=randi(c);
       
       if TEST(randa,randb)==0
           TEST(randa,randb)=1;
           flag=1;
       end
    end
    
end


%stage 3 - sort this created matrix


    [TEST,~]=sortMATRIX(TEST,binNull,sortVar);



%stage 4 - now save the measures of this matrix

% for ww=1:length(measures)
%     MEASURES(ww,aa) = measures{ww}(TEST);
% end


end


end

% testCREATEBINNULL2.m
% Modified FF null model function, such that no measurements are made.


function[MEASURES] = testCREATEBINNULL2(MATRIX,numbernulls,measures,binNull,sortVar) %%FF
%Fixed - Fixed sequential trial swap only. Using advice on trial-swapping
%from Miklos and Podani, 2004 and the number of trial swaps to perform from
%Gotelli and Ulrich, 2011. The first null model is found by performing
%30,000 trial swaps on the input matrix to escape oversampling the input
%matrix, subsequent null models are found by performing further trial swaps
%and sampling the matrix every 5,000 trial swaps.

%I Miklós, J Podani. 2004.
%Randomization of presence-absence matrices: comments and new algorithms
%Ecology 85(1): 86 – 92. (http://dx.doi.org/10.1890/03-0101)

%N Gotelli, W Ulrich. 2011.
%Over-reporting bias in null model analysis: A response to Fayle and
%Manica(2010)
%Ecological Modelling 222: 1337 - 1339. (http://dx.doi.org/10.1016/j.ecolmodel.2010.11.008)

MEASURES = zeros(length(measures),numbernulls); %To store measure answers.
[r,c]=size(MATRIX);
TEST=MATRIX;
sampleafterspinup = 5000;

%CHECK THAT SWAPS CAN OCCUR - OR ELSE NO POINT
CHECKSWAPS=0;

if r < c
    
    for row1 = 1:(r-1)
        for row2 = 2:r
            TESTrows= TEST(row1,:) - TEST(row2,:);
            if sum(TESTrows==-1)>0 && sum(TESTrows==1)>0
                CHECKSWAPS=1; %swaps possible
                break;
            end
        end
    end
    
else
    
     for col1 = 1:(c-1)
        for col2 = 2:c
            TESTcols= TEST(:,col1) - TEST(:,col2);
            if sum(TESTcols==-1)>0 && sum(TESTcols==1)>0
                CHECKSWAPS=1; %swaps possible
                break;
            end
        end
     end
     
end


%If no swaps possible all will have the same score and nestedness should be
%insignificant.

if CHECKSWAPS==0
    
     [TEST,~]=sortMATRIX(TEST,binNull,sortVar);
        
     %measure
%         for ww=1:length(measures)
%             MEASURES(ww,:) = measures{ww}(TEST);
%         end
               
    
else %IF swaps are possible - need to find out!


%Submatrices where swaps can be made!
ID1 = eye(2);
ID2 = ID1([2 1],[1 2]);


if r*c>30000
    numberofswapstoattempt=r*c;
else
    numberofswapstoattempt=30000;
end

%Spin up with 30,000 trial swaps.
    
    for b=1:numberofswapstoattempt

        %Pick random cols and rows.
        %Pick random cols and rows.
        rows = randperm(r,2);
        cols = randperm(c,2);
        

	if (  ( sum(sum( TEST(rows,cols)==ID1 ))==4  ) || ( sum(sum( TEST(rows,cols)==ID2 ))==4) )
            TEST(rows,cols)=TEST(rows(end:-1:1),cols);
	end


    end
    
    %Measure first matrix.
     %sort
      [TEST,~]=sortMATRIX(TEST,binNull,sortVar);



     %measure
%         for ww=1:length(measures)
%             MEASURES(ww,1) = measures{ww}(TEST);
%         end
     
    
    %subsequent nulls are created from sampling the null after extra trial
    %swaps.
    
    for cc = 2:numbernulls
        
     for b=1:sampleafterspinup

        %Pick random cols and rows.
        %Pick random cols and rows.
        rows = randperm(r,2);
        cols = randperm(c,2);
        

	if (  ( sum(sum( TEST(rows,cols)==ID1 ))==4  ) || ( sum(sum( TEST(rows,cols)==ID2 ))==4) )
            TEST(rows,cols)=TEST(rows(end:-1:1),cols);
	end


     end
     
     %sort
        [TEST,~]=sortMATRIX(TEST,binNull,1);

     %measure
%         for ww=1:length(measures)
%             MEASURES(ww,cc) = measures{ww}(TEST);
%         end
     

    
    end
end
    
    
    
end

% testCREATEBINNULL3.m
% Modified CC null model function, such that no measurements are made.


function [MEASURES]=testCREATEBINNULL3(MATRIX,numbernulls,measures,binNull,sortVar)%CC
%Cored - Cored null model
%has same dimensions and fill as initial matrix and has a similar degree
%distribution to the orginal matrix. The initial matrix is used as a
%guideline, where elements are randomly removed if the degree distributions
%of rows and columns will not fall to zero. These removed elements are then
%randomly reassigned to empty spaces in the matrix to conserve connectance
%of the input matrix. This method is described in Beckett & Williams, in prep.


MEASURES = zeros(length(measures),numbernulls); %To store measure answers.

degr=sum(MATRIX,2);
degc=sum(MATRIX,1);

[rows,cols] = size(MATRIX);


for aaa = 1:numbernulls

TEST=MATRIX;
degralt=degr;
degcalt=degc;
counting=0;

%remove elements while each row and each column still has at least one thing in it

for e=1:rows%for each row
    a=randi(rows);
    for c=1:cols%for each column
        b=randi(cols); 
        
        if degralt(a)>=2 && degcalt(b)>=2 && TEST(a,b)==1
            TEST(a,b)=0;
           counting=counting+1;
           degralt(a)=degralt(a)-1;
           degcalt(b)=degcalt(b)-1;
        end
        
    end
end


%randomly reassign the removed elements
for d=1:counting
    flag=0;
    
    while flag==0;
        x=randi(rows);
        y=randi(cols);
    
        if TEST(x,y)==0 
            TEST(x,y)=1;
            flag=1;
        end
    
    end
end


 %sort
       [TEST,~]=sortMATRIX(TEST,binNull,sortVar);


 %measure
%       for ww=1:length(measures)
%           MEASURES(ww,aaa) = measures{ww}(TEST);
%       end

end

end

% testCREATEBINNULL4.m
% Modified DD null model function, such that no measurements are made.


function [MEASURES]=testCREATEBINNULL4(MATRIX,numbernulls,measures,binNull,sortVar) %DD
% Degreeprobable - Degreeprobable null model
%Proportionally fills matrix depending on size and degree distribution of
%rows and columns - as described in Bascompte et al. 2003. However, we do 
%prevent degenerate matrices being formed - i.e. those which are empty, 
%scalar or vectors.

%J Bascompte, P Jordano, CJ Melián, JM Olesen. 2003.
%The nested assembly of plant–animal mutualistic networks.
%PNAS 100: 9383–9387. (http://dx.doi.org/10.1073/pnas.1633576100)

%Find matrix dimensions and row and column degrees.
[r,c]=size(MATRIX);
MEASURES = zeros(length(measures),numbernulls); %To store measure answers.

    coldegreesprop=sum(MATRIX>0,1)./r;
    rowdegreesprop=sum(MATRIX>0,2)./c;


for aa = 1:numbernulls

    flag=0;
    while flag==0
        %Fill up each matrix element probabilistically depending on the matrix dimensions and
        %degree distribution
    
        TEST = rand(r,c) < 0.5.*( coldegreesprop(ones(r,1),:) + rowdegreesprop(:,ones(1,c)) );
 
        %sort
        [TEST,~]=sortMATRIX(TEST,binNull,sortVar);
     
        flag=1;
        if min(size(TEST))<=1 %If empty/scalar/vector - don't want!
            flag = 0;
        end
        
    end

        %measure
%        for ww=1:length(measures)
%            MEASURES(ww,aa) = measures{ww}(TEST);
%        end   


end

end

% testCREATEBINNULL5.m
% Modified EE null model function, such that no measurements are made.


function [MEASURES]=testCREATEBINNULL5(MATRIX,numbernulls,measures,binNull,sortVar) %% EE
% This null model has assigns an equal probability of an edge appearing at
% any cell in a null model. The probability of an edge appearing is the
% same as the input matrix, but in the null model the number of edges is
% not conserved. Furthermore we do not constrain the solution space to
% only those null models that preserve the number of nodes in the input
% matrix i.e. some null models will have reduced dimensions to those in the
% input matrix.However, we do prevent degenerate matrices being formed -
% i.e. those which are empty, scalar or vectors.

%RR Sokal & FJ Rohlf. 1995.
%Biometry: The Principles and Practices of Statistics in Biological Research.
%W. H. Freeman and Company, New York.


MEASURES = zeros(length(measures),numbernulls); %To store measure answers.

edges = sum(sum(MATRIX>0));
[r,c]=size(MATRIX);
M = edges/(r*c);


for aa = 1:numbernulls


flag=0;
    while flag==0
	TEST = rand(r,c)  < M;


 	%sort
        [TEST,~]=sortMATRIX(TEST,binNull,sortVar);

	
	flag=1;
        if min(size(TEST))<=1 %If empty/scalar/vector - don't want!
            flag = 0;
        end
   end

 	%measure
%       for ww=1:length(measures)
%           MEASURES(ww,aa) = measures{ww}(TEST);
%       end


end


end


