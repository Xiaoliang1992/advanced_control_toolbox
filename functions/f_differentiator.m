function G = f_differentiator(Np, fc, fs)
if nargin > 2
    fc_d = f_predist_fc(fc, fs);
else
    fc_d = fc;
end

coef_p = f_get_buterworth_coef(Np, fc_d);
coef_z = [1 0];
G = tf(coef_z, coef_p);

if nargin > 2
    G = c2d(G, 1/fs, 'tustin');
end