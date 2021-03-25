%--------------------------------------------------------------------------
%------------- Experimental Aerodynamics and Propulsion Lab ---------------
%-------------------- Group of Aerospace Engineering ----------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: Rodrigo Castellanos, Carlos Sanmiguel-Vila, Alejandro Güemes and
% Stefano Discetti.
%
% Description: This matlab routine compares the DNS ground truth profile 
% with the ground truth profiles from experimental data. For experimental
% results window size in pixels is chosen >>Win=3 and sensor size >>S=700.
%--------------------------------------------------------------------------
%% Include paths of functions
clc, clear, close all;
addpath(genpath([pwd '/../bin'])); 
PlottingOptions;

%% Ground Truth profile
[REAL,wu,yp,Up,u2p,y,U,u2, v2, uv] = ...
    DNSprofileGT('../input/DNS/torroja_reth4500.mat',...
    'DNS_Torroja_Reth4500');
Retau = 1400;

%- Figure 2: TBL profile from DNS compared with experimental data
% subplot 1: U vs Y (average profile)
% subplot 2: u' vs Y (fluctuations)
figure(2)
subplot(1,2,1); semilogx(yp,Up,'k.-','LineWidth',1.5); hold on
subplot(1,2,2); semilogx(yp,u2p,'k.-','LineWidth',1.5); hold on

%% Experimental ground truth (Lens 100mm)
Win         = 3;    % window in pix
S           = 700;  % sensor size in pix
%- TBL fit parameters:
init.utau    =   0.04;               % friction velocity
init.P       =   0.4;               % parameters for fit
init.y0      =   0.0030;            % initial wall position (estimate)
init.nu      =   8.756778122657612e-07;           % viscosity
init.delta   =   0.03;              % delta_100
init.Re_tent =   1300;              % tentative value for friction Reynolds number

%- Lens 100 mm
dt  = 2.4e-4;
Res = 65130; 
%- Load data:
filename = sprintf('../input/EPTV/EPTV_Lens100mm_Win200x%d_Nimg28000.mat', Win);
load(filename);
%- Prepare vectors:
ypiv = (max(Mat(:,1,2))-mean(Mat(:,:,2),2));
Upiv = mean(Mat(:,:,3),2);
u2piv = mean(Mat(:,:,5),2);
v2piv = mean(Mat(:,:,6),2);
uvpiv = mean(Mat(:,:,7),2);
[ypiv,Upiv,u2piv,v2piv,uvpiv] = ...
    preprocPLOT_EPTV(ypiv,Upiv,u2piv,v2piv,uvpiv,Win,Res,dt); clear Mat;
%- Perform FIT:
indexProfile    = 1:numel(Upiv);
Data.Y          = ypiv(:);
Data.U          = Upiv(:);
[OutData,~,~,~] = ...
    fitData(Data,init,'','','',indexProfile);
%- Extract Stats:
UTAU = OutData.utau;
ypiv = OutData.Ym;
Upiv = OutData.Um;
%- Normalize in Wall Units:
yp = ypiv/(init.nu/UTAU);
Up = Upiv/UTAU;
u2p = u2piv/UTAU;
v2p = v2piv/UTAU;
uvp = uvpiv/UTAU^2;
%- Save output data:
fileout     ='..\\output\\ExpLens100mm.mat';
save(fileout,'yp','Up', 'u2p', 'v2p','uvp')
%- Update Figure:
figure(2)
subplot(1,2,1), semilogx(ypiv/(init.nu/UTAU),Upiv/UTAU,'b.-')
subplot(1,2,2), semilogx(ypiv/(init.nu/UTAU),u2piv/UTAU,'b.-')

%% Experimental ground truth (Lens 50mm)
%- Lens 50 mm
dt  = 6.4e-4;
Res = 25270;

%- Load data:
filename = sprintf('../input/EPTV/EPTV_Lens50mm_Win200x%d_Nimg28000.mat', Win);
load(filename);
%- Prepare vectors:
ypiv = (max(Mat(:,1,2))-mean(Mat(:,:,2),2));
Upiv = mean(Mat(:,:,3),2);
u2piv = mean(Mat(:,:,5),2);
v2piv = mean(Mat(:,:,6),2);
uvpiv = mean(Mat(:,:,7),2);
[ypiv,Upiv,u2piv,v2piv,uvpiv] = ...
    preprocPLOT_EPTV(ypiv,Upiv,u2piv,v2piv,uvpiv,Win,Res,dt); clear Mat;
%- Perform FIT:
indexProfile    = 1:numel(Upiv);
Data.Y          = ypiv(:);
Data.U          = Upiv(:);
[OutData,~,~,~] = ...
    fitData(Data,init,'','','',indexProfile);
%- Extract Stats:
UTAU = OutData.utau;
ypiv = OutData.Ym;
Upiv = OutData.Um;
%- Normalize in Wall Units:
yp = ypiv/(init.nu/UTAU);
Up = Upiv/UTAU;
u2p = u2piv/UTAU;
v2p = v2piv/UTAU;
uvp = uvpiv/UTAU^2;
%- Save output data:
fileout     ='..\\output\\ExpLens50mm.mat';
save(fileout,'yp','Up', 'u2p', 'v2p','uvp')
figure(2)
subplot(1,2,1); semilogx(ypiv/(init.nu/UTAU),Upiv/UTAU,'r.-')
subplot(1,2,2); semilogx(ypiv/(init.nu/UTAU),u2piv/UTAU,'r.-')

%% Visualization of plot
legend({'DNS','EPTV 50mm','EPTV 100mm'})
subplot(1,2,1); xlabel('$y^+$'); ylabel('$U^+$'); set(gca,'fontsize',10);
subplot(1,2,2); xlabel('$y^+$'); ylabel('$u^+$'); set(gca,'fontsize',10);
set(gcf,'units','points'); 
F2.p = gcf; F2.p.Position(3) = 487.8225; F2.p.Position(4) = 487.8225/4;