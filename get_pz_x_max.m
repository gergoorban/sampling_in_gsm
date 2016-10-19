function [z, zMin, zMax]=get_pz_x_max(x, Sigma0, ACAT, x0,kGam,thGam)

% Usage: [z, zMin, zMax]=get_pz_x_max(x, Sigma0, ACAT, x0,kGam,thGam)
%
% this function aims to determine a sensible range of integration for the latent
% variable z based on the posterior Pz_x for one particular image
% Output arguments: z: the value of z where the posterior has maximum
%                   zMin & zMax: the bottom and the top of the integration
%                   range, respectively
%
% Written by Gergo Orban (go223@cam.ac.uk)

threshold=1000;

% options=optimset('Display', 'off');
options = optimset('fmincon');
options.LargeScale = 'off';
options.Display = 'off';
% options.Algorithm = 'active-set';
options.Algorithm = 'interior-point';

[z lPz_xMax]=fmincon(@(z) calc_pz_x(z, x, Sigma0, ACAT, x0,kGam,thGam),1,-1,0,[],[],[],[],[],options);
lPz_xMax=-lPz_xMax;

g=0.8;
zMin=g*z;
lPz_x=calc_pz_x(zMin, x, Sigma0, ACAT, x0,kGam,thGam);
lPz_x=-lPz_x;
g=g-.1;
while ( ((lPz_xMax-lPz_x)<log(threshold) && g>0) )
    zMin=g*z;
    lPz_x=calc_pz_x(zMin, x, Sigma0, ACAT, x0,kGam,thGam);
    lPz_x=-lPz_x;
    g=g-.1;
end

g=1+1-g;
zMax=g*z;
lPz_x=calc_pz_x(zMax, x, Sigma0, ACAT, x0,kGam,thGam);
lPz_x=-lPz_x;
g=g+.1;
while ((lPz_xMax-lPz_x)<log(threshold))
    zMax=g*z;
    lPz_x=calc_pz_x(zMax, x, Sigma0, ACAT, x0,kGam,thGam);
    lPz_x=-lPz_x;
    g=g+.1;
end

function lPz_x = calc_pz_x(z, x, Sigma0, ACAT, x0,kGam,thGam)

lPz_x = log(gampdf(z,kGam,thGam)) + ...
    normpdfln(x, x0, [], Sigma0+z^2 * ACAT);
lPz_x=-lPz_x;
    
    