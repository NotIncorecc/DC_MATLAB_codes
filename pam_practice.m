fm =2;
fs = 1000;
t = 0:1/fs:1;
m = 0.5 * sin(2*pi*fm*t);

fc = 50;
c = (square(2*pi*fc*t)+1) * 0.5;

pam_natural = m .* c;

pam_flat = zeros(length(t));
for i=1:length(t)
    if c(i)> 0
        if(i==1 || c(i-1)==0)
            hold_value = m(i);
        end
        pam_flat(i) = hold_value;
    end
end

subplot(4,1,1);
plot(t,m);

subplot(4,1,2);
plot(t,c);

subplot(4,1,3);
plot(t,pam_natural);

subplot(4,1,4);
plot(t,pam_flat);