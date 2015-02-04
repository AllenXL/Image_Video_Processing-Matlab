function out = gaussian(data, gParam);
% gaussian: Multi-dimensional Gaussian propability density function
%	Usage: out = gaussian(data, gParam)
%		data: d x n data matrix, representing n data vector of dimension d
%		gParam.mu: d x 1 vector
%		gParam.sigma: covariance matrix of 3 possible sizes
%			1 x 1: scalar times an identity matrix
%			d x 1: diagonal
%			d x d: full
%		out: 1 x n vector
%
%	Type "gaussian" for a self demo.
%
%	For example:
%
%		gParam.mu = [0; 0];
%		gParam.sigma = [9 3; 3, 4];
%		bound = 8;
%		pointNum = 31;
%		x = linspace(-bound, bound, pointNum);
%		y = linspace(-bound, bound, pointNum);
%		[xx, yy] = meshgrid(x, y);
%		data = [xx(:), yy(:)]';
%		out = gaussian(data, gParam);
%		zz = reshape(out, pointNum, pointNum);
%		subplot(2,2,1);
%		mesh(xx, yy, zz);
%		axis([-inf inf -inf inf -inf inf]);
%		set(gca, 'box', 'on');
%		subplot(2,2,2);
%		contour(xx, yy, zz, 15);
%		axis image;

%	Roger Jang, 20000602, 20080726

if nargin<1, selfdemo; return; end
[dim, dataNum]=size(data); 

dataMinusMu = data-repmat(gParam.mu, 1, dataNum);

if prod(size(gParam.sigma))==1	% identity covariance matrix times a constant for each Gaussian
	out = exp(-sum(dataMinusMu.*dataMinusMu/gParam.sigma, 1)/2)/((2*pi)^(dim/2)*sqrt(gParam.sigma^dim));
elseif prod(size(gParam.sigma))==dim	% diagonal covariance matrix for each Gaussian
	out = exp(-sum(dataMinusMu./repmat(gParam.sigma, 1, dataNum).*dataMinusMu, 1)/2)/((2*pi)^(dim/2)*sqrt(prod(gParam.sigma)));
else	% full covariance matrix for each Gaussian
	invCov = inv(gParam.sigma);			% For repeated invocation of this function, this step should be moved out of this function
	out = exp(-sum(dataMinusMu.*(invCov*dataMinusMu), 1)/2)/((2*pi)^(dim/2)*sqrt(det(gParam.sigma)));
end

% ====== Self demo ======
function selfdemo
% Plot 1-D Gaussians
x = linspace(-10, 10);
subplot(2,1,1);
hold on
for i = 1:20
	gParam.mu=0; gParam.sigma=i;
	y = feval(mfilename, x, gParam);
	plot(x,y);
end
hold off; box on

% Plot 2-D Gaussians
gParam.mu = [0; 0];
gParam.sigma = [9 3; 3, 4];

bound = 8;
pointNum = 31;
x = linspace(-bound, bound, pointNum);
y = linspace(-bound, bound, pointNum);
[xx, yy] = meshgrid(x, y);

data = [xx(:), yy(:)]';
out = feval(mfilename, data, gParam);
zz = reshape(out, pointNum, pointNum);

subplot(2,2,3);
mesh(xx, yy, zz);
axis([-inf inf -inf inf -inf inf]);
set(gca, 'box', 'on');

subplot(2,2,4);
contour(xx, yy, zz, 15);
axis image;

gParam.mu=1;
gParam.sigma=2;
area = quad('gaussian', -10, 10, [], [], gParam);
fprintf('The integration from -10 to 10 for a Gaussian is %g.\n', area);
