function seg_mask = remove_small_segs(wat_shed,u_new,v_new,s,method)
%%%%First remove small segments -- less than 100 pixels
clabs = unique(wat_shed(:));

for i = 1 : length(clabs)
    
    inds = find(wat_shed == clabs(i));
    
    if length(inds) <= 50
        
        wat_shed(inds) = 0;
        
    end
    
end
pixels_to_remove = 0;
if method
    vaccum_inds  = compute_vaccum_inds_saad_ali(u_new,v_new);
else
    vaccum_inds  = compute_vaccum_inds(u_new,v_new,s);
end;

clabs = unique(wat_shed(:));

for i = 1 : length(clabs)
    
    inds = find(wat_shed == clabs(i));
    
    common_inds = intersect(inds, vaccum_inds);
    if length(common_inds)/length(inds) > .99
        
        wat_shed(inds) = 0;
        
    end
    
end

% 
% clabs = unique(wat_shed(:));
% mg = u_new.^2+v_new.^2;
% ang = atan2(v_new,u_new);%
% for k = 1:length(clabs)-1
%     i = find(wat_shed == clabs(k));
%     j = find(wat_shed == clabs(k+1));
%     if abs(mean(mg(j))) > .2 && abs(mean(ang(i))-mean(ang(j)))<pi/1.4
%         wat_shed(i)= clabs(k+1);
%     end;
% end;
% 
% label_counter = 1;
% if nargin < 6
%     ord =  randperm(length(clabs));
% end;
% counter = 1;
% for i = ord
%     
%     
%     if clabs(i) == 0
%         continue;
%     end
%     
%     ins{counter}.in = find(wat_shed == clabs(i));
%     
%     counter = counter + 1;
%     
% end
% 
% counter = 1;
% for i = ord
%     
%     if clabs(i) == 0
%         continue;
%     end
%     
%     wat_shed(ins{counter}.in) = label_counter;
%     
%     label_counter     = label_counter + 10;
%     
%     counter = counter + 1;
%     
% end
% 
seg_mask = wat_shed;




