function wb = f_get_bandwidth_3dB(G)
max_freq = 25;
flag = 0;
for i = 1:2
    omega = (0:0.0001:max_freq)' * 2*pi;
    [mag, ~, ~] = bode(G, omega);
    mag = reshape(mag, length(mag), 1);
    dc_gain = mag(1);
    for j = 1:length(omega)-2
        if (mag(j) > dc_gain * db2mag(-3)) && (mag(j+1) < dc_gain * db2mag(-3))
            flag = 1;
            break;
        end
    end
    if flag == 0
        max_freq = max_freq * 2.0;
    end
end
if flag > 0
    wb = (2 * omega(j + 1)) / 2 / 2 /pi;
else
    wb = NaN;
end