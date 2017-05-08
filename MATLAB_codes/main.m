% %imf_ecg = emd(ecg);
% 
% %% Sine with baseline wander
% n=20;
% x=-n*pi:0.01:n*pi;
% y=2+sin(x);
% % figure
% % plot(y);
% 
% ybase=sin(0.1*x);
% % figure
% % plot(ybase)
% 
% 
% ymix=y+ybase;
% % figure
% % plot(ymix)
% 
% % imf_ymix=emd(ymix);
% % plot(imf_ymix(1));
% 

%% mit bih 100m
load('m100.mat');
ecg_mit=val(1,1:2000)'/100-10.5;
% plot(ecg);

ecg_mit=ecg;

imf=emd2(ecg_mit);
% 
% 
% c = ecg_mit(:)'; % copy of the input signal (as a row vector)
% N = length(ecg_mit);
% 
% %-------------------------------------------------------------------------
% % loop to decompose the input signal into successive IMF
% 
% imf = []; % Matrix which will contain the successive IMF, and the residue
% 
% while (1) % the stop criterion is tested at the end of the loop
%     
%     %-------------------------------------------------------------------------
%     % inner loop to find each imf
%     
%     h = c; % at the beginning of the sifting process, h is the signal
%     SD = 1; % Standard deviation which will be used to stop the sifting process
%     
%     while SD > 0.3
%         % while the standard deviation is higher than 0.3 (typical value)
%         
%         % find local max/min points
%         [~,maxes] = findpeaks(h);
%         [~,mins] = findpeaks(-h);
%         if size([maxes,mins],2) < 2 % then it is the residue
%             break
%         end
% 
%         %-------------------------------------------------------------------------
%         maxes = [1 maxes N];
%         mins  = [1 mins  N];
% 
% %         if maxes(1)~=1,
% %             maxes=[1,maxes];
% %         end
% %         if maxes(end)~=N,
% %             maxes=[maxes,N];
% %         end
% %         if mins(1)~=1,
% %             mins=[1,mins];
% %         end
% %         if mins(end)~=N,
% %             mins=[mins,N];
% %         end
% %         mins  = [1 mins  N];
%         
%         % spline interpolate to get max and min envelopes; form imf
%         maxenv = spline(maxes,h(maxes),1:N);
%         minenv = spline(mins, h(mins),1:N);
%         
%         m = (maxenv + minenv)/2; % mean of max and min enveloppes
%         prevh = h; % copy of the previous value of h before modifying it
%         h = h - m; % substract mean to h
%         
%         % calculate standard deviation
%         eps = 0.0000001; % to avoid zero values
%         SD = sum ( ((prevh - h).^2) ./ (prevh.^2 + eps) );
%         
%     end
%     
%     imf = [imf; h]; % store the extracted IMF in the matrix imf
%     % if size(maxmin,2)<2, then h is the residue
%     
%     % stop criterion of the algo.
%     if size([maxes,mins],2) < 2
%         break
%     end
%     
%     c = c - h; % substract the extracted IMF from the signal
%     
% end
% 
% % mit_imf100=emd(ecg_mit);


% %%
% sig_new=sum(imf(1:10,:),1);
% plot(sig_new)
% 
% input=sig_new;
% B = 1/10*ones(10,1);
% out = filter(B,1,input);
% 
% figure
% plot(out)
% % plot(sig_new);
% 
% % plot(1:N,sig_new,1:N,ecg_mit)