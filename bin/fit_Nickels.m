%--------------------------------------------------------------------------
%------------- Experimental Aerodynamics and Propulsion Lab ---------------
%-------------------- Group of Aerospace Engineering ----------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: Rodrigo Castellanos, Carlos Sanmiguel-Vila, Alejandro Güemes and
% Stefano Discetti.
%
% - Modified version by Rodrigo Castellanos 25/11/2020
% Routine to find the BL edge in ZPG and to compute TBL statistics
%--------------------------------------------------------------------------

function [TBLstats,y,u] = fit_Nickels(y,U,utau,nu)

%- Wall units:
lstar    = nu/utau;
Up       = U/utau;
yp       = y/lstar;

%% Nickels:
Uinf2H12=.99;
% yplus position as U/Uinf and delta_percent^plus
warning off
% Options of the optimization process:
s = fitoptions('Method','NonlinearLeastSquares','MaxFunEvals',1e4,'MaxIter',1e4); %
% Objective function to fit:
Nickels = fittype('(yco.*(1-(1+2.*x/yco+1/2.*(3-px*yco).*(x/yco).^2-3/2*px*yco*(x/yco).^3).*exp(-3.*x/yco)))+(sqrt(1+px*yco)/(6*kappan)*log((1+(.6*(x/yco)).^6)./(1+(x/Ret).^6)))+((2*P/kappan).*(1-exp(-(5*((x/Ret).^4+(x/Ret).^8)./(1+5*(x/Ret).^3)))))',...
    'options',s);

%P,Ret,kappan,px,yco,x
[f,~]   = fit(yp,Up,Nickels,'Lower',[0  30 0.2 -.5 5],'Upper',[10 2e4 0.7 .5 20]);

% Sublayer profile (Nickels)
kappan  = f.kappan;     % Universal constant (von Kármán)
yco     = f.yco;        % measure of the sublayer thickness
px      = f.px;         % px =(nu*rho*Utau^3)*dp/dx)
Ret     = f.Ret;        % Reynolds_tau
P       = f.P;          % profile parameter (related to skin friction)
Cwo     = 2*P/kappan;   % Coles' wake parameter

ypfun   = [0.1:0.1:max(yp)*1.1]; % Value of y+
Ui      = yco.*(1-(1+2.*ypfun/yco+1/2.*(3-px*yco).*(ypfun/yco).^2 - ...
    3/2*px*yco*(ypfun/yco).^3).*exp(-3.*ypfun/yco)); % Functional form of the sublayer region
eta     = (ypfun/Ret); % eta = yp/Retau (y/delta99)
Ul      = sqrt(1+px*yco)/(6*kappan)*log((1+(.6*(ypfun/yco)).^6)./(1+eta.^6));
Uw      = Cwo*(1-exp(-(5*(eta.^4+eta.^8)./(1+5*eta.^3))));
% Final profile
UN      = Ui+Ul+Uw;
% Determine value of freestream velocity
UinfCP  = UN(end);
[~,do]  = min(abs(UN-Uinf2H12*max(UN)));
do2     = knnsearch(yp>ypfun(do),ypfun(do));
indH12  = do2;
Retau   = ypfun(do);


%% Compute statistics
edge = do;
y = ypfun;
u = UN;
Uinf = UinfCP;
clearvars -except edge y u Uinf Retau utau lstar;

% Calculation of displacement thicknes:
u1      = 1-u(1:edge)/Uinf;
delta   = trapz(y(1:edge),u1);
% Calculation of momentum thicknes:
u2      = u(1:edge)/Uinf.*(1-u(1:edge)/Uinf);
theta   = trapz(y(1:edge),u2);
% Shape factor based on BL thickness:
H       = delta/theta;
Retheta = Uinf*theta;
% Friction coefficient:
cf      = 2.*(1./Uinf).^2; % real value

%-Output:
TBLstats.Uinf    = Uinf*utau;
TBLstats.d99     = Retau*lstar;
TBLstats.ds      = delta*lstar;
TBLstats.theta   = theta*lstar;
TBLstats.H       = H;
TBLstats.cf      = cf;
TBLstats.Retau   = Retau;
TBLstats.Retheta = Retheta;


% Plot data:
% % % figure(1); clf
% % % semilogx(yp,Up,'r.'); hold on % Data
% % % semilogx(ypfun,UN,'k-'); hold on % Interpolation
% % % semilogx([ypfun(do) ypfun(do)],[0 UN(do)+1],'g'); % BL thickness from interpolated profile
% % % semilogx([yp(do2) yp(do2)],[0 Up(do2)+1],'b'); % BL thickness from original profile
% % % ylim([0 Up(do2)+1]); xlim([min(ypfun) max(ypfun)]);
% % % xlabel('$y^+$'); ylabel('$U^+$'); grid on; grid minor;
% % % title('BL profile with Nickels interpolation');
% % % eval(['print -f1 -djpeg100 NickelsFit_Retau',num2str(round(Retau)),';']);
