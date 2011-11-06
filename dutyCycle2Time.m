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
