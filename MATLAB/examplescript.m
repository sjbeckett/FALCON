% TEST SCRIPT

%TEST 1 - GENERATE A MATRIX AND TEST SIGNIFICANCE OF NODF SCORE AGAINST THE
%EQUIPROBABLE-EQUIPROBABLE NULL MODEL USING ADAPTIVE SOLVER
MATRIX= (rand(4,6)>0.45).*1;

store=PERFORM_NESTED_TEST(MATRIX,1,'NODF',1,0.0001,[],1);
%Arguments
%1: passing the object to store gathered statistics in
%2: name of matrix want to test
%3: specifies whether the nature of the measure is binary (1) quantitative (0) or both ((2) the case of spectral radius for example).
%4: specifies function name of measure to perform. See folder MEASURES for complete list, or add your own!
%5: specifies which null tests to run. [] performs all that can be done based on whether the test is binary/quantitative.
% Binary null tests are positively numbered e.g.(1,2,3), whilst quantitative null tests are negatively numbered e.g. (-1,-2,-3).
% To run bnary null tests 1 and 3 use the argument [1 3]
%6: specifies the threshold in adaptive solver to compare the two sampling groups. When the averages of both groups are within this
% threshold the adaptive method finishes (unless the maximum ensemble size is reached).
%7: To use the adaptive method this should be set as [], else the fixed solver is invoked which performs the set number of nulls
% in its ensemble e.g. if argument was 50, 50 null models would be performed.
%8: Determines whether a plot should be displayed to the user about how the test measurement compares to those found in the null
% ensemble. 1 indicates the plot should be made, 0 indicates it should not.


%Show output
store.Bin_t1


%TEST 2 - LOAD A MATRIX AND FIND SIGNIFICANCE OF SPECTRAL RADIUS AGAINST ALL POSSIBLE NULL MODELS

LOADEDMAT= xlsread('test',1); %loads data from test.xls stored in sheet 1 and assigns it to LOADEDMAT


ind=PERFORM_NESTED_TEST(LOADEDMAT,2,'SPECTRAL_RADIUS',[],0.0001,[],1);

ind


%TEST 3 - FIND THE NESTEDNESS PROPERTIES OF A MATRIX WITH ZERO ROWS
%ACCORDING TO MANHATTAN DISTANCE USING NUL MODELS 1 AND 2 USING 1000 RANDOMISED MATRICES IN THE FIXED
%SOLVER

%Several things to note:
%1. Zero rows will be removed - look at differences between the input
%matrix (TEST3matrix / test3.Matrix) and the matrix analysed (test3.Matrix(test3.index_rows,test3.index_cols) ).
%2. Although there is a threshold argument, the existence of
%the ensmebleNum argument overules this and calls the fixed solver
%3. Null model 2 (FF) creates poor statistics - this is due to the
%Manhattan distance being equivalent in all null model instantiations as
%well as the input matrix as row and column elemnt sums do not change under
%the swaps.

TEST3matrix=rand(4,7)>0.45; %create random matrix of zeros and ones
TEST3matrix(5,:)=zeros(1,7); %adds a row of zeros to it


test3=PERFORM_NESTED_TEST(TEST3matrix,1,'MANHATTAN_DISTANCE',[1,2],0.0001,1000,1)


