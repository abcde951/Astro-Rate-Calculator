function cal_result=cal_Gamma_gam(delt_E,B,kinds)%此函数用以计算γ宽度(MeV)
%能量差；B的值；BE2 (1)、BM1 (2)或者其他（需添加公式）
if kinds==1
    gamgam=8.13*10^(-7)*delt_E^5*B;
elseif kinds==2
    gamgam=1.16*10^(-2)*delt_E^3*B;
else
    error('请添加相应的Γγ计算公式')
end
cal_result=gamgam*10^(-6);
end