
% This function calculates Gravitational constant. 
function G=NGconstant(iteration,max_it)

 
%  G=G0*(1-(iteration/max_it)); % eq.17.
% G0=1;G=G0*(1-(iteration/max_it));
G0=20;G=G0*(1-(iteration/100));
%   alfa=2;G0=100;
%   G=G0*exp(-alfa*iteration/max_it); %eq. 28.
