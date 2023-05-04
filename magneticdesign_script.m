Vin = 18; % 12-18 V
Vout = 48; % V, fixed
Pout = 48; % W, fixed
n = 3; % N1:N2, 
fs = 50e3; % switching frequency
Perm = [2300 2300 1500 90 90 60]; % relative permittivity, same order with the excel sheet on github
AL = 1e-9*[4100 5200 4700 281 146 300]; % H/turn^2, same order with the excel sheet on github
Aw = 1e-6*[144.3 219.04 345.95 276 151 537]; % m^2
Le = 1e-3*[77 97 124 98.4 69.4 147]; % m
Ae = 1e-6*[149 233 353 237 84 540]; % m^2, crossection of the core
mu0 = 4*pi*10^-7; % permittivity of the air

Iout = Pout/Vout;
Iin = Pout/Vin;
D = Vout/(Vout+n*Vin); % Duty cycle
% For CCM, DeltaIL<Iin
Lm_min = Vin*D*fs^-1/Iin;
DeltaIL = 1.134;
Lm = 149.2 *1e-6;

Ilm_avg = Iin/D;
Imax = 6.9+DeltaIL/2;
Ipri_rms = Imax*sqrt(D);
Isec_rms = Imax*sqrt(1-D);
CopperCross = 0.259*10^-6;% available in the laboratory, m^2

for i = 1:length(Perm)
    Npri(i) = sqrt(Lm/(AL(i)));
    Npri(i) = ceil(Npri(i));
    Acu(i) = 23*Npri(i)*CopperCross; % Total copper area
    kf(i) = Acu(i)/Aw(i); % fill factor
    reluc(i) = Le(i)/(mu0*Perm(i)*Ae(i)); % reluctan of the core without gap
    phi(i) = Npri(i)*Imax/reluc(i); % maximum flux in the core
    B(i) = phi(i)/Ae(i); % maximum flux density
end