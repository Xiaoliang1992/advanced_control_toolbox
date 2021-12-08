function [y, t] = f_get_from_mat_data(mat_data, fs)
tim = mat_data.tim;
val = mat_data.val;
t = tim(1):1/fs:tim(end);
t = t - t(1);
t = t';
y = interp1(tim, val, t);

