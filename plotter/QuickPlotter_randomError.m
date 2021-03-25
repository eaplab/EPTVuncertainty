%--------------------------------------------------------------------------
%------------- Experimental Aerodynamics and Propulsion Lab ---------------
%-------------------- Group of Aerospace Engineering ----------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: Rodrigo Castellanos, Carlos Sanmiguel-Vila, Alejandro Güemes and
% Stefano Discetti.
%
% Quick plotter for the random error estimation as a function of the
% bin size in wall units.
%--------------------------------------------------------------------------

clear all; close all; clc;

variables   = {'DS','THETA','D99_N','UTAU','UINF','DYwu'};
variablesGT = {'dsGT','thetaGT','D99GT','UTAUGT','UINFGT','DYwuGT'};
titlelabel  = {'$\delta^*$','$\theta$','$\delta_{99}$','$u_\tau$','$U_\infty$','$\Delta y$'};
ref         = 1;

%% EXPERIMENTAL RESULTS
fileIn_Exp = '../output/EPTV_experiments_28000';
load(fileIn_Exp);
GT=load('../output/EPTV_experiments_28000');

figure(1); clf
for k = 1:numel(variables)
    subplot(2,3,k);  hold on
    % 50mm lens
    if k<6
        eval(strcat('plot(Win./WS1,1*(',variables{k},'-GT.',variables{k},'(ref))./GT.',...
            variables{k},'(ref)*100',",'ok','MarkerFaceColor','w','Markersize',4)"));
    else
        eval(strcat('plot(Win./WS1,',variables{k},'-GT.',variables{k},'(ref)',",'ok','MarkerFaceColor','w','Markersize',4)"));
    end
    % 100mm lens
    if k<6
        eval(strcat('plot(Win./WS2,1*(',variables{k},'100-GT.',variables{k},'100(ref))./GT.',...
            variables{k},'100(ref)*100',",'sr','MarkerFaceColor','w','Markersize',4)"));
    else
        eval(strcat('plot(Win./WS2,',variables{k},'100-GT.',variables{k},'100(ref)',",'sr','MarkerFaceColor','w','Markersize',4)"));
    end
    title(['Error on ',titlelabel{k}]); xlabel('Bin Size[$l^+$]'); ylabel('Error [\%]')
end

clearvars -except variables fileIn_Exp variablesGT

%% DNS
load('../output/DNSTorroja_ReTh4500-GT')
load('../output/DNS_Win1-1-32_S700_it2000_PP_profile')
WS1 = RetauGT*1.3/700;
for k = 1:numel(variablesGT)
    subplot(2,3,k);  hold on
    if k<6
        eval(strcat('errorbar(Win.*WS1,1*(med.',variables{k},'(1,:)-',variablesGT{k},')./',...
            variablesGT{k},'*100,','3*sigma.',variables{k},'(1,:)./',variablesGT{k},"*100,'--')"));
    else
        eval(strcat('errorbar(Win.*WS1,med.',variables{k},'(1,:)-',variablesGT{k},...
            ',3*sigma.',variables{k},'(1,:)',",'--')"));
    end
    
end

%% COMPOSITE PROFILE
load('..\output\CP_Win1-1-32_S700_it2000_PP_profile')
load('..\output\Nagib_Retau1400-GT.mat')
WS1 = RetauGT*1.3/700;
for k = 1:numel(variablesGT)
    subplot(2,3,k);  hold on
    if k<6
        eval(strcat('errorbar(Win.*WS1,1*(med.',variables{k},'(1,:)-',variablesGT{k},')./',...
            variablesGT{k},'*100,','3*sigma.',variables{k},'(1,:)./',variablesGT{k},"*100,'--')"));
    else
        eval(strcat('errorbar(Win.*WS1,med.',variables{k},'(1,:)-',variablesGT{k},...
            ',3*sigma.',variables{k},'(1,:)',",'--')"));
    end
    
end

%% PLOTTING ADJUSTMENTS

for k = 1:numel(variables)
    subplot(2,3,k);  hold on
    xlim([0 64]);
end
subplot(2,3,1)
legend({'EPTV 50mm','EPTV 100m', '$3\sigma$ on DNS median', '$3\sigma$ on Nagib median'})
subplot(2,3,6)
ylabel('Error $\Delta y^+$ [$l^*$]')