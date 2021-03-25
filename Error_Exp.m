%--------------------------------------------------------------------------
%------------- Experimental Aerodynamics and Propulsion Lab ---------------
%-------------------- Group of Aerospace Engineering ----------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: Rodrigo Castellanos, Carlos Sanmiguel-Vila, Alejandro Güemes and
% Stefano Discetti.
%
% Description: Estimation of random TBL parameters for experimental data.
% The baseline TBL profile is the experimental data processed with EPTV
% Retau = 1380.
%--------------------------------------------------------------------------

%% Include paths of functions
clc, clear, close all;
addpath(genpath(pwd)); PlottingOptions;

Nimg = 28000;
%- User inputs:
Win         = 3:32; % window in pix
S           = 700;  % sensor size in pix
numiter     = 1;  % Number of iterations of the process (uncertainty analysis)
fileout     = strcat('./output/EPTV_experiments_',num2str(Nimg));

%- TBL fit parameters:
init.utau    =   0.04;               % friction velocity
init.P       =   0.4;               % parameters for fit
init.y0      =   0.0030;            % initial wall position (estimate)
init.nu      =   8.756778122657612e-07;           % viscosity
init.delta   =   0.03;              % delta_100
init.Re_tent =   1300;              % tentative value for friction Reynolds number

%% EPTV Processing Lens 50 mm

%- Allocate memory: generate matrices of size len(S) x len(Win).
UTAU    = zeros(length(S),length(Win)); % Friction velocity
HH      = 0.*UTAU; % Shape factor
THETA   = 0.*UTAU; % Momentum thickness
RETAU   = 0.*UTAU; % Friction Re
RETH    = 0.*UTAU; % Momentum thickness based Re
DS      = 0.*UTAU; % Displacement thickness
D99_N   = 0.*UTAU; % TBL thickness (delta_99)
D99_C   = 0.*UTAU; % TBL thickness (delta_99)
UINF    = 0.*UTAU; % Freestream velocity
DY      = 0.*UTAU; % Wall offset in physical units
DYwu    = 0.*UTAU; % Wall offset in wall units
dt  = 6.4e-4;
Res = 25179;

cont = 1; time = 50;
for jj=1:length(S)
    for kk=1:length(Win), tic % Start Clock
        fprintf('-- %d of %d, ETA: %d min -- \n',cont,numel(Win)*numel(S),(numel(Win)*numel(S)-cont)*time/60); % Prin an estimator
        %- Load data:
        filename = sprintf('./input/EPTV/EPTV_Lens50mm_Win200x%d_Nimg%d.mat', Win(kk),Nimg);
        disp(filename); load(filename);
        %- Prepare vectors:
        ypiv = (max(Mat(:,1,2))-mean(Mat(:,:,2),2));
        Upiv = mean(Mat(:,:,3),2);
        NV(jj,kk)=mean(mean(Mat(:,:,8)));
        [ypiv,Upiv] = preprocEPTVprofile(ypiv,Upiv,Win(kk),Res,dt);
        % Perform FIT:
        indexProfile    = 1:numel(Upiv);
        Data.Y          = ypiv(:);
        Data.U          = Upiv(:);
        [OutData,TBLstats,Diag,indexProfile] = ...
            fitData(Data,init,'','','',indexProfile);
        u2 = mean(Mat(indexProfile,:,5),2)./Res./dt;
        % Extract Stats:
        HH(jj,kk)       = TBLstats.Nickels.H;
        RETAU(jj,kk)    = TBLstats.Nickels.Retau;
        RETH(jj,kk)     = TBLstats.Nickels.Retheta;
        DS(jj,kk)       = TBLstats.Nickels.ds;
        THETA(jj,kk)    = TBLstats.Nickels.theta;
        UTAU(jj,kk)     = OutData.utau;
        D99_N(jj,kk)    = TBLstats.Nickels.d99;
        D99_C(jj,kk)    = TBLstats.d99ch;
        UINF(jj,kk)     = TBLstats.Nickels.Uinf;
        DY(jj,kk)       = nanmean(OutData.Ym - Data.Y);
        DYwu(jj,kk)     = DY(jj,kk)/(init.nu/OutData.utau);
        cont = cont+1; time = toc; clc
    end
end

WS1 = Res*D99_N(1)/RETAU(1);

%% EPTV Processing Lens 100 mm
% Allocate memory: generate matrices of size len(S) x len(Win).
UTAU100    = zeros(length(S),length(Win)); % Friction velocity
HH100      = 0.*UTAU100; % Shape factor
THETA100   = 0.*UTAU100; % Momentum thickness
RETAU100   = 0.*UTAU100; % Friction Re
RETH100    = 0.*UTAU100; % Momentum thickness based Re
DS100      = 0.*UTAU100; % Displacement thickness
D99_N100   = 0.*UTAU100; % TBL thickness (delta_99)
D99_C100   = 0.*UTAU100; % TBL thickness (delta_99)
UINF100    = 0.*UTAU100; % Freestream velocity
DY100      = 0.*UTAU; % Wall offset in physical units
DYwu100    = 0.*UTAU; % Wall offset in wall units

dt  = 2.4e-4;
Res = 65130; 

cont = 1; time = 50;
for jj=1:length(S)
    for kk=1:length(Win), tic % Start Clock
        fprintf('-- %d of %d, ETA: %d min -- \n',cont,numel(Win)*numel(S),(numel(Win)*numel(S)-cont)*time/60); % Prin an estimator
        %- Load data:
        filename = sprintf('./input/EPTV/EPTV_Lens100mm_Win200x%d_Nimg%d.mat', Win(kk),Nimg);
        disp(filename); load(filename);
        %- Prepare vectors:
        ypiv = (max(Mat(:,1,2))-mean(Mat(:,:,2),2));
        Upiv = mean(Mat(:,:,3),2);
        NV100(jj,kk)=mean(mean(Mat(:,:,8)));
        [ypiv,Upiv] = preprocEPTVprofile(ypiv,Upiv,Win(kk),Res,dt);
        % Perform FIT:
        indexProfile    = 1:numel(Upiv);
        Data.Y          = ypiv(:);
        Data.U          = Upiv(:);
        [OutData,TBLstats,Diag,indexProfile] = ...
            fitData(Data,init,'','','',indexProfile);
        u2 = mean(Mat(indexProfile,:,5),2)./Res./dt;
        % Extract Stats:
        HH100(jj,kk)       = TBLstats.Nickels.H;
        RETAU100(jj,kk)    = TBLstats.Nickels.Retau;
        RETH100(jj,kk)     = TBLstats.Nickels.Retheta;
        DS100(jj,kk)       = TBLstats.Nickels.ds;
        THETA100(jj,kk)    = TBLstats.Nickels.theta;
        UTAU100(jj,kk)     = OutData.utau;
        D99_N100(jj,kk)    = TBLstats.Nickels.d99;
        D99_C100(jj,kk)    = TBLstats.d99ch;
        UINF100(jj,kk)     = TBLstats.Nickels.Uinf;
        DY100(jj,kk)       = nanmean(OutData.Ym - Data.Y);
        DYwu100(jj,kk)     = DY100(jj,kk)/(init.nu/OutData.utau);
        
        cont = cont+1; time = toc; clc
    end
end

WS2 = Res*D99_N100(1)/RETAU100(1);

save(fileout);