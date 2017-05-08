
%%
load ('ecg1_16272m.mat');
Fs=128; % sampling frequency
T=10; % 10 seconds signal
ecg_sig_uncorr = val(1,1:Fs*T);
sig_power=var(ecg_sig_uncorr);
% ecg=(ecg-1024)/200;
% ecg=downsample(ecg,2);

t=1:length(ecg_sig_uncorr);
% plot(t,ecg_sig);

%% Noise
n_SNR=10;%dB SNR=5
n_sigma=sqrt(sig_power/(10^(n_SNR/10)));
noise=n_sigma*randn([1,length(ecg_sig_uncorr)]);
ecg_sig=ecg_sig_uncorr+noise;
% plot(t,ecg_sig,t,ecg_sig_uncorr);
% figure
% plot(t,ecg_sig);
% figure
% plot(t,ecg_sig_uncorr)


%% Find the IMFs

SNR=6.9897;%dB SNR=5
Nstd=sqrt(sig_power/(10^(SNR/10)));
% Nstd = 0.2;
NR = 1000;
MaxIter = 500;

tic
[modes its]=ceemdan_v2014(ecg_sig,Nstd,NR,MaxIter,2);
% modes=emd(ecg_sig);
t1=toc;
t=1:length(ecg_sig);

[a b]=size(modes);

figure(1);
subplot(a+1,1,1);
plot(t,ecg_sig);% the ECG signal is in the first row of the subplot
ylabel('ECG')
set(gca,'xtick',[])
axis tight;

for i=2:a
    subplot(a+1,1,i);
    plot(t,modes(i-1,:));
    ylabel (['IMF ' num2str(i-1)]);
    set(gca,'xtick',[])
    xlim([1 length(ecg_sig)])
end;

subplot(a+1,1,a+1)
plot(t,modes(a,:))
ylabel(['IMF ' num2str(a)])
% xlim([1 length(ecg_sig)])

%% Mean & Power
A=zeros(1,size(modes,1));
P=zeros(1,size(modes,1));
for k=1:size(modes,1)
    A(k)= abs(mean(sum(modes(1:k,:),1)));
    P(k)= 10*log10(norm(modes(k,:))^2);
end
figure
plot(A)
title('mean vs cumulative IMF')

figure
plot(P)
title('power vs IMF')
%% Reconstruction

ecg_recons=sum(modes(2:end,:),1);
plot(t,ecg_recons);
figure
plot(t,ecg_recons-ecg_sig_uncorr)

%% Errors
% rmse
rmse = sqrt(mean(var(ecg_sig_uncorr-ecg_recons)))

% S/N
SN=mean(var(ecg_sig_uncorr))/mean(var(ecg_recons-ecg_sig_uncorr))

% PCC
PCC = (ecg_sig_uncorr*ecg_recons')/(norm(ecg_sig_uncorr)*norm(ecg_recons))

%%

