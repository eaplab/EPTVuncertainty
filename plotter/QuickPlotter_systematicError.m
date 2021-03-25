%--------------------------------------------------------------------------
%------------- Experimental Aerodynamics and Propulsion Lab ---------------
%-------------------- Group of Aerospace Engineering ----------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: Rodrigo Castellanos, Carlos Sanmiguel-Vila, Alejandro Güemes and
% Stefano Discetti.
%
% Quick plotter for the systematic error estimation as a function of the
% bin size in wall units.
%--------------------------------------------------------------------------
clear; close all; clc;

datain = {'DNS','CP'};
variables = {'DS','THETA','D99_N','UTAU','UINF','DYwu'};

for j = 1:numel(datain)
    filein = ['..\output\' datain{j} '_Win1-3-199_S1400_it50'];
    GT = load(filein,'dsGT','thetaGT','D99GT','UTAUGT','UINFGT','DYwuGT');
    load([filein '_PP_profile']);
    for i = 1:numel(variables)
        % Remove outliers from convergence process:
        eval(strcat('med.',variables{i}, ' = filloutliers(', 'med.', variables{i}, ",'spline','movmedian',25);"));
        eval(strcat('med.',variables{i}, ' = filloutliers(', 'med.', variables{i}, ",'pchip','movmedian',20);"));
    end
    
    figure(100)
    subplot(2,3,1), plot(Win,(med.DS-GT.dsGT)/GT.dsGT*100,'-'); hold on; xlabel('$Bin^+$'); ylabel('Error $\delta^*$ (\%)');
    subplot(2,3,3), plot(Win,(med.UTAU-GT.UTAUGT)/GT.UTAUGT*100,'-'); hold on; xlabel('$Bin^+$'); ylabel('Error $u_\tau$ (\%)');
    subplot(2,3,2), plot(Win,(med.THETA-GT.thetaGT)/GT.thetaGT*100,'-'); hold on; xlabel('$Bin^+$'); ylabel('Error $\theta$ (\%)');
    subplot(2,3,4), plot(Win,(med.UINF-GT.UINFGT)/GT.UINFGT*100,'-'); hold on; xlabel('$Bin^+$'); ylabel('Error $U_e$ (\%)');
    subplot(2,3,5), plot(Win,(med.D99_N-GT.D99GT)/GT.D99GT*100,'-'); hold on; xlabel('$Bin^+$'); ylabel('Error $\delta_{99}$ (\%)');
    subplot(2,3,6), plot(Win,(med.DYwu)); hold on; xlabel('$Bin^+$'); ylabel('$\Delta y^+$');
end
legend(datain)