%% data load
close all
clear
clc

addpath('..\functions')
%% basic parameters
% location of identification data
identification_data = 'savedata1.mat'; 

% location of validation data
validation_data = 'savedata1.mat'; 

% freq range to be revealed in frequency response
freq_show_range = [0.05 5]; % 

% freq range to be fited in model fitting
freq_id_range = [0.1 4.2]; %

% model poles (order)
Np = 4;

% model zeros
Nz = 0;

% sampling freq
fs = 50;

% the end of time domain data to be analysised
T_stop = 35;

%% advanced parameters
freq_point = 200;
io_delay = 0;
window_size = 512/4;
overlap_div = 2;
scale = 180/pi;

%% process
load(identification_data)
identification_y_delta.val = identification_y_delta.val * scale;
t_u0 = identification_u.tim - identification_u.tim(1);
t_y0 = identification_y_delta.tim - identification_y_delta.tim(1);
index = find(t_u0 < T_stop);
index(end) = [];
u0 = identification_u.val;
y0 = identification_y_delta.val;
u = identification_u.val(index);
y = identification_y_delta.val(index);

t_u = t_u0(index);
t_y = t_y0(index);

t = (t_u(1):1/fs:t_u(end))';

u = interp1(t_u, u, t);
y = interp1(t_y, y, t);

u = u - mean(u);
y = y - mean(y);

t0 = identification_u.tim;
fprintf('estimated sampling freq = %.2f Hz\n', 1/ mean(diff(t0(index))))

freq = logspace(log10(freq_show_range(1)), log10(freq_show_range(2)), freq_point);
freq_id = logspace(log10(freq_id_range(1)), log10(freq_id_range(2)), freq_point);

tfest_opt = tfestOptions();
tfest_opt.EnforceStability = 1;

[T_uy, F_uy] = tfestimate(u, y, hanning(window_size), window_size/overlap_div, freq, fs);
[C_uy, ~] = mscohere(u, y, hanning(window_size), window_size/overlap_div, freq, fs);
plant_frd = frd(T_uy, F_uy * 2 *pi, 1/fs);


[T_uy_id, F_uy_id] = tfestimate(u, y, hanning(window_size), window_size/overlap_div, freq_id, fs);
[C_uy_id, ~] = mscohere(u, y, hanning(window_size), window_size/overlap_div, freq_id, fs);
plant_frd_id = frd(T_uy_id, F_uy_id * 2 *pi, 1/fs);

plant_model = tfest(plant_frd_id, Np, Nz, io_delay, tfest_opt)

%% plot figures
op = bodeoptions();
op.FreqUnits = 'Hz';
op.XLim = [freq_show_range];
op.PhaseMatching = 'on';
op.PhaseVisible = 'on';
op.PhaseUnits = 'deg';
op.FreqScale = 'log';
op.Grid = 'on';

Fig_1 = figure(1);
Fig_1.Name = 'time domain response';
subplot(2,1,1)
plot(t, u, t, y)
legend('u', 'y')
ylabel('steering angle /(deg)')
xlabel('Time / s')
t_phi = identification_y_phi.tim(index);
phi = identification_y_phi.val(index);
t_phi = t_phi - t_phi(1);
phi = phi - phi(1);
subplot(2,1,2)
plot(t_phi, phi)
legend('phi')
xlabel('Time / s')
ylabel('phi /(deg)')

xlabel('Time / (s)')
Fig_2 = figure(2);
Fig_2.Name = 'frd response';
subplot(3,1,1)
semilogx(F_uy, mag2db(abs(T_uy)))
legend('Gain response')
ylabel('Gain/dB')
grid on
subplot(3,1,2)
semilogx(F_uy, phase(T_uy) * 180 / pi)
ylabel('Phase/deg')
legend('phase response')
grid on
subplot(3,1,3)
semilogx(F_uy, C_uy)
ylabel('Coherence')
xlabel('freq/Hz')
legend('Coherence')
grid on

Fig_3 = figure(3);
Fig_3.Name = 'identified model with frd response';
bode(plant_frd, plant_model,op)
legend('frd', 'model')


%%
load(validation_data)
identification_y_delta.val = identification_y_delta.val * scale;
t_u0 = identification_u.tim - identification_u.tim(1);
t_y0 = identification_y_delta.tim - identification_y_delta.tim(1);
index = find(t_u0 < T_stop);
index(end) = [];
u0 = identification_u.val(index);
y0 = identification_y_delta.val(index);

t_u = t_u0(index);
t_y = t_y0(index);

t = (t_u(1):1/fs:t_u(end))';

u = interp1(t_u, u0, t);
y = interp1(t_y, y0, t);

u = u - mean(u);
y = y - mean(y);

y1 = lsim(plant_model, u, t);

Fig_4 = figure(4);
Fig_4.Name = 'time domain validation';
subplot(2,1,1)
plot(t,y,t,y1, 'r--')
legend('real test response', 'simulation response')
subplot(2,1,2)
plot(t,u)
legend('input')
xlabel('time/s')

f_get_time_delay_vec(plant_model);

save lat_result.mat plant_model op identification_data validation_data fs