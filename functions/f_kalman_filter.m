function [P, S, K, x, y] = f_kalman_filter(kalman_sys, u, z, x, P)
Bd = kalman_sys.Bd;
Dd = kalman_sys.Dd;
F = kalman_sys.F;
H = kalman_sys.H;
Q = kalman_sys.Q;
R = kalman_sys.R;

x_1_pre = F * x + Bd * u;
P_1_pre = F * P * F' + Q;

% update model

z_1 = z;
y_1_pre = z_1 - (H * x_1_pre + Dd * u);
S_1 = H * P_1_pre * H' + R;
K_1 = P_1_pre * H' * inv(S_1);
x_1_post = x_1_pre + K_1 * y_1_pre;
P_1_post = (eye(size(F,1), size(F,1)) - K_1 * H - Dd * u) * P_1_pre;


P = P_1_post;
S = S_1;
x = x_1_post;
K = K_1;
y = H * x + Dd * u;
