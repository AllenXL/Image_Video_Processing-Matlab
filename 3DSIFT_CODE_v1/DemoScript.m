% Short demo to calculate 3DSIFT descriptors
% Short demonstration showing how to call 3DSIFT
%
% Data is from KTH dataset and locations are purposefully chosen poorly to
% show how reRun works.

load DemoData
clear keys
offset = 0;

% Generate 50 descriptors at locations given by subs matrix
for i=1:50

    reRun = 1;
    
    while reRun == 1
        
        loc = subs(i+offset,:);
        fprintf(1,'Calculating keypoint at location (%d, %d, %d)\n',loc);
        
        % Create a 3DSIFT descriptor at the given location
        [keys{i} reRun] = Create_Descriptor(pix,1,1,loc(1),loc(2),loc(3));
        
        if reRun == 1
            offset = offset + 1;
        end
        
    end
    
end

fprintf(1,'\nFinished...\n%d points thrown out do to poor descriptive ability.\n',offset);
