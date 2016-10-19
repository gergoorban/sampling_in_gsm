function [r, V] = calc_firing_rate(mu, k, Vth, m, nonLinExponent)

% USAGE: [r, V] = calc_firing_rate(mu, k, Vth, m, nonLinExponent)
%
% r = k * (V-Vth)^m_+

u = mu;

fu=zeros(size(u));
fu(u<0)=-abs(u(u<0)).^nonLinExponent;
fu(u>=0)=u(u>=0).^nonLinExponent;

uRect = fu - Vth; uRect(uRect<0)=0;

r = k * uRect.^m;
V=fu;
