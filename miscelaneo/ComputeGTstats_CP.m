%--------------------------------------------------------------------------
%------------- Experimental Aerodynamics and Propulsion Lab ---------------
%-------------------- Group of Aerospace Engineering ----------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: Rodrigo Castellanos, Carlos Sanmiguel-Vila, Alejandro Güemes and
% Stefano Discetti.
%
% Description: Compute TBL parameters for the groundtruth profile. Data
% from composite profile proposed by Chauhan (2009), Retheta = 4500.
%--------------------------------------------------------------------------

clear; close all; clc;
%% Ground Truth profile
%- TBL fit parameters:
init.utau    =   0.7;               % friction velocity
init.P       =   0.4;               % parameters for fit
init.y0      =   0.0000;            % initial wall position (estimate)
init.nu      =   1.55e-5;           % viscosity
init.delta0  =   0.042;              % delta_100
init.Re_tent =   1400;              % tentative value for friction Reynolds number

%% Ground Truth profile
%- Obtain profile from Chauhan-Nagib fit:
y       = logspace(log10(0.01*init.delta0/init.Re_tent),log10(1*init.delta0),init.Re_tent);
U_nagib = analytic_profile_TBL(y,init.utau,init.delta0,init.P,init.nu);
%- Add a wake to the profile up to 1.3*d99:
y       = [y linspace(1.01*init.delta0,1.3*init.delta0,20)];
U_nagib = [U_nagib U_nagib(end)*ones(1,20)];
init.delta = y(end)/1.3;
Uinf    = U_nagib(end);
%- Wall units:
yp      = y.*init.utau/init.nu;
Up      = U_nagib./init.utau;

% modified by SD - 13/12/2020
wu=init.nu/init.utau;
Retau=init.delta0/wu;
yf = [logspace(-1,log10(0.9*Retau),70) linspace(Retau*0.93,Retau*1.3,20)];
Uf = interp1(yp,Up,yf,'pchip');
y = yf*init.nu./init.utau;
U_nagib = Uf.*init.utau;
%%%%%%%%%%%%%%%%%%%%%%%%

%- Fit and extract stats from GT profile:
Data.Y  = y(:); Data.U  = U_nagib(:); % Rearrange data for wallfit codes
indexProfile = 1:numel(U_nagib);      % Use the whole profile
[OutData,TBLstats,~,~] = ...
    fitData(Data,init,'','','',indexProfile);
HGT     = TBLstats.Nickels.H;       % Shape factor
RetauGT = TBLstats.Nickels.Retau;   % Friction Re
RETHGT  = TBLstats.Nickels.Retheta; % Momentum thickness based Re
thetaGT = TBLstats.Nickels.theta;   % Momentum thickness
dsGT    = TBLstats.Nickels.ds;      % Displacement thickness
D99GT   = TBLstats.Nickels.d99;     % TBL thickness based on Nickels
D99GT_C = TBLstats.d99ch;           % TBL thickness based on Chauhan
UTAUGT  = OutData.utau;             % Friction velocity
UINFGT = TBLstats.Nickels.Uinf; 
DYGT = nanmean(OutData.Ym - Data.Y);
DYwuGT = DYGT/(init.nu/OutData.utau);
clear OutData TBLstats Data y yp Uinf U_nagib Up indexProfile;
save('..\output\Nagib_Retau1400-GT.mat')
