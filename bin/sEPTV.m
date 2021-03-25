%--------------------------------------------------------------------------
%------------- Experimental Aerodynamics and Propulsion Lab ---------------
%-------------------- Group of Aerospace Engineering ----------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: Rodrigo Castellanos, Carlos Sanmiguel-Vila, Alejandro Güemes and
% Stefano Discetti.
%
% Description: averageprofile_DNS(yp,Up,Win,S,Res,wu,flag) is used to
% perform a synthetic EPTV processing on DNS data.
%--------------------------------------------------------------------------
function [ypivp,Upivp] = sEPTV(TBLp,Win,S,Res,wu,flag)
%--------------------------------------------------------------------------
% Inputs:
% - TBLp    ->  (CP) Input values for Chauhan profile
%           ->  (DNS) TBL profile in wall units
% - Win     ->  Window size [pix]
% - S       ->  Sensor size [pix]
% - Res     ->  Resolution [pix/m]
% - wu      ->  Wall Unit (nu/utau) [m]
% - flags   ->  Flags to activate sections of code (debug and map)
%--------------------------------------------------------------------------
%% Treat input data

%% Truncate and Average the TBL profile
%- Custom definition of criterion for profile truncation:
cutW    = 3/4; % Remove 3/4 of the window size for.
%- Define the wall-normal coordinate for EPTV case:
ypiv    = ceil(Win*cutW):1:S; % y [pix] Truncate the lower part of the profile.
ypivp   = ypiv./Res./wu;     % y+
w       = Win./Res./wu;       % w+ Window size
Retau   = ypivp(end)/1.3;     % Sensor is covering 1.3delta.
%- Extract Uinf:
switch flag.datin
    case 'DNS'
        Uinf = TBLp.Up(end);
    case 'CP'
        u_tau = TBLp.utau;
        de    = TBLp.delta0;
        P     = TBLp.P;
        nu    = TBLp.nu;
        yex  = (1:1:S)./Res;
        Uex  = analytic_profile_TBL(yex,u_tau,de,P,nu);
        Uinf = Uex(find(yex>=de,1)); Uex(yex>=de) = Uinf;
end

%- Compute the top-hat averaging (Synthetic EPTV):
Upivp = 0.*ypivp;
for i=1:length(ypivp)
    % To define the wall-normal coordinate vector, the first point is
    % chosen from the maximum of 1e-6 or the point of ypiv itself minus
    % half the window size, and the last point is the minimum between the
    % TBL thickness and the point of ypiv itself plus half the window size.
    % A custom number of 20 points is used to perform the average.
    yy      = linspace( max([1e-6 ypivp(i)-w/2]) , ...
        min([ypivp(i)+w/2,S./Res./wu]) , 20);
    %- Choose the input data type:
    switch flag.datin
        case 'DNS'
            yp = TBLp.yp;
            Up = TBLp.Up;
            Upivp(i) = mean( interp1(yp,Up,yy,'pchip',0) ); % Get the mean over the window size for U+
        case 'CP'
            UU    = analytic_profile_TBL(yy*wu,u_tau,de,P,nu); 
            UU(yy>=Retau)= Uinf; Upivp(i) = mean(UU)/u_tau; clear UU;
    end
end
%- Plot averaged ptofile and original data
if flag.debug
    figure(111);
    switch flag.datin
        case 'DNS'
            semilogx(yp,Up,'.')
            hold on
            semilogx(ypivp,Upivp,'s');
            legendtext = {'DNS data','Synthetic EPTV'};
        case 'CP'
            semilogx(yex/wu,Uex/u_tau,'.')
            hold on
            semilogx(ypivp,Upivp,'s');
            legendtext = {'Chauhan CP','Synthetic EPTV'};
    end
end

%% Fit the truncated, averaged profile and add disturbance on Y
%- Add an uncertainty on Y in the range of [-0.5,+0.5] pixels
if flag.noiseY
    ypivp       = ypivp+(-0.5+rand(1))./Res./wu;
    %- Confirm truncation after the addition of error
    idxStart    = find(ypivp>=ceil(w*cutW),1);
    ypivp       = ypivp(idxStart:end);
    Upivp       = Upivp(idxStart:end);
end

%- Fit on a common grid to compare with experiments
if flag.fit
    %- Perform fit of the U+ profile:
    % Use a vector Y+ with 90 points: 70 logarithmically distributed from
    % 0.1+ to 0.9Retau and 20 linearly distributed from 0.93Retau to
    % 1.3Retau.
    yf          = [logspace(-1,log10(0.9*Retau),70), ...
        linspace(Retau*0.93,Retau*1.3,20)];
    Ledge       = find(yf>=ypivp(1),1); % Find the first point in Y+
    yf          = yf(Ledge:end);        % Truncate fitting Y+
    Uf          = interp1(ypivp,Upivp,yf,'pchip');
    %- Update output:
    ypivp = yf; Upivp = Uf;
    
    %- Add fitted profile to figure
    if flag.debug
        figure(111);
        semilogx(ypivp,Upivp,'o');
        legendtext = [legendtext 'Fitted s-PIV'];
    end
end

% Add legend to figure
if flag.debug
    figure(111); legend(legendtext); xlabel('$Y^+$'); ylabel('$U^+$')
    pause;
end

end