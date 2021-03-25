%--------------------------------------------------------------------------
%------------- Experimental Aerodynamics and Propulsion Lab ---------------
%-------------------- Group of Aerospace Engineering ----------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: Rodrigo Castellanos, Carlos Sanmiguel-Vila, Alejandro Güemes and
% Stefano Discetti.
%
% new version by Stefano Discetti & Rodrigo Castellanos 
% v 3.0  24/11/2020
%--------------------------------------------------------------------------
function [OutData,TBLstats,diag,indexProfile] = fitData(Data,init,Save,Case,DebugFit,indexProfile)

%% Get initial values
nu = init.nu; utau = init.utau; delta = init.delta; P = init.P; clear init;
%% Ordering the wall-position and the velocity vectors:
[Ym,ysort] = sort(Data.Y);   % Ordered wall position
Um         = Data.U(ysort);  % Reorder velocity according to wall position

%- Select the desired set of points:
U = Um(indexProfile); y = Ym(indexProfile); clear Um Ym 

%% TBL analytical fit
%- First fit: all profile interpolation
x       = fit_nagib(y,U,nu,utau,delta, P,DebugFit,'outer');
utau    = x(1);     % Friction velocity
yw      = x(4);     % Position of the wall
lstar   = nu/utau;  % BL length scale
y       = y+yw;     % Adjustment of wall coordinates
delta   = x(2)+yw;  % d99 TBL thickness
yp      = y/lstar;  % Wall cordinates in wall units
P = x(3);
ycor  = y;

%% Renaming data:
OutData.Ym = ycor;
OutData.Um = U;
OutData.utau = utau;

%% Diagnostic plots:
diag = [];

%% Nickels:
TBLstats.d99ch = delta;
% [TBLstats.Nickels]  = TBLstatistics_withFit(U(ycor>0),ycor(ycor>0),utau,nu,1,'Nickels',delta,P,'YES');
[TBLstats.Nickels,~,~] = fit_Nickels(y,U,utau,nu);
%% Save
if strcmp(Save,'YES')
    filename = sprintf('%s_stat',Case);
    save(filename,'OutData','TBLstats','diag')
end
