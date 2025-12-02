function cal_result=cal_weigthcoe(Ji,Ei,T9)%用以计算权重因子
%靶核自旋_vec;共振能_vec;温度GK_vec
for Tv=1:length(T9)
    for il=1:length(Ji(:,1))
        weightcoe_il(Tv,il)=(2*Ji(il,1)+1)*exp(-11.605*Ei(il,1)/T9(Tv));
    end
    weightcoe_all(Tv,1)=sum(weightcoe_il(Tv,:));
    for il=1:length(Ji(:,1))
        weightcoe(Tv,il)=weightcoe_il(Tv,il)/weightcoe_all(Tv,1);
    end
end
cal_result=weightcoe;
end