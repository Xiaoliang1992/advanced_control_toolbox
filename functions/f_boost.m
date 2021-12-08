function Gout = f_boost(boost_fc, boost_gain, fs)
s = tf('s');

if abs(boost_gain - 1.0) < eps
    Gboost = tf([1],[1]);
else
    Gboost = (s / (2*pi*boost_fc) + 1) / (s / (2*pi*boost_fc / boost_gain) + 1) * boost_gain ;
end

G = Gboost;

if nargin < 3
    Gout = G;
else
    Gout = c2d(G, 1/fs, 'tustin');
end
