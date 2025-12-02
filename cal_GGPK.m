function GaussGamovPeak = cal_GGPK(E0,Dt,T,E)%此函数用以计算高斯形状的伽莫夫窗
%中心能量Mev_value;展宽_value；温度GK_value；能量_value
GaussGamovPeak = exp((-3*E0)/(0.086173*T))*exp(-((E-E0)/(Dt/2))^2);
end