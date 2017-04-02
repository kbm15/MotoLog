function [ dataout ] = interpol( datain )
%interpol interpolate the data points of a given set
%   This function allows for 2 different interpolation methods, spline and
%   pchip, selectable by setting the 2. argument to 1 or 2 respectively.
%   Furthermore it allows the user to specify the number of interpolation
%   points using the 3. argument.
n=150;

x = datain(:,1)';
y = datain(:,2)';
z = datain(:,3)';
t = (1:length(datain(:,3)));
tt = linspace(min(t),max(t),n);
xx = spline(t,x,tt);
yy = spline(t,y,tt);
zz = spline(t,z,tt);

dataout(:,1)=xx;
dataout(:,2)=yy;
dataout(:,3)=zz;
dataout(:,4)=tt;
end