function fc = f_butterworthnozeros_get_fc_by_order(Np, f, gain, fs)
a = 0.01;
b = fs / 2 * 0.95;

G_lowpass_a = f_butter_lowpass(Np, a, fs);
[fa, ~, ~] = bode(G_lowpass_a, 2*pi*f);

G_lowpass_b = f_butter_lowpass(Np, b, fs);
[fb, ~, ~] = bode(G_lowpass_b, 2*pi*f);

if (fa - gain) * (fb - gain) > 0
    error('cannot be solved')
end

thereshold = 0.0001;
N = round(log(fs/2 / thereshold) / log(2));

for i = 1:N
    c = (a + b) / 2;
    G_lowpass_a = f_butter_lowpass(Np, a, fs);
    [fa, ~, ~] = bode(G_lowpass_a, 2*pi*f);
    
    G_lowpass_c = f_butter_lowpass(Np, c, fs);
    [fc, ~, ~] = bode(G_lowpass_c, 2*pi*f);
    
    if (fa - gain) * (fc - gain) < 0
        b = c;
    else
        a = c;
    end
end

fc = (a + b) / 2;

