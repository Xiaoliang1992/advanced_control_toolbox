function Gout = f_notch_filter(fc, bw, gain, fs)
s = tf('s');
if nargin > 3
 fc = f_predist_fc(fc, fs);
end
wn = 2 * pi * fc;
ksi1 = bw;
ksi2 = bw / gain;
G = (s^2 + 2 * ksi1 * wn * s + wn^2) / (s^2 + 2 * ksi2 * wn * s + wn^2);
if abs(gain - 1.0) < eps
    G = 1;
end

if nargin < 4
    Gout = G;
else
    Gout = c2d(G, 1/fs, 'tustin');
end
