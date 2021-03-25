%--------------------------------------------------------------------------
%------------- Experimental Aerodynamics and Propulsion Lab ---------------
%-------------------- Group of Aerospace Engineering ----------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: Rodrigo Castellanos, Carlos Sanmiguel-Vila, Alejandro Güemes and
% Stefano Discetti.
%
%--------------------------------------------------------------------------
clc, clear, %close all;
addpath(genpath(pwd)); PlottingOptions;

%% USER INPUTS
flag.datin  = 'DNS';    % DNS or CP (Composite Profile)
flag.debug  = 0;        % Plot TBL profile in debugging process
flag.fit    = 1;        % Fit the TBL profile after truncation (Analysis is performed on a common grid)
flag.noiseU = 1;        % Add noise to U (sigma_U)
flag.noiseY = 1;        % Add noise to Y (+/-0.5 pix)

Win         = 1:1:32;   % bin size in pix
S           = 700;      % sensor size in pix
numiter     = 2e3;      % Number of iterations of the process (uncertainty analysis)

Nvpp        = 8.75e-4;  % Number of vectors per pixel
Wx          = 200;      % [pix] Width of the PIV window
Ns          = 2e3;      % Number of snapshot;
Np          = Ns*Wx*Nvpp; % Total number of particles

%% RUN
if and(numel(Win)>1,numel(S)>1)
    fileout     = strcat('.\output\',flag.datin,'_Win', ...
    num2str(Win(1)),'-',num2str(mean(diff(Win))),'-',num2str(Win(end)),...
    '_S',num2str(S(1)),'-',num2str(mean(diff(S))),'-',num2str(S(end)),...
    '_it', num2str(numiter));
else
    fileout     = strcat('.\output\',flag.datin,'_Win', ...
    num2str(Win(1)),'-',num2str(mean(diff(Win))),'-',num2str(Win(end)),...
    '_S',num2str(S),'_it', num2str(numiter));
end

run(['Error_' flag.datin]);
clear