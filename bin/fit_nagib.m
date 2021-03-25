function x = fit_nagib(y,U,nu,utau,delta,P,DebugFit,flag)
%--------------------------------------------------------------------------
% version by Rodrigo Castellanos - 24/11/2020
% This codes performs a Chauhan-Monkewitz-Nagib fit on the measured
% profile. It is mainly done for PIV/EPTV data and it has two main blocks:
% - Outer fit: it performs an outer fit of the data in order to get a rough
% profileof the whole BL.
% - Inner fit: it takes as an initial guess the previous fit (or any other
% guess provided by the user) to perform the data fit in the inner region
% of the BL, which is the critical region to compute the statistics.
%--------------------------------------------------------------------------

lstar   = nu/utau;  % BL length scale
yp      = y/lstar;  % Wall cordinates in wall units

if strcmp(flag,'inner')
    % Find the inner part of the BL: select as many points as possible
    % below y+ = 15. If it is not possible to find at least 8 points in
    % that range, then keep adding points untill having 8 points.
    yup=[]; cont=0;
    while numel(yup)<10 || yp(yup(end))<=50
        ypmas = 1+1*cont; % y+ should be within 30 and 50 for ZPG
        yup = find(yp<ypmas & yp>1);
        cont = cont+1;
    end
    % Sort the mean velocity and the variance vectors:
    [y,ysort]   = sort(y);
    U           = U(ysort);
    %- Remove spurious points close to wall
    y1             = y(1:yup(end));
    U1             = U(1:yup(end));
    %- Initial guess
    y0  = 0;
    x0  = [utau, delta, P, y0];
    %- Fit Nagib inner part:
    [x,y2] = fit_nagib_inner(x0,y1,U1,nu,DebugFit);
    x(4) = mean(y2-y1);
    
    
elseif strcmp(flag,'outer')
    % Sort the mean velocity and the variance vectors:
    %     y           = y-min(y);
    [y,ysort]   = sort(y);
    U           = U(ysort);
    % Get the estimated index at which delta99 is reached (U = 0.99Uinf);
    i99 = find(y>=delta,1);
    if isempty(i99)
        i99=find(U>0.99*max(U),1);
    end
    % Remove spurious points close to wall
    y1              = y(1:i99+1);
    U1              = U(1:i99+1);
    
    %- Optimization process of Chauhan fit curve:
    options = optimset('TolX',1e-9,'TolFun',1e-9,'MaxFunEvals',1000);
    % Initial guess
    y0  = 0;
    x0  = [utau, delta, P, y0];
    % First optimization with bounds to limit feasible space:
    x   = fminsearchbnd(@(x) min_nagib(x,y1,U1,nu,DebugFit),...
        x0,0.8*x0,1.2*x0);
    x   = fminsearch(@(x) min_nagib(x,y1,U1,nu,DebugFit),...
        x0,options);
    
end

%--- Inner fit:
function [x,y1] = fit_nagib_inner(x,y1,U1,nu,DebugFit)
%- Optimization process of Chauhan fit curve:
options = optimset('TolX',1e-9,'TolFun',1e-9,'MaxFunEvals',1000);
% First optimization with bounds to limit feasible space:
x   = fminsearchbnd(@(x) min_nagib(x,y1,U1,nu,DebugFit),...
    x,[0 0 0 -1e-4],[2*x(1) 2*x(2) 2*x(3) 1e-4]);
% Second optimization withput bounds to explore other local minima
x   = fminsearch(@(x) min_nagib(x,y1,U1,nu,DebugFit),...
    x,options);
% readjustment of wall-normal component
y1 = y1+x(4); x(4) = 0;
% Third optimization with bounds to limit feasible space:
x   = fminsearchbnd(@(x) min_nagib(x,y1,U1,nu,DebugFit),...
    x,[0.5*x(1) 0.5*x(2) 0.5*x(3) -1e-4],[1.5*x(1) 1.5*x(2) 1.5*x(3) 1e-4]);
% Fouth optimization withput bounds to explore other local minima
x   = fminsearch(@(x) min_nagib(x,y1,U1,nu,DebugFit),...
    x,options);
% readjustment of wall-normal component
y1 = y1+x(4); x(4) = 0;

%--- Minimize fitting problem:
function f = min_nagib(X,y,U,nu,DebugFit)
warning off
f = 0; U_current = zeros(size(y));
% Compute analytical profile of the TBL at each wall-normal position:
for i=1:length(y)
    yx           = y(i)+X(4);
    U_nagib      = analytic_profile_TBL(yx,X(1),X(2),X(3),nu);
    f            = f+(U(i)-U_nagib)^2;
    U_current(i) = U_nagib;
end
% Debug mode: show optimization process
if strcmp(DebugFit,'YES')
    figure(10),clf
    semilogx(y,U,'ok')
    hold on
    plot(y,U_current,'-r')
end