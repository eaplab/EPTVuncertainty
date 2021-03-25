function Ucomposite = analytic_profile_TBL(y,u_tau,delta,P,nu)
%--------------------------------------------------------------------------
% Kapil A Chauhan et al 2009 Fluid Dyn. Res. 41 021404
%--------------------------------------------------------------------------
% P : wake parameter
% delta: BL thickness (TBD by optimization)

k     = 0.384; % Von Karman constant
a     = -10.3061; % Parameter to adjust additive constant B of the inner function
l     = nu/u_tau; % Viscous length
yplus = y/l; %y+ (wall units)

% Auxiliar parameters:
alpha   = (-1/k-a)/2;
beta    = sqrt(-2*a*alpha-alpha^2);
R       = sqrt(alpha^2+beta^2);

% Inner profile in wall units:
U_plus_inner1 = 1/k*log(1-yplus/a)+...
    R^2/(a*(4*alpha-a))*((4*alpha+a)*log(-a/R*sqrt((yplus-alpha).^2+beta^2)./(yplus-a))+...
    alpha/beta*(4*alpha+5*a).*(atan((yplus-alpha)./beta)+atan(alpha/beta)));

% Monkewitz corrected for y+<50: ERROR
% U_plus_inner_corrected = U_plus_inner1 + exp(-((log(yplus/30))^2)/0.835)/2.47;
U_plus_inner_corrected = U_plus_inner1 + exp(-((log(yplus/30)).^2))/2.85;

% Wake frunction of expopnential type:
eta = y/delta; % outer variable
a2  = 132.8410; a3 = -166.2041; a4 = 71.9114; % empirical parameters
W1  = (1-exp(-0.25*(5*a2+6*a3+7*a4).*eta.^4+a2*eta.^5+a3*eta.^6+a4*eta.^7))./...
    (1-exp(-0.25*(a2+2*a3+3*a4)));
W   = W1.*(1-1/(2*P).*log(eta));

% Hence, the inner velocity profile and the outer profile which contain
% the log-law as a common part can be combined into a complete additive 
% composite meanvelocity profile valid from the wall to the edge of the TBL
Ucomposite_plus = U_plus_inner_corrected+2*P./k.*W;
Ucomposite      = u_tau .* Ucomposite_plus;