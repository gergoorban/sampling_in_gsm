function [Sigma, mu, Pz_x, zRange] = infer_u_and_z_indivzrange(x,A,rho,kGam,thGam,sigmaX,varargin)

% USAGE: [Sigma, mu, Pz_x, zRange] = infer_u_and_z_indivzrange(x,A,rho,kGam,thGam,sigmaX,varargin)
%
% Input arguments:
% x     data; dimensions: Dim(x) x Batch size
% A     feature matrix; dimensions: Dim(x) x Dim(y)
% rho   the covariance matrix of the normally-distributed latent, it is
%       referred to as C in the derivation; dimensions: Dim(u) x Dim(y)
% varargin sets the numbr of mixure components for z: if set to 1, then MAP
%       is used, otherwise a range is specified in which the number of mixture 
%       components is set up.
%
% Written by Gergo Orban (go223@cam.ac.uk)

args=varargin;
nargs=length(args);
if (nargs>0),
    Dz = args{1};
else
    Dz = 100;
end

[Dx T]=size(x);
if (T>1),
    error('in infer_u_and_z_indivzrange: only one stimulus is supposed')
end
Dy=size(rho,1);

rhoInv = inv(rho);
ATA = A' * A;
ACAT = A * rho * A';
Sigma0 = eye(Dx)*(sigmaX^2);
x0=zeros(Dx,1);

zRange = zeros(1,T, Dz);
zPostMaxs=zeros(1,T);
zRanges=zeros(2,T);
for tt=1:T
    [zPostMaxs(tt) zRanges(1,tt) zRanges(2,tt)]= ...
        get_pz_x_max(x(:,tt), Sigma0, ACAT, x0,kGam,thGam);
    if (Dz>1)
        zRange(1,tt,:) = linspace(zRanges(1,tt), zRanges(2,tt),Dz);
    else
        zRange(1,tt,1) = zPostMaxs(tt); 
    end
end;

lPz_x = ones(1,T,Dz)*(-1000000000000);
Pz_x = zeros(1,T,Dz);

Sigma = zeros(Dy,Dy,Dz);
mu = zeros(Dy,Dz);

tt=1;
if (Dz>1),
    for zi=1:Dz,
        lPz_x(:,tt,zi) = log(gampdf(zRange(1,tt,zi),kGam,thGam)) + ...
            normpdfln(x(:,tt), x0, [], Sigma0+zRange(1,tt,zi)^2 * ACAT);     % 1*T*z
    end;
    Pz_x(1,tt,:) = exp(lPz_x(1,tt,:) - max(lPz_x(1,tt,:)));
    Pz_x(1,tt,:) = Pz_x(1,tt,:) / sum(Pz_x(1,tt,:));
else
    Pz_x(1,tt,1)=1;
    lPz_x(1,tt,1)=0;
end

for zi=1:Dz,
    Sigma(:,:,zi) = inv(rhoInv + zRange(1,tt,zi)^2/(sigmaX^2) * ATA);   % Du * Du
    mu_x = zRange(1,tt,zi) /(sigmaX^2) * Sigma(:,:,zi) * A';        % Du * Dx
    mu(:,zi) = mu_x * x(:,tt);                                    % Du * 1
end;
