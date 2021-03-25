%--------------------------------------------------------------------------
%------------- Experimental Aerodynamics and Propulsion Lab ---------------
%-------------------- Group of Aerospace Engineering ----------------------
%------------------- Universidad Carlos III de Madrid ---------------------
%--------------------------------------------------------------------------
% Authors: Rodrigo Castellanos, Carlos Sanmiguel-Vila, Alejandro Güemes and
% Stefano Discetti.
%
% Description: Addition of random error to the U profile
%--------------------------------------------------------------------------

function [Upiv] = noiseEPTV(ypiv,Upiv,extra,Win,Np,flag)

switch flag.datin
    case 'DNS'
        %- Fit u2p profile in EPTV grid:
        u2ppiv = interp1(extra.yp,extra.u2p,ypiv,'pchip',0);
        %- Noise addition: (u'+0.1)/sqrt(2000)*rand. (Asume we have Np*Wi particles in each window)
        Upiv   = Upiv+((u2ppiv+0.1).*randn(size(Upiv)))/sqrt(Win*Np);
    case 'CP'
        %- Consider a flat profile of u' for y<0.9delta: u' =2*utau;
        u2synthetic = (2)*extra.utau*ones(size(ypiv));
        % Consider a flat profile of u' for y>0.9delta: u' =0.5*utau;
        u2synthetic(ypiv >= 0.9*extra.delta0) = (0.5)*extra.utau;
        %- Noise addition: (u'+0.1)/sqrt(350*Wi)*rand. (Asume we have Np*Wi particles in each window)
        Upiv  = Upiv+((u2synthetic+0.1).*randn(size(Upiv)))/sqrt(Win*Np);
end

if flag.debug
    figure(111);
    ll = legend();
    legendtext = [ ll.String 'Noise' ];
    switch flag.datin
        case 'DNS'
            semilogx(ypiv,Upiv,'v');
        case 'CP'
            semilogx(ypiv/(extra.nu/extra.utau),Upiv/extra.utau,'v');
    end
    legend(legendtext)
end

end