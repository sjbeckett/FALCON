function [outV]=shuffleVector(InV)
%Randomly shuffles the elements of InV

[~,B]=sort(rand(size(InV)));
%choose random order to do elements in
outV=nan.*InV;


    for a=1:length(InV)
        outV(B(a))=InV(a);
    end

end
