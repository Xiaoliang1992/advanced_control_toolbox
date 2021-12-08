function G = f_butter_lowpass(Np, fc, fs)
if nargin < 3
    fd = fc;
else
    if fc >= fs / 2
        error('fc is over nyquist freq')
    end
    fd = f_predist_fc(fc, fs);
end

[z,p,k] = buttap(Np);
[~, den_p] = zp2tf(z,p,k);
wd = 2*pi*fd;
den = zeros(1, length(den_p));

for i = 1:length(den_p)
    den(i) = den_p(i) / wd^(Np + 1 -i);
end
G = tf(1, den);

if nargin == 3
    G = c2d(G, 1/fs, 'tustin');
end