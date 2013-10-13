% SHORT SCRIPT WHICH QUESTIONS USER


%1. WHERE IS YOUR MATRIX? WHAT IS IT'S VARIABLE NAME?
flagQ1=1;

while flagQ1==1
reply1 = input('\n- Enter the variable name of the matrix you wish to test.\n If a variable is not yet assigned type "exit" and create\n a matrix variable this before continuing, or type \n "generate" to generate a random matrix to test the code:\n\n', 's');

if strcmp(reply1,'exit')==1
    error('Exiting to allow user to create/import matrix.')
elseif strcmp(reply1,'generate')==1
    MATRIX=1.*rand(4,5)>0.45
    flagQ1=0;
else
    MATRIX=eval(reply1)
    flagQ1=0;
end
end



    
    
    
    


%2. WHICH MEASURE DO YOU WISH TO TEST?
flagQ2=1;

while flagQ2==1
reply2 = input('\n- Which measure do you wish to use to measure nestedness? \n If unsure we suggest using 1, one of the more popular nestedness measures.\n Select 1 for NODF , 2 for SPECTRAL RADIUS, 3 for MANHATTAN DISTANCE (used to calculate TAU-TEMPERATURE).\n\n ', 's');

CHECKER=str2num(reply2);

if CHECKER==1
    MEASURE='NODF';
    flagQ2=0;
elseif CHECKER==2
    MEASURE='SPECTRAL_RADIUS';
    flagQ2=0;
elseif CHECKER==3
    MEASURE='MANHATTAN_DISTANCE';
    flagQ2=0;
else
    disp(['Please answer the question properly.'])
end
end

    THRESH=0.001;

%3. WHICH NULL MODELS DO YOU WISH TO TEST?
flagQ3=1;

while flagQ3==1
reply3 = input('\n- Which null model do you wish to use to measure nestedness? \n If unsure we suggest using 1, where size and fill are conserved but uniformly randomly shuffled.\n Select 1 for EE , 2 for FF, 3 for RF-RF.\n\n ', 's');

CHECKER=str2num(reply3);

if CHECKER==1
    null=1;
    flagQ3=0;
elseif CHECKER==2
    null=2;
    flagQ3=0;
    
    if str2num(reply2)==3
        reply3a=input('\n- Manhattan distance is invariant under this null model. Do you want to continue? (Y/N)','s');
        if reply3a =='y' || reply4=='Y' || strcmp(reply4,'yes') || strcmp(reply4,'Yes') || strcmp(reply4,'YES')
        else
            error('Exiting to allow user to change options.')
        end
    end
elseif CHECKER==3
    null=3;
      flagQ3=0;
else
    disp(['Please answer the question properly.'])
end
end

%4. WHICH SOLVER DO WANT TO USE?

flagQ4=1;
while flagQ4==1
    
reply4 =input('\n- Are you happy to use the adaptive solver? Adaptive solver (Y), Fixed solver (N).\n\n','s');

    if reply4 =='y' || reply4=='Y' || strcmp(reply4,'yes') || strcmp(reply4,'Yes') || strcmp(reply4,'YES')
        SOLVER='ADAPTIVE';
        ensembleNum=[];
        flagQ4=0;
    elseif reply4=='n' || reply4=='N' || strcmp(reply4,'no') || strcmp(reply4,'No') || strcmp(reply4,'NO')
        SOLVER='FIXED';
        flagQ5=1;
        
        while flagQ5==1
        reply = input('\n- How many null models do you want to test against?\n Literature tends to use between 1,000 and 10,000.\n\n');
        ensembleNum=reply;
    
            if ensembleNum>0
            flagQ5=0;
            else
            disp(['Please answer the question properly.'])
            end
        end
    
        flagQ4=0;
    else
        disp(['Please answer the question properly.'])
    end

end

disp(['Now performing the calculations on ' reply1 ' to find the ' MEASURE ' score; and test it against null model ' reply3 ' using the ' SOLVER ' solver.'])
disp('Hold on whilst your output is calculated!')

ind=PERFORM_NESTED_TEST(MATRIX,1,MEASURE,null,THRESH,ensembleNum,1);


sprintf(['Measure shows the ' MEASURE ' score, whilst pvalue shows how likely a more nested measure can \nbe achieved by following the rules of the selected null model( 1 every time, 0 never).\nMean shows the average measure from the null ensemble. Other statistics are also shown.'])

OUTPUT=eval(['ind.Bin_t' num2str(null)])

if str2num(reply2)==3
    disp('The Tau-Temperature is shown here as the NormalisedTemperature and is calculated as Measure divided by Mean.')
    disp('Tau-Temperature above 1 indicates the matrix was less nested than expected, whilst below 1 indicates it was')
    disp('more nested than expected under the null ensemble.')
end

pause(2)

disp('The nested configuration of your input matrix is:')

NESTEDCONFIGURATION=ind.Matrix(ind.index_rows,ind.index_cols)

