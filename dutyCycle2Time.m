function [] = dutyCycle2Time(carrier_period,duty_cycle,fid,x_count)
%inputs:
%carrier_period = the period of the pulses used for PWM. This period should
%be far less than the modulated signal. Given in milliseconds.
%duty_cycle = The pulse width. It is a fraction of the pulse period.
%
%outputs:
%t_1 = the length of time the pulse is high
%t_0 = the length of time the pulse is low
%
%readme:
%This function will convert the duty cycle, a percentage, into two
%quantities of time that depend on the carrier period, i.e. the period
%of the pulses.
%Function to take in t as 1xNMAX matrix (units: milliseconds) and open up v2
%(drug) for ton (t(1,:)), then open up v3(no drug) for toff (t(2,:)). These
%commands are

%Units must be in minutes for the ONIX system
ton=duty_cycle*carrier_period/60000;
toff=(1-duty_cycle)*carrier_period/60000;
fprintf(fid,'%% Step %d\r\n',x_count);
fprintf(fid,'open V2\r\nwait %6.6f\r\nclose V2\r\n',ton);
fprintf(fid,'open V3\r\nwait %6.6f\r\nclose V3\r\n\r\n',toff);
end
