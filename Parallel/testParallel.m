% matlabpool local 2 % two core according to the number of your computer
% 
tic
maxNumber=10^5;
parfor i=1:maxNumber
    f(i)=i^2+i^3;
end
toc

matlabpool close  % close the matlab parallel environment

% tic
% maxNumber=10^5;
% for i=1:maxNumber
%     f(i)=i^2+i^3;
% end
% toc
