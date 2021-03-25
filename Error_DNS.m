%--------------------------------------------------------------------------
%------------- Experimental Aerodynamics and Propulsion Lab ---------------
%-------------------- Group of Aerospace Engineering ----------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: Rodrigo Castellanos, Carlos Sanmiguel-Vila, Alejandro Güemes and
% Stefano Discetti.
%
% Description: Estimation of random errors associated to the computation of
% TBL parameters. The baseline TBL profile is the DNS data from Torroja at
% Retheta = 4500.
%--------------------------------------------------------------------------

%% Ground Truth profile
[REAL,wu,yp,Up,u2p,y,U,u2] = DNSprofileGT('./input/DNS/torroja_reth4500.mat',...
    'DNS_Torroja_Reth4500');

%- TBL fit parameters:
init.utau    =   REAL.utau;         % friction velocity
init.P       =   0.4;               % parameters for fit
init.y0      =   0.0000;            % initial wall position (estimate)
init.nu      =   REAL.nu;           % viscosity
init.delta   =   REAL.delta_99;     % delta_100

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
UINFGT  = TBLstats.Nickels.Uinf ;   % Freestream Velocity
UTAUGT  = OutData.utau;             % Viscous velocity
DYGT    = nanmean(OutData.Ym - Data.Y);% Correction of wall position [m]
DYwuGT  = DYGT/(init.nu/OutData.utau); % Correction of wall position in wall units
clear OutData TBLstats Data;

%% Parametric Study
% Allocate memory: generate matrices of size len(S) x len(Win).
UTAU    = zeros(length(S),length(Win),numiter); % Friction velocity
HH      = 0.*UTAU; % Shape factor
THETA   = 0.*UTAU; % Momentum thickness
RETAU   = 0.*UTAU; % Friction Re
RETH    = 0.*UTAU; % Momentum thickness based Re
DS      = 0.*UTAU; % Displacement thickness
D99_N   = 0.*UTAU; % TBL thickness (delta_99) based on Nickels
D99_C   = 0.*UTAU; % TBL thickness (delta_99) based on Chauhan
UINF    = 0.*UTAU; % Freestream velocity
DY      = 0.*UTAU; % Correction of wall position [m]
DYwu    = 0.*UTAU; % Correction of wall position in wall units

% S = 1.3*RetauGT;

cont = 1;
for jj=1:length(S)
    for kk=1:length(Win)
        fprintf('-- S = %d, W = %d -- %d of %d -- \n',S(jj), Win(kk),cont,numel(Win)*numel(S));
        OutData = cell(1,numiter); TBLstats = cell(1,numiter); Data = cell(1,numiter); iwrong =[];
        Res = S(jj)/REAL.delta_99/1.3; % Select our sensor to see 1.3d99 of the profile.
        TBLp.yp = yp; TBLp.Up = Up; TBLp.u2p = u2p; TBLp.wu = wu;
        parfor i=1:numiter % Iterations (to average noise sensitivity of the fit)
            %- Perform synthetic EPTV
            [ypiv,Upiv] = sEPTV(TBLp,Win(kk),S(jj),Res,wu,flag);
            %- Disturbance on profile:
            if flag.noiseU
                Upiv = noiseEPTV(ypiv,Upiv,TBLp,Win(kk),Np,flag);
            end
            %- Input to the TBL fit:
            indexProfile    = 1:numel(Upiv); % Use the whole profile
            Data{i}.Y       = ypiv(:).*wu;
            Data{i}.U       = Upiv(:).*init.utau;
            try
                [OutData{i},TBLstats{i},~,~] = fitData(Data{i},init,'','','',indexProfile);
                HH(jj,kk,i)     = TBLstats{i}.Nickels.H;
                RETAU(jj,kk,i)  = TBLstats{i}.Nickels.Retau;
                RETH(jj,kk,i)   = TBLstats{i}.Nickels.Retheta;
                DS(jj,kk,i)     = TBLstats{i}.Nickels.ds;
                THETA(jj,kk,i)  = TBLstats{i}.Nickels.theta;
                D99_N(jj,kk,i)  = TBLstats{i}.Nickels.d99;
                D99_C(jj,kk,i)  = TBLstats{i}.d99ch;
                UTAU(jj,kk,i)   = OutData{i}.utau;
                UINF(jj,kk,i)   = TBLstats{i}.Nickels.Uinf;
                DY(jj,kk,i)     = nanmean(OutData{i}.Ym - Data{i}.Y);
                DYwu(jj,kk,i)   = DY(jj,kk,i)/(init.nu/OutData{i}.utau);
            catch
                HH(jj,kk,i)     = nan;
                RETAU(jj,kk,i)  = nan;
                RETH(jj,kk,i)   = nan;
                DS(jj,kk,i)     = nan;
                THETA(jj,kk,i)  = nan;
                D99_N(jj,kk,i)  = nan;
                D99_C(jj,kk,i)  = nan;
                UTAU(jj,kk,i)   = nan;
                UINF(jj,kk,i)   = nan;
                DY(jj,kk,i)     = nan;
                DYwu(jj,kk,i)   = nan;
            end
        end
        clear OutData TBLstats Data iwrong
        cont = cont+1; clc
    end
end

clear cont time jj kk i TBLstats OutData Diag indexProfile
save(fileout);

%% Post-process data:
if and(numel(Win)>1,numel(S)>1), CASE = 'map';
else, CASE = 'profile'; end

PostProc(fileout,CASE);

rmpath(genpath(pwd));