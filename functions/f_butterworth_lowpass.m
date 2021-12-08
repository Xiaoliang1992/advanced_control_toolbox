function G = f_butterworth_lowpass(Np, Nz, fp, fz, fs)

if nargin > 4
    fp_d = f_predist_fc(fp, fs);
    fz_d = f_predist_fc(fz, fs);
else
    fp_d = fp;
    fz_d = fz;
end

coef_p = f_get_buterworth_coef(Np, fp_d);
coef_z = f_get_buterworth_coef(Nz, fz_d);
G = tf(coef_z, coef_p);

if nargin > 4
    G = c2d(G, 1/fs, 'tustin');
end