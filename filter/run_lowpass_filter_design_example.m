addpath('../functions')
close all
clear
clc

%% slope compensation design
% project name
poject_name = 'slope compensation';

% if compare and show time plot
if_compare = 1;
if_show_time_response = 1;

% default parameters
default_para.fs = 50.0;
default_para.freq = 2;
default_para.gain = 0.1;
default_para.freq_gain = 1.1; % must be more than 1.0
default_para.Np = 1;
default_para.Nz = 0;

% tuned parameters
tuned_para.fs = 50.0;
tuned_para.freq = 2.0;
tuned_para.gain = 0.1;
tuned_para.freq_gain = 1.1; % must be more than 1.0
tuned_para.Np = 3;
tuned_para.Nz = 2;

g_run_lowpass_filter_design;
