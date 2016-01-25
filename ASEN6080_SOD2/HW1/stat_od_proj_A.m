function A = stat_od_proj_A(state, consts)
%stat_od_proj_A Calculate A matrix for Stat OD project
fcnPrintQueue(mfilename('fullpath')) % Add this code to code app 

% Init A, set up local vars
A = zeros(consts.state_len);
x = state(1);
y = state(2);
z = state(3);
xdot = state(4);
ydot = state(5);
zdot = state(6);
mu = state(7);
J2 = state(8);
Cd = 0;

Re = consts.Re;
area = consts.area;
rho = consts.rho;
theta_dot = consts.theta_dot;
m = consts.m;

% vars to reduce computations
x2 = x*x;
y2 = y*y;
z2 = z*z;
r = sqrt(x2+y2+z2);
sqrt_r = sqrt(r);
v = sqrt(xdot*xdot+ydot*ydot+zdot*zdot);
rel_wind_x = (xdot + theta_dot*y);
rel_wind_y = (ydot - theta_dot*x);
zdot2 = zdot*zdot;
rel_wind_mag = sqrt(rel_wind_x*rel_wind_x + rel_wind_y*rel_wind_y + zdot2);
Re2 = Re*Re;

rho0 = 3.614e-13; %kg/m3
r0 = 700000+6378136.3; %km
H = 88667.0; %km

% Only a few elements are populated
A(1,4) = 1;
A(2,5) = 1;
A(3,6) = 1;

A(4,1) = (3*mu*x^2)/(r*r*r*r*r) - ...
    mu/(r*r*r) + ...
    (3*J2*Re2*mu*((5*z2)/(r*r) - 1))/(2*(r)^(5)) - ...
    (15*J2*Re2*mu*x2*z2)/(r)^(9) - ...
    (15*J2*Re2*mu*x2*((5*z2)/(r*r) - 1))/(2*(r)^(2)) + ...
    (Cd*area*theta_dot*rho*rel_wind_x*rel_wind_y)/(2*m*rel_wind_mag) + ...
    (Cd*area*x*rho*(xdot + theta_dot*y)*rel_wind_mag)/(2*H*m*r);
% A1 = [                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      0,                                                                                                                                                                                                                                                                                                         1,                                                                                                                                                                                                                                                                                                         0,                                                                                                                                                                                                                                                                  0,                                                                                                     0,                                                                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
% A2 = [                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      0,                                                                                                                                                                                                                                                                                                         0,                                                                                                                                                                                                                                                                                                         1,                                                                                                                                                                                                                                                                  0,                                                                                                     0,                                                                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
% A3 = [                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      0,                                                                                                                                                                                                                                                                                                         0,                                                                                                                                                                                                                                                                                                         0,                                                                                                                                                                                                                                                                  1,                                                                                                     0,                                                                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
% A4 = [            (3*mu*x^2)/(x^2 + y^2 + z^2)^(5/2) - mu/(x^2 + y^2 + z^2)^(3/2) + (3*J2*Re^2*mu*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(5/2)) - (15*J2*Re^2*mu*x^2*z^2)/(x^2 + y^2 + z^2)^(9/2) - (15*J2*Re^2*mu*x^2*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(7/2)) + (Cd*area*rho0*theta_dot*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(xdot + theta_dot*y)*(ydot - theta_dot*x))/(2*m*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2)) + (Cd*area*rho0*x*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(xdot + theta_dot*y)*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2))/(2*H*m*(x^2 + y^2 + z^2)^(1/2)), (3*mu*x*y)/(x^2 + y^2 + z^2)^(5/2) - (Cd*area*rho0*theta_dot*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2))/(2*m) - (15*J2*Re^2*mu*x*y*z^2)/(x^2 + y^2 + z^2)^(9/2) - (15*J2*Re^2*mu*x*y*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(7/2)) - (Cd*area*rho0*theta_dot*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(xdot + theta_dot*y)^2)/(2*m*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2)) + (Cd*area*rho0*y*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(xdot + theta_dot*y)*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2))/(2*H*m*(x^2 + y^2 + z^2)^(1/2)),                                                                                           (3*mu*x*z)/(x^2 + y^2 + z^2)^(5/2) + (3*J2*Re^2*mu*x*((10*z)/(x^2 + y^2 + z^2) - (10*z^3)/(x^2 + y^2 + z^2)^2))/(2*(x^2 + y^2 + z^2)^(5/2)) - (15*J2*Re^2*mu*x*z*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(7/2)) + (Cd*area*rho0*z*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(xdot + theta_dot*y)*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2))/(2*H*m*(x^2 + y^2 + z^2)^(1/2)), - (Cd*area*rho0*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2))/(2*m) - (Cd*area*rho0*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(xdot + theta_dot*y)*(2*xdot + 2*theta_dot*y))/(4*m*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2)),                                                                                                                                -(Cd*area*rho0*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(xdot + theta_dot*y)*(2*ydot - 2*theta_dot*x))/(4*m*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2)),                                                                                                             -(Cd*area*rho0*zdot*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(xdot + theta_dot*y))/(2*m*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2)), (3*J2*Re^2*x*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(5/2)) - x/(x^2 + y^2 + z^2)^(3/2), (3*Re^2*mu*x*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(5/2)), 0, 0, 0, 0, 0, 0, 0, 0, 0];
% A5 = [ (3*mu*x*y)/(x^2 + y^2 + z^2)^(5/2) + (Cd*area*rho0*theta_dot*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2))/(2*m) - (15*J2*Re^2*mu*x*y*z^2)/(x^2 + y^2 + z^2)^(9/2) - (15*J2*Re^2*mu*x*y*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(7/2)) + (Cd*area*rho0*theta_dot*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(ydot - theta_dot*x)^2)/(2*m*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2)) + (Cd*area*rho0*x*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(ydot - theta_dot*x)*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2))/(2*H*m*(x^2 + y^2 + z^2)^(1/2)),            (3*mu*y^2)/(x^2 + y^2 + z^2)^(5/2) - mu/(x^2 + y^2 + z^2)^(3/2) + (3*J2*Re^2*mu*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(5/2)) - (15*J2*Re^2*mu*y^2*z^2)/(x^2 + y^2 + z^2)^(9/2) - (15*J2*Re^2*mu*y^2*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(7/2)) - (Cd*area*rho0*theta_dot*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(xdot + theta_dot*y)*(ydot - theta_dot*x))/(2*m*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2)) + (Cd*area*rho0*y*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(ydot - theta_dot*x)*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2))/(2*H*m*(x^2 + y^2 + z^2)^(1/2)),                                                                                           (3*mu*y*z)/(x^2 + y^2 + z^2)^(5/2) + (3*J2*Re^2*mu*y*((10*z)/(x^2 + y^2 + z^2) - (10*z^3)/(x^2 + y^2 + z^2)^2))/(2*(x^2 + y^2 + z^2)^(5/2)) - (15*J2*Re^2*mu*y*z*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(7/2)) + (Cd*area*rho0*z*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(ydot - theta_dot*x)*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2))/(2*H*m*(x^2 + y^2 + z^2)^(1/2)),                                                                                                                                -(Cd*area*rho0*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(ydot - theta_dot*x)*(2*xdot + 2*theta_dot*y))/(4*m*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2)), - (Cd*area*rho0*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2))/(2*m) - (Cd*area*rho0*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(ydot - theta_dot*x)*(2*ydot - 2*theta_dot*x))/(4*m*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2)),                                                                                                             -(Cd*area*rho0*zdot*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(ydot - theta_dot*x))/(2*m*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2)), (3*J2*Re^2*y*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(5/2)) - y/(x^2 + y^2 + z^2)^(3/2), (3*Re^2*mu*y*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(5/2)), 0, 0, 0, 0, 0, 0, 0, 0, 0];
% A6 = [                                                                                                                                                        (3*mu*x*z)/(x^2 + y^2 + z^2)^(5/2) - (15*J2*Re^2*mu*x*z^3)/(x^2 + y^2 + z^2)^(9/2) - (15*J2*Re^2*mu*x*z*((5*z^2)/(x^2 + y^2 + z^2) - 3))/(2*(x^2 + y^2 + z^2)^(7/2)) + (Cd*area*rho0*theta_dot*zdot*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(ydot - theta_dot*x))/(2*m*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2)) + (Cd*area*rho0*x*zdot*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2))/(2*H*m*(x^2 + y^2 + z^2)^(1/2)),                                                                                                                                                        (3*mu*y*z)/(x^2 + y^2 + z^2)^(5/2) - (15*J2*Re^2*mu*y*z^3)/(x^2 + y^2 + z^2)^(9/2) - (15*J2*Re^2*mu*y*z*((5*z^2)/(x^2 + y^2 + z^2) - 3))/(2*(x^2 + y^2 + z^2)^(7/2)) - (Cd*area*rho0*theta_dot*zdot*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(xdot + theta_dot*y))/(2*m*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2)) + (Cd*area*rho0*y*zdot*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2))/(2*H*m*(x^2 + y^2 + z^2)^(1/2)), (3*mu*z^2)/(x^2 + y^2 + z^2)^(5/2) - mu/(x^2 + y^2 + z^2)^(3/2) + (3*J2*Re^2*mu*((5*z^2)/(x^2 + y^2 + z^2) - 3))/(2*(x^2 + y^2 + z^2)^(5/2)) + (3*J2*Re^2*mu*z*((10*z)/(x^2 + y^2 + z^2) - (10*z^3)/(x^2 + y^2 + z^2)^2))/(2*(x^2 + y^2 + z^2)^(5/2)) - (15*J2*Re^2*mu*z^2*((5*z^2)/(x^2 + y^2 + z^2) - 3))/(2*(x^2 + y^2 + z^2)^(7/2)) + (Cd*area*rho0*z*zdot*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2))/(2*H*m*(x^2 + y^2 + z^2)^(1/2)),                                                                                                                                                -(Cd*area*rho0*zdot*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(2*xdot + 2*theta_dot*y))/(4*m*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2)),                                                                                                                                                -(Cd*area*rho0*zdot*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*(2*ydot - 2*theta_dot*x))/(4*m*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2)), - (Cd*area*rho0*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H)*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2))/(2*m) - (Cd*area*rho0*zdot^2*exp((r0 - (x^2 + y^2 + z^2)^(1/2))/H))/(2*m*((xdot + theta_dot*y)^2 + (ydot - theta_dot*x)^2 + zdot^2)^(1/2)), (3*J2*Re^2*z*((5*z^2)/(x^2 + y^2 + z^2) - 3))/(2*(x^2 + y^2 + z^2)^(5/2)) - z/(x^2 + y^2 + z^2)^(3/2), (3*Re^2*mu*z*((5*z^2)/(x^2 + y^2 + z^2) - 3))/(2*(x^2 + y^2 + z^2)^(5/2)), 0, 0, 0, 0, 0, 0, 0, 0, 0];
A1 = [                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      0,                                                                                                                                                                                                                                                                                                         1,                                                                                                                                                                                                                                                                                                         0,                                                                                                                                                                                                                                                                  0,                                                                                                     0,                                                                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
A2 = [                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      0,                                                                                                                                                                                                                                                                                                         0,                                                                                                                                                                                                                                                                                                         1,                                                                                                                                                                                                                                                                  0,                                                                                                     0,                                                                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
A3 = [                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      0,                                                                                                                                                                                                                                                                                                         0,                                                                                                                                                                                                                                                                                                         0,                                                                                                                                                                                                                                                                  1,                                                                                                     0,                                                                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
A4 = [            (3*mu*x^2)/(x^2 + y^2 + z^2)^(5/2) - mu/(x^2 + y^2 + z^2)^(3/2) + (3*J2*Re^2*mu*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(5/2)) - (15*J2*Re^2*mu*x^2*z^2)/(x^2 + y^2 + z^2)^(9/2) - (15*J2*Re^2*mu*x^2*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(7/2)) + (0)/(1) + (0)/(1), (3*mu*x*y)/(x^2 + y^2 + z^2)^(5/2) - (0)/(1) - (15*J2*Re^2*mu*x*y*z^2)/(x^2 + y^2 + z^2)^(9/2) - (15*J2*Re^2*mu*x*y*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(7/2)) - (0)/(1) + (0)/(1),                                                                                           (3*mu*x*z)/(x^2 + y^2 + z^2)^(5/2) + (3*J2*Re^2*mu*x*((10*z)/(x^2 + y^2 + z^2) - (10*z^3)/(x^2 + y^2 + z^2)^2))/(2*(x^2 + y^2 + z^2)^(5/2)) - (15*J2*Re^2*mu*x*z*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(7/2)) + (0)/(1), - (0)/(1) - (0)/(1),                                                                                                                                -(0)/(1),                                                                                                             -(0)/(1), (3*J2*Re^2*x*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(5/2)) - x/(x^2 + y^2 + z^2)^(3/2), (3*Re^2*mu*x*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(5/2)), 0, 0, 0, 0, 0, 0, 0, 0, 0];
A5 = [ (3*mu*x*y)/(x^2 + y^2 + z^2)^(5/2) + (0)/(1) - (15*J2*Re^2*mu*x*y*z^2)/(x^2 + y^2 + z^2)^(9/2) - (15*J2*Re^2*mu*x*y*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(7/2)) + (0)/(1) + (0)/(1),            (3*mu*y^2)/(x^2 + y^2 + z^2)^(5/2) - mu/(x^2 + y^2 + z^2)^(3/2) + (3*J2*Re^2*mu*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(5/2)) - (15*J2*Re^2*mu*y^2*z^2)/(x^2 + y^2 + z^2)^(9/2) - (15*J2*Re^2*mu*y^2*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(7/2)) - (0)/(1) + (0)/(1),                                                                                           (3*mu*y*z)/(x^2 + y^2 + z^2)^(5/2) + (3*J2*Re^2*mu*y*((10*z)/(x^2 + y^2 + z^2) - (10*z^3)/(x^2 + y^2 + z^2)^2))/(2*(x^2 + y^2 + z^2)^(5/2)) - (15*J2*Re^2*mu*y*z*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(7/2)) + (0)/(1),                                                                                                                                -(0)/(1), - (0)/(1) - (0)/(1),                                                                                                             -(0)/(1), (3*J2*Re^2*y*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(5/2)) - y/(x^2 + y^2 + z^2)^(3/2), (3*Re^2*mu*y*((5*z^2)/(x^2 + y^2 + z^2) - 1))/(2*(x^2 + y^2 + z^2)^(5/2)), 0, 0, 0, 0, 0, 0, 0, 0, 0];
A6 = [                                                                                                                                                        (3*mu*x*z)/(x^2 + y^2 + z^2)^(5/2) - (15*J2*Re^2*mu*x*z^3)/(x^2 + y^2 + z^2)^(9/2) - (15*J2*Re^2*mu*x*z*((5*z^2)/(x^2 + y^2 + z^2) - 3))/(2*(x^2 + y^2 + z^2)^(7/2)) + (0)/(1) + (0)/(1),                                                                                                                                                        (3*mu*y*z)/(x^2 + y^2 + z^2)^(5/2) - (15*J2*Re^2*mu*y*z^3)/(x^2 + y^2 + z^2)^(9/2) - (15*J2*Re^2*mu*y*z*((5*z^2)/(x^2 + y^2 + z^2) - 3))/(2*(x^2 + y^2 + z^2)^(7/2)) - (0)/(1) + (0)/(1), (3*mu*z^2)/(x^2 + y^2 + z^2)^(5/2) - mu/(x^2 + y^2 + z^2)^(3/2) + (3*J2*Re^2*mu*((5*z^2)/(x^2 + y^2 + z^2) - 3))/(2*(x^2 + y^2 + z^2)^(5/2)) + (3*J2*Re^2*mu*z*((10*z)/(x^2 + y^2 + z^2) - (10*z^3)/(x^2 + y^2 + z^2)^2))/(2*(x^2 + y^2 + z^2)^(5/2)) - (15*J2*Re^2*mu*z^2*((5*z^2)/(x^2 + y^2 + z^2) - 3))/(2*(x^2 + y^2 + z^2)^(7/2)) + (0)/(1),                                                                                                                                                -(0)/(1),                                                                                                                                                -(0)/(1), - (0)/(1) - (0)/(1), (3*J2*Re^2*z*((5*z^2)/(x^2 + y^2 + z^2) - 3))/(2*(x^2 + y^2 + z^2)^(5/2)) - z/(x^2 + y^2 + z^2)^(3/2), (3*Re^2*mu*z*((5*z^2)/(x^2 + y^2 + z^2) - 3))/(2*(x^2 + y^2 + z^2)^(5/2)), 0, 0, 0, 0, 0, 0, 0, 0, 0];


A(1,:) = A1;
A(2,:) = A2;
A(3,:) = A3;
A(4,:) = A4;
A(5,:) = A5;
A(6,:) = A6;
