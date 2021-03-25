%--------------------------------------------------------------------------
%------------- Experimental Aerodynamics and Propulsion Lab ---------------
%-------------------- Group of Aerospace Engineering ----------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: Rodrigo Castellanos, Carlos Sanmiguel-Vila, Alejandro Güemes and
% Stefano Discetti.
%
% Description: This matlab routines evaluates the  effect on the streamwise
% velocity profile of the bin averaging. The user can modify the number of
% window sizes to plot by modifying vector >>Win. The final figure compares
% the ground truth DNS profile with the averaged   prodiles depending on 
% bin size.
%--------------------------------------------------------------------------
%% Include paths of functions
clc, clear, close all;
addpath(genpath([pwd '/../bin'])); 
PlottingOptions;

%% User inputs
Win         = [2 4 8 16 32 64]; % window in pix
S           = 700;  % sensor size in pix
fileout     = '.\output\DNSprofilePlot';

%% Ground Truth profile
[REAL,wu,yp,Up,u2p,y,U,u2, v2, uv] = ...
    DNSprofileGT('../input/DNS/torroja_reth4500.mat',...
    'DNS_Torroja_Reth4500');
Retau = 1400;

%- Figure 1: Effect of averaging bin in TBL progile from DNS
figure(1)
semilogx(yp,Up,'k.-','LineWidth',1.5); hold on

%% Evaluate effect of bin size on DNS averaging profile
flag.datin  = 'DNS';    % DNS or CP (Composite Profile)
flag.debug  = 0;        % Plot TBL profile in debugging process
flag.fit    = 0;        % Fit the TBL profile after truncation
flag.noiseU = 0;        % Add noise to U
flag.noiseY = 0;        % Add noise to Y

for kk=1:length(Win)
    Res = S/REAL.delta_99/1.3; % Select our sensor to see 1.3d99 of the profile.
    TBLp.yp = yp; TBLp.Up = Up; TBLp.u2p = u2p; TBLp.wu = wu;
    [ypiv,Upiv] = sEPTV(TBLp,Win(kk),S,Res,wu,flag);
    %- Store each averaged profile:
    fileout     = sprintf('..\\output\\ExpWin%03d.mat', Win(kk));
    save(fileout,'ypiv','Upiv')
    %- Update figure 1:
    figure(1); semilogx(ypiv,Upiv,'.-','LineWidth',1)
    legendtext{kk+1} = [num2str(Win(kk)) ' pix'];
end
% Adjust visualization in Figure 1.
figure(1)
legendtext{1} = 'DNS'; legend(legendtext)
set(gcf,'units','points'); set(gcf,'Position',[10 10 236.68436 236.68436/1.61803]*1); set(gca,'fontsize',10);
xlabel('$y^+$'); ylabel('$U^+$');