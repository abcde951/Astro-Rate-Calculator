function NarrowResonanceNA =cal_NReNA(M0,M1,T,wy,Ep)%此函数用以计算窄共振反应速率
%wy和Ep单位为Mev
%NarrowResonanceNA=( 1.5399*(10^11) )*(((32/33)*T)^(-1.5))*wy*exp((-11.605*Ep)/T)+(M0+M1)*0;
NarrowResonanceNA=( 1.5399*(10^11) )*((((M0*M1)/(M0+M1))*T)^(-1.5))*wy*exp((-11.605*Ep)/T);
end