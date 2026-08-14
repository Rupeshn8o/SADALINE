clc;close all;clear all;
ep=1e-10; %Small value

N=100000; %Size of Input Samples  %Limitation
M=256; %Number of Taps % Limitation
t=1e-09; %Threshold  % Tolerance
u=10000; %Training Length % Tolerance
mu=1; %Filter Jump Constant  % Parameter
D=floor(M/2); %Delay  % Parameter 

L=randi([2,16]);
h=-2+4*rand(L,1);

te=(0:N-u-1)';
s=zeros(N-u,1);
K=randi([5 20]);

for k=1:K
    A=rand();
    f=rand()*0.5;
    phi=2*pi*rand();
    s=s+A*sin(2*pi*f*te+phi);
end
s=s/max(abs(s));
x = [zeros(M-1,1);randi([-1,1],u,1);s];

r=conv(x,h); %Channel Output Vector
w=zeros(M,1); %Filter Coefficient Vector

y=zeros(N,1); %FIR Output
e=zeros(N,1); %Error Vector
MSE=zeros(N,1); %Mean Square Error
w_h=zeros(M,N); %Noting History

for n=1:N
    if n>=M
        X=r(n:-1:n-M+1);
        y(n)=w'*X; 
        if n>=M+D
            e(n)=x(n-D)-y(n);
        else
            e(n)=0;
        end
        MSE(n)=mean(e(M:n).^2);
        if abs(e(n))>t
            nomu=mu/(ep+X'*X);
            w=w+nomu*e(n)*X;
        end
    else
        y(n)=0;
        e(n)=0;
    end
    w_h(:,n)=w;
end

%% Plot of MSE versus Iteration
figure;
subplot(3,2,1);
plot(1:N,MSE);
xlabel('Iteration');
ylabel('MSE');
title('Mean Square Error vs Iteration');
grid on;

subplot(3,2,2);
plot(log10(1:N),10*log10(MSE));
xlabel('log_{10}(Iteration)');
ylabel('log_{10}(MSE)');
title('Mean Square Error vs Iteration (in dB)');
grid on;

%% 21. Plot Error e[n]

subplot(3,2,3);
stem(1:N,e);
% hold on;
% stem(1:N,x(M:N+M-1),'filled');
% stem(1:N,y,'filled');
xlabel('Samples');
ylabel('Error');
%legend("error","x[n]","y[n]");
title('Equalization Error');
grid on;

%% Plot of All Learned Coefficients
subplot(3,2,4);
plot(log10(1:N),w_h);
xlabel('Iteration');
ylabel('Coefficient Value');
title('Evolution of LMS Equalizer Coefficients');
grid on;

%% Channel and Equalizer Together
[H_w,Ch] = freqz(h,1,2048);
[G_w,EQ] = freqz(w,1,2048);

subplot(3,2,5);
plot(Ch/pi,abs(H_w));
hold on;
plot(EQ/pi,abs(G_w));
yline(1,'--');
hold off;
xlabel('Normalized Frequency (rad/sample)');
ylabel('Magnitude');
title('Channel and Learned Equalizer');
legend('|H(e^{j\omega})|','|G_{LMS}(e^{j\omega})|');
grid on;

%% Convolution
c=conv(h,w);
subplot(3,2,6);
plot(c);
hold on;
xline(L,'--g','Channel Size');
xline(M,'--r','Filter Size');
hold off;
xlabel('Delay');
ylabel('Magnitude');
title('Convolution of LMS Equalizer and Channel');
grid on;

%% NUMERICAL SUMMARY

ISI_power=sum(abs(c).^2)-abs(c(D+1))^2;
ISI_dB=10*log10(ISI_power/(abs(c(D+1))^2+ep));
[peakValue,peakIndex]=max(abs(c));

fprintf('\n');
fprintf('============================================\n');
fprintf('          LMS EQUALIZER SUMMARY\n');
fprintf('============================================\n');

fprintf('Original signal length      : %d\n',N);
fprintf('Channel taps                : %d\n',L);
fprintf('Equalizer taps              : %d\n',M);
fprintf('Step size mu                : %.6f\n',mu);
fprintf('Adaptation threshold        : %f\n',t);
fprintf('Samples used for Training   : %d\n',u);
fprintf('Delay applied               : %d\n',D);
fprintf("Max |e|                     : %f\n", max(abs(e)));
fprintf("Last |e|                    : %f\n",abs(e(end)));
fprintf('Error mean                  : %.6e\n',mean(e));
fprintf('Error variance              : %.6e\n',var(e));
fprintf('Final MSE                   : %.6e\n',MSE(end));
fprintf('Main tap magnitude          : %.6f\n',abs(c(D+1)));
fprintf('Residual ISI power          : %.6e\n',ISI_power);
fprintf('Residual ISI                : %.6f dB\n',ISI_dB);
fprintf('Effective channel peak      : %.6f\n',peakValue);
fprintf('Peak location               : %d\n',peakIndex-1);
% fprintf('\nFinal learned coefficients:\n');
fprintf('============================================\n');