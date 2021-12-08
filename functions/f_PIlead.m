function Gout = f_PIlead(Kp, fi, lead_fc, lead_gain, fs)
s = tf('s');
if abs(lead_gain - 1) < eps
    Glead = 1.0;
else
    Glead = (s / (2*pi*lead_fc) + 1) / (s / (2*pi*lead_fc * lead_gain) + 1);
end

Gpi = Kp * (1 + fi / s);
G = Glead * Gpi;

if nargin < 5
    Gout = G;
else
    Gout = c2d(G, 1/fs, 'tustin');
end
