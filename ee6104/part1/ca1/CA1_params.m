clear; 
clc;

%%%%%%
% Zeta and wn affects Tp (Filter)
%%%%%%
% A
% zeta = 0.03; 
% wn = 5;

% B (Stable)
zeta = 0.03;
wn = 2.5;

% C 
% zeta = 0.03;
% wn = 1;

% D (unstable)
% zeta = 0.03;
% wn = 7;

% Adjust zeta

% E (Overdamped)
% zeta = 0.25; 
% wn = 2.5;

% F (Critical damping)
% zeta = 0.006;
% wn = 2.45;

%%%%%%
% Gamma and gamma
%%%%%%
% theta_bar_dot = -sgn(kp)*Gamma*omega*e1 

ga = 100;
Gamma = diag([ 10*ga, 10*ga, 10*ga, 10*ga, 10*ga]);

%%%%%%
% Plant Uncertain parameters a1, a2, b0, b1
%%%%%%
a1 = 0.22;
a2 = 6.1;
b0 = -0.5;
b1 = -1;
num = [b0 b1];
dem = [1 a1 a2];
% dem = [1 2*zeta*wn wn^2];
sys = tf(num,dem);
disp("Old plant poles")
pole(sys)

%%%%%%%%%%%%%%%%%%%%%%%%
% Plant model
%%%%%%%%%%%%%%%%%%%%%%%%
% Rp y = Kp Zp u(t)
%   y / u(t) = (Kp Zp) / Rp

% Zp (plant zero polynomial), first order monic
Kp = b0;
Zp = [1 b1/b0];
% Rp (plant pole polynomial), second order monic
Rp = [1 a1 a2];

%%%%%%%%%%%%%%%%%%%%%%%%
% Observer polynomial
%%%%%%%%%%%%%%%%%%%%%%%%
% Tp (observer polynomial), second order monic
Tp = [1 2*zeta*wn wn^2];

%%%%%%%%%%%%%%%%%%%%%%%%
% Reference model
%%%%%%%%%%%%%%%%%%%%%%%%
% Rm y = Km r
am = 3;
Rm = [1 am];
Km = am;

%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate perfect control gain
%%%%%%%%%%%%%%%%%%%%%%%%

% (T*Rm = Rp*E + F)
[E, F] = deconv(conv(Tp, Rm), Rp);

% Get values Fbar and G1
%   Fbar = F/Kp
%   G1 = E * Z_p - Tp
Fbar = F/Kp;
G1 = conv(E, Zp) - Tp;

% From: Kp*K_star = Km
K_star = Km / Kp;

% Gains (Perfect gain) = [k* -g2 -g1 -f2 -f1 ]
theta_bar_star= [K_star, -G1(3), -G1(2), -Fbar(4), -Fbar(3)]

% u = [k* -g2 -g1 -f2 -f1 ].T [r om_u p*om_u om_y p*om_y]



%%%%%%
% Plant new parameters
%%%%%%
a1_new = 20.4;
a2_new = 6.4;
b0_new = -2;
b1_new = -5;
num = [b0_new b1_new];
dem = [1 a1_new a2_new];
% dem = [1 2*zeta*wn wn^2];
sys = tf(num,dem);
disp("New plant poles")
pole(sys)


%%%%%%%%%%%%%%%%%%%%%%%%
% New Plant model
%%%%%%%%%%%%%%%%%%%%%%%%
% Rp y = Kp Zp u(t)
%   y / u(t) = (Kp Zp) / Rp

% Zp (plant zero polynomial), first order monic
Kp_new = b0_new;
Zp_new = [1 b1_new/b0_new];
% Rp (plant pole polynomial), second order monic
Rp_new = [1 a1_new a2_new];

%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate new perfect control gain
%%%%%%%%%%%%%%%%%%%%%%%%

% (T*Rm = Rp*E + F)
[E, F] = deconv(conv(Tp, Rm), Rp_new);

% Get values Fbar and G1
    %   Fbar = F/Kp
%   G1 = E * Z_p - Tp
Fbar_new = F/Kp_new;
G1_new = conv(E, Zp_new) - Tp;

% From: Kp*K_star = Km
K_star_new = Km / Kp_new;

% Gains (Perfect gain) = [k* -g2 -g1 -f2 -f1 ]
theta_bar_star_new = [K_star_new, -G1_new(3), -G1_new(2), -Fbar_new(4), -Fbar_new(3)]

% u = [k* -g2 -g1 -f2 -f1 ].T [r om_u p*om_u om_y p*om_y]
