function cal_result=cal_Gamma_SP(Er,lres)%此函数用以计算单质子宽度(MeV)
%共振能_value；轨道角动量_value
global c hb miu MeV Zp Zt r
if Er<0
    error('共振能出现负值,请检查各能级能量')
end

if Er>0 %解库伦波函数
    k=((2*miu*MeV*Er)^0.5)/(c*hb);
    eta=0.1574*Zp*Zt*(miu/Er)^0.5;
    rho=k*r;
    GLor= coulombwave('Gl',lres,eta,rho);
    GL=GLor.value;
    FLor= coulombwave('Fl',lres,eta,rho);
    FL=FLor.value;
    P1=rho/((GL)^2+(FL)^2);
    Gsp=0.5*(3*hb^2*c^2/(miu*MeV*r^2))*P1;%此处0.5的系数应当通过解薛定谔方程求得
else
    Gsp=0;
end

Gsp(find(isnan(Gsp)==1)) = 0;%%%%%%%
cal_result=Gsp;
end