fm =2;
fs = 1000;
t = 0:1/fs:1;
m = 0.5 * sin(2*pi*fm*t);

fc = 10;
c = sawtooth(2*pi*fc*t);

pwm = m>c;

pwm_diff = [0,diff(pwm)];
ppm_width = 10;
ppm = zeros(length(t));

for i=1:length(t) - ppm_width
    if pwm_diff(i)==-1
        ppm(i:i+ppm_width) = 1;
    end
end

subplot(3,1,1);
plot(t,m,'b',t,c,'r--');

subplot(3,1,2);
plot(t,pwm);

subplot(3,1,3);
plot(t,ppm);
