%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PROJECT:
%     KLT Tracker
%
% BY:
%     Parthipan Siva
%     Assignment for SD 770-7: Topics in Particle Filtering
%     Systems Design Engineering
%     University of Waterloo
%
% DATE/Version:
%     Jan. 2007 - V 1.0
%
% Description:  drawEllipse.m
%               Given the PETS individual rectangle location, dimensions
%               and orientation this function will draw an incribing
%               ellipse inside that rectangle.
%
% References:
%     http://www-prima.inrialpes.fr/PETS04/caviar_data.html
%
% Project file list: 
%     drawEllipse.m
%     InsidePolygon.m
%     kltTrack.m
%     kltTrackSIMPLE.m
%     readKLTFeatureList.m
%     Example1.m
%     Example2.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUTS:
%          cent - the center of ellipse
%          spread - the length of ellipse along x and y axis
%          orientation - the orientaion of the ellipse in degrees
%
% OUTPUTS:
%          ellipse - set of coordinates of the ellipse. The first
%                    coordinate is repeated so a closed ellipse will be 
%                    formed when ploting.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ellipse = drawEllipse(cent, spread, orientation)

orientation = orientation/180*pi;

N = 200;
angle = pi/180*[0:360/(N-1):360];
x = [cos(angle); sin(angle)];

V = [cos(orientation) sin(orientation); -sin(orientation) cos(orientation)];
lamda = [spread(1) 0; 0 spread(2)];

x = V*(lamda*x);

x = x + [ones(1,N).*cent(1); ones(1,N).*cent(2)];

ellipse = x;