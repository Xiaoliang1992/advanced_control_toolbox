function delay_vec = f_get_time_delay_vec(G)
f_bw = f_get_bandwidth_with_dB(G, -3);
omega = (0.01:0.001:20 * f_bw)' * 2*pi;
[~, phase, ~] = bode(G, omega);
phase = reshape(phase, length(phase), 1);
delay_vec = -phase(2:end)/360 * 2*pi ./ omega(2:end);
% figure
% semilogx(omega(2:end)/2/pi, delay_vec)
semilogx(omega(2:end)/2/pi, delay_vec)
xlabel('frequency / (Hz)')
ylabel('Time delay / (s)')