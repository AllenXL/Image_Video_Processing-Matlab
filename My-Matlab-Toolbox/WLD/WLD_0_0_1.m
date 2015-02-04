%  WLD returns the local texture pattern of an image.
% Version 0.0.1

% The example codes are computed using N=8 sampling points on a square of R=3
image=imread('image\orig-face.bmp');
subplot(2,2,1),imshow(image); title('RGB image'); %stem(image);
image=rgb2gray(image); subplot(2,2,2),imshow(image); title('grey image');
d_image=double(image);


% Determine the dimensions of the input image.
[ysize xsize] = size(image);


% Block size, each WLD code is computed within a block of size bsizey*bsizex
bsizey=3;
bsizex=3;

BELTA=5; % to avoid that center pixture is equal to zero
ALPHA=3; % like a lens to magnify or shrink the difference between neighbors
EPSILON=0.0000001;
PI=3.141592653589;
numNeighbors=8;  % using 3*3 patch for example

% Minimum allowed size for the input image depends
% on the radius of the used LBP operator.
if(xsize < bsizex || ysize < bsizey)
  error('Too small input image. Should be at least (2*radius+1) x (2*radius+1)');
end

% filter
%    1  2  3  4   5  6  7  8  9
f00=[1, 1, 1; 1, -8, 1; 1, 1, 1];


% Calculate dx and dy;
dx = xsize - bsizex;
dy = ysize - bsizey;

% two matriies 
% Initialize the result matrix with zeros.
d_differential_excitation = zeros(dy+1,dx+1);
d_gradient_orientation    = zeros(dy+1,dx+1);

%Compute the WLD code per pixle
for y = 2:ysize-1
    for x = 2:xsize-1
         N=d_image(y-1:y+1,x-1:x+1); % 3*3 block neighbors
         center=d_image(y,x);
        
        % step 1 compute differential excitationt
        v00=sum(sum(f00 .* N));
        v01=center + BELTA; % BELTA to avoid that center pixture is equal to zero

        if ( v01 ~= 0 )
            d_differential_excitation(y,x)=atan(ALPHA*v00/v01);% ALPHA like a lens to magnify or shrink the difference between neighbors
        else
            d_differential_excitation(y,x)=0.1;% set the phase of the current pixel directly by WLD
        end
        
         % step 2 compute gradient orientation
         N1=d_image(y-1,x);         N5=d_image(y+1,x);
         N3=d_image(y,x+1);         N7=d_image(y,x-1);
         
         if ( abs(N7-N3) < EPSILON)		d_gradient_orientation(y,x) = 0;
         else
             v10=N5-N1;		v11=N7-N3;
             d_gradient_orientation(y,x) = atan(v10/v11);
             
             % transform to a degree for convient visualization
             d_gradient_orientation(y,x)=d_gradient_orientation(y,x)*180/PI;
             
             if     (v11 >  EPSILON && v10 >  EPSILON)		
                 d_gradient_orientation(y,x)= d_gradient_orientation(y,x)+ 0;    % the first quadrant
             elseif (v11 < -EPSILON && v10 >  EPSILON)      
                 d_gradient_orientation(y,x)= d_gradient_orientation(y,x)+ 180;  % the second quadrant
             elseif (v11 < -EPSILON && v10 < -EPSILON)      
                 d_gradient_orientation(y,x)= d_gradient_orientation(y,x)+ 180;  % the third quadrant
             elseif (v11 >  EPSILON && v10 < -EPSILON)		
                 d_gradient_orientation(y,x)= d_gradient_orientation(y,x)+ 360;  % the fourth quadrant
             end
         end
    end
end
% for illustrations
subplot(2,2,3),hist(d_differential_excitation); title('histogram of differential excitation')
image_DE = (255* (d_differential_excitation - (-PI/2))/((PI/2)-(-PI/2)));% by mapping the differential excitation to [0,255]
subplot(2,2,4),imshow(mat2gray(uint8(image_DE)));title('differential excitation scaled to [0,255]')
figure,imshow(mat2gray(uint8(image_DE)));title('differential excitation scaled to [0,255]')

%% an alternative speed-up  WLD computation for the component of differential_excitation,
%% Thanks for Amir Kolaman (www.ee.bgu.ac.il/~kolaman)
LOG=conv2(d_image,f00,'same'); %convolve with f00
LOG_scaled=atan(ALPHA*LOG./(d_image+BELTA)); %perform the tangent scaling
LOG_norm=255*(LOG_scaled-min(min(LOG_scaled)))/(max(max(LOG_scaled))-min(min(LOG_scaled)));
figure;imshow(uint8(LOG_norm)); title('LOG scaled with atan');