clear

theta0 = 0;
theta_dot = 7.29211585275553e-005;
JD_init = 2456296.25;
mu_sun = 132712440017.987; % km3/s2
solar_flux = 1357; %W/m2 @ 1 AU
A_m_ratio =  0.01; % m2/kg
Re = 6378.1363;

c = 299792.458; %k/s
mu_earth = 3.98600432896939e5; %km3/s2

EMO2EME_theta = 23.4393; %deg
EMO2EME = [1 0 0; 0 cosd(EMO2EME_theta) -sind(EMO2EME_theta); ...
    0 sind(EMO2EME_theta) cosd(EMO2EME_theta)];

au2km = 149597870.700; % km/AU

filename = 'Interplanetary_Obs.txt';
delimiterIn = ',';
headerlinesIn = 2;
y = importdata(filename,delimiterIn,headerlinesIn);
Obs=y.data;

ObsMassaged = zeros(length(Obs), 5);
ObsMassaged(:,2) = Obs(:,1);
for ii = 1:length(Obs)
    for jj = 1:3
        if ~isnan(Obs(ii,jj+1))
            ObsMassaged(ii,1) = jj;
            ObsMassaged(ii,3) = Obs(ii,jj+1);
            ObsMassaged(ii,4) = Obs(ii,jj+4);
            break;
        end
    end
end

% i. Canberra Station (DSS 34) at latitude = -35.398333?
% , longitude = 148.981944?
% and altitude = 0.691750 km
% ii. Madrid Station (DSS 65) at latitude = 40.427222?
% , longitude = 4.250556?
% and altitude = 0.834539 km
% 1
% iii. Goldstone Station (DSS 13) at latitude = 35.247164?
% , longitude = 243.205?
% and altitude = 1.07114904 km

site(1).name = 'Canberra Station (DSS 34)';
site(1).id = 1;
site(1).lat_lon_alt = [-35.398333; 148.981944;0.691750]; % geodetic, deg, km
site(1).r = lla2ecef(site(1).lat_lon_alt', 0, Re); % m
site(2).name = 'Madrid Station (DSS 65)';
site(2).id = 2;
site(2).lat_lon_alt = [40.427222; 4.250556; 0.834539]; % geodetic, deg, km
site(2).r = lla2ecef(site(2).lat_lon_alt', 0, Re); % m
site(3).name = 'Goldstone Station (DSS 13)';
site(3).id = 3;
site(3).lat_lon_alt = [35.247164; 243.205; 1.07114904]; % geodetic, deg, km
site(3).r = lla2ecef(site(3).lat_lon_alt', 0, Re); % m
num_sites = length(site);

filter_params;
propagator_opts.J2.use = 0;
propagator_opts.J3.use = 0;
propagator_opts.mu = mu_earth; %km3/s2
filter_opts.use_EKF = 0;
filter_opts.use_SNC = 0;

propagator_opts.Earth.Meeus.J200.L = [100.466449 35999.3728519 -0.00000568 0.0]; %deg
propagator_opts.Earth.Meeus.J200.a = 1.000001018*au2km; %km
propagator_opts.Earth.Meeus.J200.e = [0.01670862 -0.000042037 -0.0000001236 0.00000000004];
propagator_opts.Earth.Meeus.J200.i = [0 0.0130546 -0.00000931 -0.000000034]; % deg
propagator_opts.Earth.Meeus.J200.RAAN = [174.873174 -0.2410908 0.00004067 -0.000001327]; %deg
propagator_opts.Earth.Meeus.J200.Pi = [102.937348 0.3225557 0.00015026 0.000000478]; %deg
propagator_opts.epoch = JD_init;
propagator_opts.Sun.mu = mu_sun; % km3/s2
propagator_opts.solar_flux = solar_flux; %W/m2 @ 1 AU
propagator_opts.A_m_ratio =  A_m_ratio; % m2/kg
propagator_opts.c = c; %km/s
propagator_opts.au2km = au2km; %km
propagator_opts.EMO2EME = EMO2EME;

propagator_opts.OD.use = 1;
propagator_opts.OD.state_len = 7;
propagator_opts.OD.A_mat_handle = @A_state_rvCr;
propagator_opts.OD.A_params.mu = propagator_opts.mu;
propagator_opts.OD.A_params.Re = Re;
filter_opts.important_block = [7 7]; %rows, cols
propagator_opts.OD.A_params.important_block = filter_opts.important_block;
propagator_opts.OD.A_params.state_len = propagator_opts.OD.state_len;
STM_i = eye(propagator_opts.OD.state_len);

% Filter Options
filter_opts.propagator_opts = propagator_opts;

state_ap = [-274096790.0 ; %km
            -92859240.0 ;
            -40199490.0 ;
            32.67 ; %km/s
            -8.94 ;
            -3.88 ;
            1.2];

P = diag([100 100 100 0.1 0.1 0.1 0.1]);