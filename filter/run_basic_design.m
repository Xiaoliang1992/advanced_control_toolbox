
close all
clear
clc
addpath('../functions')
% butterworth filter without zeros
Np = 3;
fc = 0.9;
fs = 50.0;
G_lowpass1 = f_butter_lowpass(Np, fc, fs);

% butterworth filter with zeros
Np = 4;
Nz = 3;
fp = 10.0;
fz = 20.0;
fs = 50.0;
G_lowpass2 =  f_butterworth_lowpass(Np, Nz, fp, fz, fs);

% PI-lead compensator
Kp = 1.0;
fi = 0.04;
lead_fc = 2;
lead_gain = 2.0;
fs = 50.0;
G_pilead = f_PIlead(Kp, fi, lead_fc, lead_gain, fs);

% PI-leadlag compensator
Kp = 1.0;
fi = 0.01;
lead_fc = 0.2;
lead_gain = 5.0;
lag_fc = 5.0;
lag_gain = 1.1;
fs = 50.0;
G_pileadlag = f_PIleadlag(Kp, fi, lead_fc, lead_gain, lag_fc, lag_gain, fs);

% notch filter
fc = 10.0;
bw = 0.01;
gain = 0.1;
fs = 50.0;
G_notch = f_notch_filter(fc, bw, gain, fs);

op = bodeoptions();
op.FreqUnits = 'Hz';
op.XLim = [0.01, fs/2 * 0.9];
op.YlimMode = 'auto';
op.PhaseMatching = 'on';
op.PhaseVisible = 'on';
op.PhaseUnits = 'deg';
op.FreqScale = 'log';
op.Grid = 'on';

Fig_1 = figure(1);
Fig_1.Name = 'butterworth filter without zeros';
bode(G_lowpass1, op)

Fig_2 = figure(2);
Fig_2.Name = 'butterworth filter with zeros';
bode(G_lowpass2, op)

Fig_3 = figure(3);
Fig_3.Name = 'PI-lead compensator';
bode(G_pilead, op)

Fig_4 = figure(4);
Fig_4.Name = 'PI-leadlag compensator';
bode(G_pileadlag, op)

Fig_5 = figure(5);
Fig_5.Name = 'notch filter';
bode(G_notch, op)