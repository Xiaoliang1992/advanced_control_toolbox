function Gout = f_PIleadlag(Kp, fi, lead_fc, lead_gain, lag_fc, lag_gain, fs)
s = tf('s');
if abs(lead_gain - 1.0) < eps
    Glead = 1.0;
else
    Glead = (s / (2*pi*lead_fc) + 1) / (s / (2*pi*lead_fc * lead_gain) + 1);
end
if abs(lag_gain - 1.0) < eps
    Glag = 1.0;
else
    Glag = (s / (2*pi*lag_fc) + 1) / (s / (2*pi*lag_fc / lag_gain) + 1);
end

Gpi = Kp * (1 + fi / s);
G = Glead * Glag * Gpi;

if nargin < 7
    Gout = G;
else
    Gout = c2d(G, 1/fs, 'tustin');
end
