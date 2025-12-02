function GaussGamovPeakDelt = cal_GGPKDt(Z0,Z1,M0,M1,T)%此函数用以计算伽莫夫窗的上下限
%靶核质子数_value;复合核质子数_value；靶核质量数_value;复合核质量数_value；温度GK_value
GaussGamovPeakDelt =0.2368*((Z0^2)*(Z1^2)*M0*M1*(T^5)/(M0+M1))^(1/6);
end