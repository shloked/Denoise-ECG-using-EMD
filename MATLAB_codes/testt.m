%load ecg signal
load('m103.mat');
Fs=360;
T=10; % 10 seconds
ecg_sig=(val(1:T*Fs)-1024);
sig_len=length(ecg_sig);
t=linspace(0,T,T*Fs);

plot(t,ecg_sig)


%% Generate noise
% sig_power=(1/sig_len)*(norm(ecg_sig).^2);
sig_power=var(ecg_sig);
SNR=10;
Nstd=sqrt(sig_power/(10^(SNR/10)));
emg_syn=Nstd*randn([1,sig_len]);

%% Construct noisy signal
ecg_in=ecg_sig+emg_syn;
plot(t,ecg_in);

%%









