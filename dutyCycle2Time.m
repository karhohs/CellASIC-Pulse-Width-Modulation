function [t_1,t_0] = dutyCycle2Time(carrier_frequency,duty_cycle)
%inputs:
%carrier_frequency = the frequency of the pulses used for PWM. This frequency should be much greater than the modulated signal.
%duty_cycle = The pulse width. It is a fraction of the pulse period.
%
%outputs:
%t_1 = the length of time the pulse is high
%t_0 = the length of time the pulse is low
%
%readme:
%This function will convert the duty cycle, a realtive number, into two quantities of time that depend on the carrier frequency, or the frequency of the pulses.
%Function to take in t as 2xNMAX matrix (units milliseconds) and open up v2 
%(drug) for ton (t(1,:)), then
%open up v3(no drug) for toff (t(2,:))

function printout(time_series)

%Print out header and start psi

fid = fopen('protocol.txt','wt')
fprintf(fid, '%% M04s Microfluidic Plate \n%% Basic Protocol \n \n \nsetflow X 4.000000 \nsetflow Y 4.000000 \n\n','%','%')

%Find out total length of array
tmp=size(time_series);
NMAX=tmp(2)

for i=1:NMAX
    %Units must be in minutes
    ton=time_series(1,i)/(60000); 
    toff=time_series(2,i)/(60000);
    fprintf(fid,'%% Step %d \n',i);
    fprintf(fid,'open v2 \nwait %6.6f \nclose v2 \n',ton);
    fprintf(fid,'open v3 \nwait %6.6f \nclose v3 \n \n',toff); 
end

fprintf(fid,'end');      
fclose(fid);
