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
function PostProc(filein,CASE)
warning off;
load(filein);
fileout = strcat(filein,'_PP_',CASE);
variables = {'RETAU','HH','DS','THETA','D99_N','D99_C','RETH','UTAU','UINF','DY','DYwu'};

switch CASE
    
    case 'profile'
        %- Perform a Gaussin fit on data:
        for k =1:numel(S)
            for w = 1:numel(Win)
                for i = 1:numel(variables)
                    eval(['s(:,:) = ' variables{i} '(k,w,:);']);
                    s(isnan(s)) = [];
                    %- Histogram of data: take +/-3 sigma region
                    smed = nanmedian(s); sstd = nanstd(s);
                    if numel(s)>500
                        s(s>(smed+3*sstd))=[];
                        s(s<(smed-3*sstd))=[];
                        [y,x]   = hist(s,linspace(smed-3*sstd,smed+3*sstd,numel(s)/30));
                        ydum    = y(x<(smed+2*sstd)& x>(smed-2*sstd));
                        xdum    = x(x<(smed+2*sstd)& x>(smed-2*sstd));
                        %- Perform a Gaussin fit:
                        options = optimset('Display','off','TolFun',1e-6);
                        lam     = fminsearch(@gaussfit,[sstd smed 1],options,xdum,ydum);
                        mus     = lam(2); ss    = lam(1);
                        %- Ensure no imaginary numbers
                        if imag(ss)~=0, ss = NaN; end
                    else
                        mus     = smed;
                        ss      = sstd;
                    end
                    
                    %- Generate final outcome
                    eval(['sigma.' variables{i} '(k,w)= ss;']);
                    eval(['mu.' variables{i} '(k,w)= mus;']);
                    eval(['med.' variables{i} '(k,w)= smed;']);
                    clear s ss mus smed sstd
                end
            end
        end
        
    case 'map'
        for  i = 1:numel(variables)
            eval(strcat(variables{i}, ' = filloutliers(', variables{i}, ",'spline','movmedian',25);"));
            eval(strcat(variables{i}, ' = filloutliers(', variables{i}, ",'pchip','movmedian',20);"));
            eval(strcat(variables{i}, ' = smooth3(', variables{i}, ",'gaussian',[5,5,3],3);"));
            eval(['mu.' variables{i} '= nanmean(' variables{i} ',3);']);
            eval(['med.' variables{i} '= nanmedian(' variables{i} ',3);']);
            eval(['sigma.' variables{i} '= nanstd(' variables{i} ',3);']);
        end
end

%% SAVE
clearvars -except med sigma mu Win S fileout
save(fileout,'med', 'sigma', 'mu', 'Win', 'S');
end

function err = gaussfit(lam,x,y)
f   = 1./(lam(3)*sqrt(2*pi)).*exp(-(x-lam(2)).^2./(2*lam(1)^2));
err = sum((f-y).^2);
end