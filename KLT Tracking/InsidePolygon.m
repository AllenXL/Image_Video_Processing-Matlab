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
% Description:  InsidePolygon.m
%               Given a polygon defined by its verticies and a point, this
%               function will determine if the point is within the polygon
%               or not.
%
% References:
%     
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
%          polygon - ordered point of a polygon, column 1 is x coordinates
%                   and column 2 is y coordinates
%          pt      - the point to be tested [x y]
%
% OUTPUTS:
%          Inside - 1 for inside and 0 for outside
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Inside] = InsidePolygon(polygon, pt)

p.x = pt(1);
p.y = pt(2);

counter = 0;
N = size(polygon,1);

p1.x = polygon(1,1);
p1.y = polygon(1,2);

for (i = 1:N)
    p2.x = polygon(mod(i,N)+1,1);
    p2.y = polygon(mod(i,N)+1,2);
    if (p.y > min(p1.y,p2.y))
        if (p.y <= max(p1.y,p2.y))
            if (p1.y ~= p2.y)
                xinters = (p.y-p1.y)*(p2.x-p1.x)/(p2.y-p1.y)+p1.x;
                if (p.x < xinters)
                    counter = counter + 1;
                end
            end
        end
    end
    p1.x = p2.x;
    p1.y = p2.y;
end

if (mod(counter,2)==0)
%     disp('Outside')
    Inside = 0;
else
%     disp('Inside')
    Inside = 1;
end