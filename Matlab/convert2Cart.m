function [ xyz ] = convert2Cart( WGS85 )
%convert2Cart Convert from WGS84 to Cartesian coordinates
%   Converting an array containing data from GPS coordinate system WGS84 to Cartesian coordinates
%   using the formulas:
%
% X = (v+h)*cos(theta)*cos(lambda)
% Y = (v+h)*cos(theta)*sin(lambda)
% Z = (v*(1*exp(2))+h)*sin(theta)
%
% Be aware that the input data should be in format [langtitude longitude timestamp]
a = 6378137;
f = 1/298.257223563;
e_2 = f*(2-f);
h = 0; 

% Assuming zero height
latitude = WGS85(:,1)*pi/180;
longitude = WGS85(:,2)*pi/180;
% Fast way
v = (a./sqrt(1-e_2.*sin(latitude).^2));
X = (v+h).*cos(latitude).*cos(longitude);
Y = (v+h).*cos(latitude).*sin(longitude);
Z = (v.*(1-e_2)+h).*sin(latitude);
xyz = [X Y Z];
end