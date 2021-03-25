function [yf,Uf] = preprocEPTVprofile(ypiv,Upiv,Win,Res,dt)

%% Data from experiments:
utau = 0.0425;
Retau =  1.380e+03;
nu = 8.756778122657612e-07;
lstar = nu/utau;

% figure
% semilogx(ypiv./Res,Upiv./Res./dt,'.')
% hold on

%% Cut profile
idxStart = find((ypiv-ceil(Win*3/4)) > 0,1);
ypiv = ypiv(idxStart:end)./Res;
Upiv = Upiv(idxStart:end)./Res./dt;

% Fiteamos:
yf = [logspace(-1,log10(0.9*Retau),70) linspace(Retau*0.93,Retau*1.3,20)]*lstar;
Ledge = find(yf>=ypiv(1),1);
yf = yf(Ledge:end);

[ypiv,c]= unique(ypiv); Upiv = Upiv(c);

Uf = interp1(ypiv,Upiv,yf,'pchip');


% 
% figure(1)
% semilogx(ypiv,Upiv,'o')
% hold on
% semilogx(yf,Uf,'.')
% legend({'Original','Truncated','Fitted'})
% pause