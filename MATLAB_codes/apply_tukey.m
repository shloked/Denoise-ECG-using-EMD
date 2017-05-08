
function qrs_tukey = apply_tukey(right_zc,left_zc,beta,sig_len)

    qrs_box_len=right_zc-left_zc;
    qrs_centre=round((right_zc+left_zc)/2);
    num_qrs = numel(right_zc);
    qrs_tukey=zeros(1,sig_len);
    
    for i=1:num_qrs
        L_dash=qrs_box_len(i);
        r=2*beta/(1+2*beta);
        L=L_dash*(1+2*beta);
        w = tukeywin(L,r);
        wlen=numel(w);
        wlenby2=floor(wlen/2);
        
        if rem(wlen,2)==0
            if qrs_centre(i)+wlenby2-1>sig_len
                qrs_tukey(qrs_centre(i)-wlenby2:sig_len)=w(1:numel(qrs_tukey(qrs_centre(i)-wlenby2:sig_len)));
            elseif qrs_centre(i)-wlenby2<1
                qrs_tukey(1:(qrs_centre(i)+wlenby2-1))=w(numel(w)-numel(qrs_tukey(1:(qrs_centre(i)+wlenby2-1)))+1:end);
            else
                qrs_tukey(qrs_centre(i)-wlenby2:(qrs_centre(i)+wlenby2-1))=w;
            end
        else
            if qrs_centre(i)+wlenby2>sig_len
                qrs_tukey(qrs_centre(i)-wlenby2:sig_len)=w(1:numel(qrs_tukey(qrs_centre(i)-wlenby2:sig_len)));
            elseif qrs_centre(i)-wlenby2<1
                qrs_tukey(1:(qrs_centre(i)+wlenby2-1))=w(numel(w)-numel(qrs_tukey(1:(qrs_centre(i)+wlenby2-1)))+1:end);
            else
                qrs_tukey(qrs_centre(i)-wlenby2:(qrs_centre(i)+wlenby2))=w;
            end
            
        end
    end
%     plot(qrs_tukey);
end
