function GaussGamovPeakAdd = cal_GGPKAdd(Z0,Z1,M0,M1,T)%此函数用以计算伽莫夫窗的峰位
GaussGamovPeakAdd =0.122*((Z0^2)*(Z1^2)*M0*M1*(T^2)/(M0+M1))^(1/3);
end