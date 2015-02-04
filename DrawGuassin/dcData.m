function DS = dcdata(dataID)
% DCDATA Test data sets for data clustering (no class label).
% Usage: DS = dcdata(dataID)
%	DS: Data set

%	Roger Jang

if nargin==0, selfdemo; return; end

if dataID==1
	d1 = randn2(100)*0.25 + ones(100,1)*[1 1.5];
	d2 = randn2(100)*0.25 + ones(100,1)*[2 0];
	d3 = randn2(100)*0.25 + ones(100,1)*[1 -1.5];
	DS.clusterNum = 6;
	DS.input = [d1; d2; d3; -d1; -d2; -d3]';
elseif dataID==2
	d1=randn2(6000);
	mag = sqrt(sum(d1'.^2));
	DS.clusterNum = 8;
	DS.input = d1(mag>0.4 & mag<1.0,:)';
elseif dataID==3
	d1 = randn2(1000)*.5;
	d2 = randn2(1500)*5 + 10;
	d3 = randn2(2000)*7 + 30;
	DS.clusterNum = 3;
	DS.input = [d1; d2; d3]';
elseif dataID==4
	d1 = randn2(500)*20 + ones(500,1)*[50,0];
	d2 = randn2(200)*3 + ones(200,1)*[20,35];
	d3 = randn2(200)*3 + ones(200,1)*[10,5];
	DS.clusterNum = 3;
	DS.input = [d1; d2; d3]';
elseif dataID==5	
	dataNum = 150;
	data1 = ones(dataNum, 1)*[0 0] + randn(dataNum, 2)/5;
	data2 = ones(dataNum, 1)*[0 1] + randn(dataNum, 2)/5;
	data3 = ones(dataNum, 1)*[1 0] + randn(dataNum, 2)/5;
	data4 = ones(dataNum, 1)*[1 1] + randn(dataNum, 2)/5;
	DS.clusterNum = 4;
	DS.input = [data1; data2; data3; data4]';
elseif dataID==6
	n=100;
	dim=2;
	c1 = [0.125 0.25]'; data1 = randn(dim,n)/8 + c1*ones(1,n);
	c2 = [0.625 0.25]'; data2 = randn(dim,n)/8 + c2*ones(1,n);
	c3 = [0.375 0.75]'; data3 = randn(dim,n)/8 + c3*ones(1,n);
	c4 = [0.875 0.75]'; data4 = randn(dim,n)/8 + c4*ones(1,n);
	DS.clusterNum = 4;
	DS.input = [data1, data2, data3, data4];
elseif dataID==7	% ¤@ºû¸ê®Æ¡I
	dataNum = 1000;
	data1 = randn(1,2*dataNum);
	data2 = randn(1,3*dataNum)/2+2;
	data3 = randn(1,1*dataNum)/3-2;
	DS.clusterNum=3;
	DS.input = [data1, data2, data3];
else
	error('Unknown Data ID!')
end

% ====== Self demo
function selfdemo
for i = 1:6
	DS = feval(mfilename, i);
	subplot(2,3,i);
	dcprDataPlot(DS);
	title(['dataID = ', num2str(i)]);
end