%--------------------------------------------------------------------------
%------------- Experimental Aerodynamics and Propulsion Lab ---------------
%-------------------- Group of Aerospace Engineering ----------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: Rodrigo Castellanos, Carlos Sanmiguel-Vila, Alejandro Güemes and
% Stefano Discetti.
%
% Description: Compute TBL parameters for the groundtruth profile. Data
% from DNS from Torroja, Retheta = 4500.
%--------------------------------------------------------------------------

clear; close all; clc;
%% Ground Truth profile
[REAL,wu,yp,Up,u2p,y,U,u2] = DNSprofileGT('../input/DNS/torroja_reth4500.mat',...
    'DNS_Torroja_Reth4500');

%- TBL fit parameters:
init.utau    =   REAL.utau;         % friction velocity
init.P       =   0.4;               % parameters for fit
init.y0      =   0.0000;            % initial wall position (estimate)
init.nu      =   REAL.nu;           % viscosity
init.delta   =   REAL.delta_99;     % delta_100


% modified by SD - 13/12/2020
wu=init.nu/init.utau;
Retau=init.delta/wu;
yf = [logspace(-1,log10(0.9*Retau),70) linspace(Retau*0.93,Retau*1.3,20)];
Uf = interp1(yp,Up,yf,'pchip');
y = yf*init.nu./init.utau;
U = Uf.*init.utau;
% y = yp*init.nu./init.utau;
% U = Up.*init.utau;
%%%%%%%%%%%%%%%%%%%%%%%%

%- Fit of GT profile:
Data.Y  = y(:); Data.U  = U(:); % Rearrange data for wallfit codes
indexProfile = 1:numel(U);      % Use the whole profile
[OutData,TBLstats,~,~] = ...
    fitData(Data,init,'','','',indexProfile);

%- TBL stats of the GT profile:
HGT     = TBLstats.Nickels.H;       % Shape factor
RetauGT = TBLstats.Nickels.Retau;   % Friction Re
RETHGT  = TBLstats.Nickels.Retheta; % Momentum thickness based Re
thetaGT = TBLstats.Nickels.theta;   % Momentum thickness
dsGT    = TBLstats.Nickels.ds;      % Displacement thickness
D99GT   = TBLstats.Nickels.d99;     % TBL thickness based on Nickels
D99GT_C = TBLstats.d99ch;           % TBL thickness based on Chauhan
UTAUGT  = OutData.utau;             % Viscous velocity
UINFGT = TBLstats.Nickels.Uinf; 
DYGT = nanmean(OutData.Ym - Data.Y);
DYwuGT = DYGT/(init.nu/OutData.utau);
clear OutData TBLstats Data y yp u2 u2p U Up init wu indexProfile;
save('..\output\DNSTorroja_ReTh4500-GT.mat')
