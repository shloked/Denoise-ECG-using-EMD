

function P=t_test(alpha,modes)
    sig_len=size(modes,2);
    for m=1:size(modes,1)
        c_PS=sum(modes(1:m,:),1);
        s=sqrt(var(c_PS));
        nu=sig_len-1;
        zz=abs(sqrt(sig_len)*mean(c_PS)/s);
        p_val=2*(1-tcdf(zz,nu))
        if p_val<alpha
            break;
        end     
    end
    P=m-1;
end