function [] = RxPWM(s,t)
%inputs:
%s: the drug signal
%t: the corresponding time data(should be in minutes)
%outputs:
%
%description:
%
%Load the configuration data from the configuration file
%carrier_period = 360; %This value is in milliseconds. The minimum value is 360.
carrier_period = 3600;
psi = 2;
%psi = 4;
%Normalize the input signal to be between [0,1]. It is assumed that there
%are no negative values
min_s = min(s);
max_s = max(s);
s = (s-min_s)/(max_s-min_s);
%Normalize the time to be in units of carrier period. Time is in minutes
%and the carrier period is in milliseconds.
t = t*60000/carrier_period;
%For each time point, and its preceding time point, translate them into
%pulse-widths. Assemble these end on end in a vector of length = (length of
%time axis)/(carrier period).
s_pwm = zeros(t(end),1);
ind = 1;
for i=2:length(s)
    if (t(i-1)-t(i)) == 0
        %do nothing
    else
         [temp,num_pulses] = pwm_intersective_method(s(i-1),t(i-1),s(i),t(i),carrier_period);
         s_pwm(ind:num_pulses+ind-1) = temp;
         ind = ind + num_pulses;
    end
end
%Create a text file that the ONIX machine will run using this pulse width
%method.
fid = fopen('PWMtest1_cp3600_psi2','w');
fprintf(fid, '%% M04S Microfluidic Plate\r\n%% Basic Protocol\r\n\r\n\r\n');
fprintf(fid, 'setflow X %6.6f\r\nsetflow Y %6.6f\r\n\r\n',psi,psi);
for i=1:length(s_pwm)
    dutyCycle2Time(carrier_period,s_pwm(i),fid,i);
end
fprintf(fid,'end');
fclose(fid);
end