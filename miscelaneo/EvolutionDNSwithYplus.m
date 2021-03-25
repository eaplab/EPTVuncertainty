%--------------------------------------------------------------------------
%------------- Experimental Aerodynamics and Propulsion Lab ---------------
%-------------------- Group of Aerospace Engineering ----------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: Rodrigo Castellanos, Carlos Sanmiguel-Vila, Alejandro Güemes and
% Stefano Discetti.
%
% Description: Matlab script to evaluate the value of the TBL params
% according to the location in y+. We cut the upper part of the TBL profile
% from DNS data: the upper limit is fixed by the DNS data and the lower 
% limit is modified from y+ = 1 to y+ = 80 to see how it does affect to
% catch points within the viscous sublayer and the buffer region to a
% correct estimations of TBL statistics.
%--------------------------------------------------------------------------

%% Include paths of functions
clc, clear, close all;
addpath(genpath(pwd)); PlottingOptions;

%% Ground Truth profile
[REAL,wu,yp,Up,u2p,y,U,u2] = DNSprofileGT('../input/DNS/torroja_reth4500.mat',...
    'DNS_Torroja_Reth4500');

%- TBL fit parameters:
init.utau    =   REAL.utau;         % friction velocity
init.P       =   0.4;               % parameters for fit
init.y0      =   0.0000;            % initial wall position (estimate)
init.nu      =   REAL.nu;           % viscosity
init.delta   =   REAL.delta_99;     % delta_100

%% Extract evolution of quantities as we remove points from the profile
i2      = find(yp>=80,1); % Location of y+ = 80;
i0      = find(yp>=1,1);  % Location of y+ = 1;
Data.Y  = y;
Data.U  = U;
for i1 = i0:i2
    %     fprintf('-- First point y+(1) = %f \n',yp(i1)); % Prin an estimator
    indexProfile = i1:numel(U);
    [OutData,TBLstats,~,~] = ...
        fitData(Data,init,'','','',indexProfile);
    % Extract statistics:
    yp1(i1)      = yp(i1);
    H(i1)        = TBLstats.Nickels.H;
    RETAU(i1)    = TBLstats.Nickels.Retau;
    RETH(i1)     = TBLstats.Nickels.Retheta;
    DS(i1)       = TBLstats.Nickels.ds;
    THETA(i1)    = TBLstats.Nickels.theta;
    D99_N(i1)    = TBLstats.Nickels.d99;
    D99_C(i1)    = TBLstats.d99ch;
    UTAU(i1)     = OutData.utau;
    UINF(i1)     = TBLstats.Nickels.Uinf;
    
end
clearvars -except D99_C D99_N DS H REAL RETAU RETH THETA U y yp Up UTAU UINF yp1

%% Plotter
figure(1); clf;
labeltext = {'$u_\tau$','$Re_\tau$','$Re_\theta$','$U_\infty$','$\delta_{99}$','$H$','$\theta$','$\delta^*$'};
varsplot = {'UTAU','RETAU','RETH','UINF','D99_N','H','THETA','DS'};
for i = 1:numel(varsplot)
    subplot(2,4,i);
    eval(strcat('semilogx(yp1,', varsplot{i},'/',varsplot{i},'(4)', ",'.-');")); ylabel(labeltext{i});
    xlabel('First point in $y^+$');
    grid on; grid minor; hold on;
end

% save(fileout);