function [REAL,wu,yp,Up,u2p,y,U,u2,v2p, uvp] = DNSprofileGT(path,name)

load(path);

switch name
    case 'DNS_Torroja_Reth4500'
        % Values extracted from TXT file (Torroja database)
        REAL.utau     = 0.0384;
        REAL.Re_theta = 4500.0000;
        REAL.Re_tau   = 1437.0660;
        REAL.delta_99 = 10.7041;
        REAL.deltas   = 1.7658;
        REAL.theta    = 1.2836;
        REAL.nu       = REAL.utau*REAL.delta_99/REAL.Re_tau;
        wu            = REAL.nu/REAL.utau; % Definition of wall unit
        % TBL profiles:
        yp            = Torr(:,2);
        Up            = Torr(:,9);
        u2p           = Torr(:,3);
        v2p            = Torr(:,4);
        uvp           = Torr(:,6);
        U             = Up.*REAL.utau;
        y             = yp.*wu;
        u2            = u2p.*REAL.utau;
        
end