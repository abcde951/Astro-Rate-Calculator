function DirectCaptureNA =cal_DCNA(M0,M1,T,Z,S,E_cutoff)%此函数用以计算直接俘获反应速率(S-MeV)
%靶核质量数_value；复合核质量数_value；温度GK_value；靶核质子数_value；S因子MeV_value;截断能量（未启用）
miu=(M0*M1/(M0+M1));
%T_cutoff=19.92*E_cutoff^1.5/(Z^2*miu)^0.5;
DirectCaptureNA=(7.83*(10^9))*((Z/(miu*T^2))^(1/3))*S*exp(-4.29*((Z^2*miu)/T)^(1/3));
%DirectCaptureNA=( 7.83*(10^9) )*((Z/(((M0*M1)/(M0+M1))*T^2))^(1/3))*S*exp(-4.29*((Z^2*(M0*M1)/(M0+M1))/T)^(1/3));
end