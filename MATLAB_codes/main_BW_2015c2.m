
%%
load ('ecg1_16272m.mat');
Fs=128; % sampling frequency
T=10; % 10 seconds signal
ecg_sig_uncorr = (val(1,1:Fs*T));
% ecg=(ecg-1024)/200;
% ecg=downsample(ecg,2);
sig_power=(var(ecg_sig_uncorr));
SNR=6.9897;%dB SNR=5
Nstd=sqrt(sig_power/(10^(SNR/10)));
% Nstd = 0.2;


t=1:length(ecg_sig_uncorr);
% t=linspace(0,length(ecg_sig_uncorr)/Fs,length(ecg_sig_uncorr));
% plot(t,ecg_sig);

%% BW signal
BW=(50*sin(pi*t/Fs)+40*cos(0.6*pi*t/Fs)+20*cos(0.2*pi*t/Fs));
ecg_sig=BW+ecg_sig_uncorr;
% plot(t,BW+ecg_sig);

%% Find the IMFs
NR = 80;
MaxIter = 500;
tic
[modes, ~]=ceemdan_v2014(ecg_sig,Nstd,NR,MaxIter,2);
% modes=emd(ecg_sig);
t1=toc;

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

%% ZCR
zcr=zeros(12,1);
for i=1:size(modes,1)
    zc=abs(diff(sign(modes(i,:))));
    zc_nos=length(zc(zc==2));
    zcr(i)=zc_nos/T;
end

%% recombine
ecg_recomb=zeros(1,length(ecg_sig_uncorr));
bw_est=zeros(1,length(ecg_sig_uncorr));
for i=1:size(modes,1)
    if zcr(i)>1.5
        ecg_recomb=ecg_recomb+modes(i,:);
    else
        bw_est=bw_est+modes(i,:);
    end
end
% figure(2)
% plot(t,ecg_recomb,t,ecg_sig_uncorr);
% title('BW removal')
% legend('reconstructed signal','orginal signal')
% figure(3)
% plot(t,BW,t,bw_est);
% legend('BW','BW estimate')
%% Errors
% rmse
rmse = sqrt(mean(var(ecg_sig_uncorr-ecg_recomb)))

% S/N
SN=mean(var(ecg_sig_uncorr))/mean(var(ecg_recomb-ecg_sig_uncorr))
% SN=10*log10(SN)
% PCC
PCC = (ecg_sig_uncorr*ecg_recomb')/(norm(ecg_sig_uncorr)*norm(ecg_recomb))

%%

% figure(4)
% plot(t,ecg_sig)
% title('signal with BW')

figure

subplot(3,1,1)
plot(t,ecg_sig)
title('(a) ECG signal with BW')
ylim([min(ecg_sig), max(ecg_sig)]);
xlim([1,length(ecg_sig)]);

subplot(3,1,2)
plot(t,bw_est,t,BW)
% legend('BW estimate','BW')
title('(b) BW estimate')
ylim([min(bw_est), max(BW)]);
xlim([1,length(ecg_sig)]);

subplot(3,1,3)
plot(t,ecg_recomb)
title('(c) Signal after BW correction')
ylim([min(ecg_recomb), max(ecg_recomb)]);
xlim([1,length(ecg_sig)]);
