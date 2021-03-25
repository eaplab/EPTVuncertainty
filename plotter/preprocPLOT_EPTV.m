function [yf,Uf,u2f,v2f,uvf] = preprocPLOT_EPTV(ypiv,Upiv,u2piv,v2piv,uvpiv,Win,Res,dt)

%% Data from experiments:
utau = 0.0425;
Retau =  1.380e+03;
nu = 8.756778122657612e-07;
lstar = nu/utau;

%% Cut profile
idxStart = find((ypiv-ceil(Win*3/4)) > 0,1);
ypiv = ypiv(idxStart:end)./Res;
Upiv = Upiv(idxStart:end)./Res./dt;
u2piv = u2piv(idxStart:end)./Res./dt;
v2piv = v2piv(idxStart:end)./Res./dt;
uvpiv = uvpiv(idxStart:end)./Res./dt./Res./dt;
% Fiteamos:
yf = [logspace(-1,log10(0.9*Retau),70) linspace(Retau*0.93,Retau*1.3,20)]*lstar;
Ledge = find(yf>=ypiv(1),1);
yf = yf(Ledge:end);

[ypiv,c]= unique(ypiv); Upiv = Upiv(c); u2piv = u2piv(c); v2piv = v2piv(c); uvpiv = uvpiv(c);

Uf = interp1(ypiv,Upiv,yf,'pchip');
u2f = interp1(ypiv,u2piv,yf,'pchip');
v2f = interp1(ypiv,v2piv,yf,'pchip');
uvf = interp1(ypiv,uvpiv,yf,'pchip');