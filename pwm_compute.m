function [pwm] = pwm_compute(y_0, x_0, y_1, x_1)
%input:
%y_0, x_0, y_1, x_1 = two points that make a line. These two points should
%be from a "drug waveform". The waveform will have previously been
%normalized to 1. Time will have previously been normalized to the carrier
%frequency.
%pwm_time_error = chances are the time between the two input points  are
%not a integer multiple of the carrier frequency. Therefore, similar to the
%extra day in a leap year, the pwm_time_error keeps track of this building
%difference and when it exceeds the length of a single pulse it an extra
%pulse is added (or left out).
%
%output:
%pwm = a 2 x N matrix that stores duty-cycles for t_on and t_off data. N =
%floor(x_1-x_0). t_on is the first row. t_off is the second row.
%t_on + t_off = 1.
%pwm_time_error = pwm_time_error is updated and returned. (Perhaps should
%be a global variable).

m_input = (y_1-y_0)/(x_1-x_0); %the slope of the line connecting the two input points
b_input = y_1-m_input*x_1; %the intercept of the line connecting the two input points

line_input = @(x) m_input*(x+x_0) + b_input; %this function was shifted to the origin

number_of_pulses = floor(x_1-x_0); %This is true b/c time was normalized to the carrier frequency
%pwm_time_error = mod((x_1-x_0),1/carrier_freq));
pwm = zeros(2,number_of_pulses);

%b/c everything was normalized the sawtooth function is a line with slope
%one that passes through the origin
sawtooth = @(x) x;
for i=1:number_of_pulses
    g = @(x) line_input(x+i-1)-sawtooth(x);
    pwm(1,i) = fzero(g,0.5);
    if pwm(1,i) > 0.95
        pwm(1,i) = 1;
    elseif pwm(1,i) < 0.05
        pwm(1,i) = 0;
    end
    pwm(2,i) = 1 - pwm(1,i);
end

%<debug>
plot ((0:0.5:number_of_pulses),line_input(0:0.5:number_of_pulses),'r')
pulsetrain=ones(1,2*number_of_pulses);
my_temp = 2:2:2*number_of_pulses; %evens
pulsetrain(my_temp) = 0;
hold
my_temp = 0:number_of_pulses-1;
my_temp2 = my_temp + pwm(2,:);
my_temp2 = sort([my_temp my_temp2]);
stairs(my_temp2,pulsetrain);
hold off
%</debug>