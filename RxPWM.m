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

combo_counter = 0; %These keeps track of successive 0% or 100% duty-cycles
x_count = 0; %Keeps track of the number of times a pair of valves opens and closes
HiLo = 0; %Keeps track of whether successive 1's or 0's are being tracked.
%Special Case when i=1;
switch(s_pwm)
    case 0
        HiLo = 0;
        combo_counter = combo_counter + 1;
    case 1
        HiLo = 1;
        combo_counter = combo_counter + 1;
    otherwise
        ton=duty_cycle*carrier_period/60000;
        toff=(1-duty_cycle)*carrier_period/60000;
        x_count = x_count + 1;
        fprintf(fid,'%% Step %d\r\n',x_count);
        fprintf(fid,'open V2\r\nwait %6.6f\r\nclose V2\r\n',ton);
        fprintf(fid,'open V3\r\nwait %6.6f\r\nclose V3\r\n\r\n',toff);
end
%The general case
for i=2:length(s_pwm)
    switch(s_pwm)
        case 0
            if s_pwm(i-1) ~= 1
                HiLo = 0;
                combo_counter = combo_counter + 1;
            else
                ton = combo_counter*carrier_period/60000;
                x_count = x_count + 1;
                fprintf(fid,'%% Step %d\r\n',x_count);
                fprintf(fid,'open V2\r\nwait %6.6f\r\nclose V2\r\n',ton);
                combo_counter = 0;
            end
        case 1
            if s_pwm(i-1) ~= 0
                HiLo = 1;
                combo_counter = combo_counter + 1;
            else
                toff = combo_counter*carrier_period/60000;
                x_count = x_count + 1;
                fprintf(fid,'%% Step %d\r\n',x_count);
                fprintf(fid,'open V3\r\nwait %6.6f\r\nclose V3\r\n\r\n',toff);
                combo_counter = 0;
            end
        otherwise
            if combo_counter > 0
                if HiLo
                    ton = combo_counter*carrier_period/60000;
                    x_count = x_count + 1;
                    fprintf(fid,'%% Step %d\r\n',x_count);
                    fprintf(fid,'open V2\r\nwait %6.6f\r\nclose V2\r\n',ton);
                else
                    toff = combo_counter*carrier_period/60000;
                    x_count = x_count + 1;
                    fprintf(fid,'%% Step %d\r\n',x_count);
                    fprintf(fid,'open V3\r\nwait %6.6f\r\nclose V3\r\n\r\n',toff);
                end
                ton=duty_cycle*carrier_period/60000;
                toff=(1-duty_cycle)*carrier_period/60000;
                x_count = x_count + 1;
                fprintf(fid,'%% Step %d\r\n',x_count);
                fprintf(fid,'open V2\r\nwait %6.6f\r\nclose V2\r\n',ton);
                fprintf(fid,'open V3\r\nwait %6.6f\r\nclose V3\r\n\r\n',toff);
                combo_counter = 0;
            else
                ton=duty_cycle*carrier_period/60000;
                toff=(1-duty_cycle)*carrier_period/60000;
                x_count = x_count + 1;
                fprintf(fid,'%% Step %d\r\n',x_count);
                fprintf(fid,'open V2\r\nwait %6.6f\r\nclose V2\r\n',ton);
                fprintf(fid,'open V3\r\nwait %6.6f\r\nclose V3\r\n\r\n',toff);
            end
    end
end
%The special case at the end of the for loop
if combo_counter > 0
    if HiLo
        ton = combo_counter*carrier_period/60000;
        x_count = x_count + 1;
        fprintf(fid,'%% Step %d\r\n',x_count);
        fprintf(fid,'open V2\r\nwait %6.6f\r\nclose V2\r\n',ton);
    else
        toff = combo_counter*carrier_period/60000;
        x_count = x_count + 1;
        fprintf(fid,'%% Step %d\r\n',x_count);
        fprintf(fid,'open V3\r\nwait %6.6f\r\nclose V3\r\n\r\n',toff);
    end
end
fprintf(fid,'end');
fclose(fid);
end