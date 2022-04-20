function [x,y,z]=sph2rec(R,theta,phi)
x = R .* sin(phi) .* cos(theta);
y = R .* sin(phi) .* sin(theta);
z = R.* cos(phi);
end