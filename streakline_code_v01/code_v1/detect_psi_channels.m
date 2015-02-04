function channels =detect_psi_channels(psi,num_c)

% num_c = 3;
[C]=contourc(psi,num_c);

clear cntour
cnt = 1;
mn = min(psi(:)) ; mx = max(psi(:));
cnt2 = 1;
%     cntour.value(1) = mn;
for i = 1:num_c+1

    if cnt> size(C,2)
        continue
    end;
    cntour.value(i) = C(1,cnt);
    cntour.n(i) = C(2,cnt);
    cntour.points{i} = C(:,cnt+1:cnt+cntour.n(i));
    cnt = cnt + cntour.n(i)+1;
end;
values=unique(cntour.value(:));
values = [mn;values;mx];
values = sort(values);  
    

channels = zeros(size(psi,1),size(psi,2),length(values)-1);
for i = 2:length(values)
    tmp =0*psi;
    tmp(psi>values(i-1)& psi<=values(i)) = 1;
    channels(:,:,i-1) = tmp;
%     imagesc(tmp),title(num2str(i));
%     pause
%     
end

