% MATRIXPLOT.m
% Part of the FALCON (Framework of Adaptive ensembLes for the Comparison Of
% Nestedness) package: https://github.com/sjbeckett/FALCON
% Last updated: 2nd April 2014

function [] = MATRIXPLOT(INMATRIX)
%TAKES MATRIX and PLOTS IT in current plot in binary form.

[rows,columns]=size(INMATRIX);

%determine if INMATRIX is binary
isbinary = 0;
if ( (sum(INMATRIX(:)==0) + sum(INMATRIX(:)==1)) == columns*rows )

	isbinary = 1;

else

	RANGE = [min(INMATRIX(:)) max(INMATRIX(:))];
	minR = RANGE(1);
	scalefactor = 1/(RANGE(2)-RANGE(1));
end



%Graphic Control
BACKGROUNDCOLOR=[173/255 235/255 255/255];
offset=0.3;%max of 0.5,425
RL=offset*2;

BACKGROUND=0.*INMATRIX;


    imagesc(BACKGROUND)
    rec=rectangle('Position',[0.5,0.5,size(INMATRIX,2),size(INMATRIX,1)]);
    set(rec,'FaceColor',BACKGROUNDCOLOR);
    
    
    for a=1:size(INMATRIX,1)
        for b=1:size(INMATRIX,2)
            if INMATRIX(a,b)~=0
                if (isbinary == 1)
                        rectang= rectangle('Position',[b-offset,a-offset,RL,RL]);
		                set(rectang,'FaceColor','white','EdgeColor','none');   
                else 
                        COL = 	1-(INMATRIX(a,b)-minR)*scalefactor;
                        rectang= rectangle('Position',[b-offset,a-offset,RL,RL]);
                        set(rectang,'FaceColor',([COL,COL,COL]),'EdgeColor','none'); 
                        
                end
            end
        end
    end


    if (isbinary~=1)
        caxis(RANGE)
        colormap gray
        colormap(flipud(colormap))
        colorbar
    end



end
