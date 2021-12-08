
%% process
fprintf(['\n' poject_name ':\n'])
% default filter
if default_para.Nz > 0
    default_para.fz = default_para.freq * default_para.freq_gain;
    default_para.fc = f_butterworthzeros_get_fc_by_order(default_para.Np, default_para.freq, default_para.gain, default_para.fz, default_para.fs);
    default_para.G_lowpass = f_butterworth_lowpass(default_para.Np, default_para.Nz, default_para.fc, default_para.fz, default_para.fs);
else
    default_para.fz = NaN;
    default_para.fc = f_butterworthnozeros_get_fc_by_order(default_para.Np, default_para.freq, default_para.gain, default_para.fs);
    default_para.G_lowpass = f_butter_lowpass(default_para.Np, default_para.fc, default_para.fs);
end

disp('default lowpass filter:')
fprintf('   Np = %d, Nz = %d, fc = %.3f, fz = %.3f\n', default_para.Np, default_para.Nz, default_para.fc, default_para.fz)

if if_compare
% tuned filter
    if tuned_para.Nz > 0
        tuned_para.fz = tuned_para.freq * tuned_para.freq_gain;
        tuned_para.fc = f_butterworthzeros_get_fc_by_order(tuned_para.Np, tuned_para.freq, tuned_para.gain, tuned_para.fz, tuned_para.fs);
        tuned_para.G_lowpass = f_butterworth_lowpass(tuned_para.Np, tuned_para.Nz, tuned_para.fc, tuned_para.fz, tuned_para.fs);
    else
        tuned_para.fz = NaN;
        tuned_para.fc = f_butterworthnozeros_get_fc_by_order(tuned_para.Np, tuned_para.freq, tuned_para.gain, tuned_para.fs);
        tuned_para.G_lowpass = f_butter_lowpass(tuned_para.Np, tuned_para.fc, tuned_para.fs);
    end
    
disp('tuned lowpass filter:')
fprintf('   Np = %d, Nz = %d, fc = %.3f, fz = %.3f\n', tuned_para.Np, tuned_para.Nz, tuned_para.fc, tuned_para.fz)
end

%% plot
op = bodeoptions();
op.FreqUnits = 'Hz';
op.XLim = [0.01, default_para.fs/2*0.9];
op.YlimMode = 'auto';
op.PhaseMatching = 'on';
op.PhaseVisible = 'on';
op.PhaseUnits = 'deg';
op.FreqScale = 'log';
op.Grid = 'on';

if if_compare
    Fig_1 = figure;
    Fig_1.Name = 'frequency domain performance';
    Fig_1.Name = [poject_name ':' Fig_1.Name];
    bode(default_para.G_lowpass, tuned_para.G_lowpass, op)
    legend('default filter', 'tuned filter')
    if if_show_time_response
        Fig_2 = figure;
        Fig_2.Name = 'time domain performance';
        Fig_2.Name = [poject_name ':' Fig_2.Name];
        step(default_para.G_lowpass, tuned_para.G_lowpass)
        grid on
        legend('default filter', 'tuned filter')
    end
else
    
    Fig_1 = figure;
    Fig_1.Name = 'frequency domain performance';
    Fig_1.Name = [poject_name ':' Fig_1.Name];
    bode(default_para.G_lowpass, op)
    legend('default filter')
    if if_show_time_response
        Fig_2 = figure;
        Fig_2.Name = 'time domain performance';
        Fig_2.Name = [poject_name ':' Fig_2.Name];
        step(tuned_para.G_lowpass)
        grid on
        legend('default filter')
    end
end
