%--------------------------------------------------------------------------
%------------- Experimental Aerodynamics and Propulsion Lab ---------------
%-------------------- Group of Aerospace Engineering ----------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: Rodrigo Castellanos, Carlos Sanmiguel-Vila, Alejandro Güemes and
% Stefano Discetti.
%
% Description: Estimation of random errors associated to the computation of
% TBL parameters. The baseline TBL profile is the Composite profile
% proposed by Chauhan (2009).
%--------------------------------------------------------------------------

%% TBL fit parameters:
init.utau    =   0.7;               % friction velocity
init.P       =   0.4;               % parameters for fit
init.y0      =   0.0000;            % initial wall position (estimate)
init.nu      =   1.55e-5;           % viscosity
init.delta0  =   0.042;             % delta_100
init.Re_tent =   1400;              % tentative value for friction Reynolds number
wu           = init.nu/init.utau;   % Wall Unit;

%% Ground Truth profile
%- Obtain profile from Chauhan-Nagib fit:
y          = [logspace(-1,log10(0.9*init.Re_tent),70), ...
        linspace(init.Re_tent*0.93,init.Re_tent*1.3,20)]*wu;
U_nagib     = analytic_profile_TBL(y,init.utau,init.delta0,init.P,init.nu);
%- Add a wake to the profile up to 1.3*d99:
y           = [y linspace(1.01*init.delta0,1.3*init.delta0,20)];
U_nagib     = [U_nagib U_nagib(end)*ones(1,20)];
init.delta  = y(end)/1.3;
Uinf        = U_nagib(end);
%- Wall units:
yp          = y.*init.utau/init.nu;
Up          = U_nagib./init.utau;
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
UINFGT  = TBLstats.Nickels.Uinf ;   % Freestream Velocity
UTAUGT  = OutData.utau;             % Friction velocity
DYGT = nanmean(OutData.Ym - Data.Y);% Correction of wall position [m]
DYwuGT = DYGT/(init.nu/OutData.utau); % Correction of wall position in wall units
clear OutData TBLstats Data;

%% Parametric study
% Allocate memory: generate matrices of size len(S) x len(Win).
UTAU    = zeros(length(S),length(Win)); % Friction velocity
HH      = 0.*UTAU; % Shape factor
THETA   = 0.*UTAU; % Momentum thickness
RETAU   = 0.*UTAU; % Friction Re
RETH    = 0.*UTAU; % Momentum thickness based Re
DS      = 0.*UTAU; % Displacement thickness
D99_N   = 0.*UTAU; % TBL thickness (delta_99)
D99_C   = 0.*UTAU; % TBL thickness (delta_99)
UINF    = 0.*UTAU; % Freestream velocity
DY      = 0.*UTAU; % Correction of wall position [m]
DYwu    = 0.*UTAU; % Correction of wall position in wall units

% S = 1.3*RetauGT;

cont = 1; % counter on the number of interactions
for jj=1:length(S)
    for kk=1:length(Win)
        fprintf('-- S = %d, W = %d -- %d of %d -- \n',S(jj), Win(kk),cont,numel(Win)*numel(S));
        OutData = cell(1,numiter); TBLstats = cell(1,numiter); Data = cell(1,numiter); iwrong =[];
        Res = S(jj)/init.delta0/1.3; % Select our sensor to see 1.3d99 of the profile.
        parfor i=1:numiter
            %- Perform synthetic EPTV
            [ypivp,Upivp] = sEPTV(init,Win(kk),S(jj),Res,wu,flag);
            ypiv  = ypivp*wu; Upiv = Upivp*init.utau;
            %- Disturbance on profile
            if flag.noiseU
                Upiv = noiseEPTV(ypiv,Upiv,init,Win(kk),Np,flag);
            end
            %- Input to the TBL fit:
            indexProfile    = 1:numel(Upiv); % Use the whole profile
            Data{i}.Y       = ypiv(:);
            Data{i}.U       = Upiv(:);
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
                DYwu(jj,kk,i) = DY(jj,kk,i)/(init.nu/OutData{i}.utau);
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