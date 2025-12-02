function GamovPeak = cal_GPK(Z0,Z1,M0,M1,T,E)%此函数用以计算定义的伽莫夫窗
%靶核质子数_value;复合核质子数_value；靶核质量数_value;复合核质量数_value；温度GK_value；能量Mev_value
GamovPeak = exp(-0.989*Z0*Z1*((M0*M1/M0+M1)*(1/E))^1/2)*exp((-11.605*E)/T);
end