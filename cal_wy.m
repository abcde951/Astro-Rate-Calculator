function wy_result=cal_wy(Ji,Gam_p,Gam_gam)%用以计算共振强度
%靶核自旋矩阵、Γp矩阵（行：复合核，列：靶核）、Γγ向量（行：复合核，列保证最后一列是所用数据）；
for il=1:length(Gam_p(1,:))
    w(il)=(2*Ji(il)+1)/(2*(2*Ji(il)+1));
    for fl=1:length(Gam_p(:,1))
        y(fl,il)=(Gam_p(fl,il)*Gam_gam(fl,il))/(sum(Gam_p(fl,:))+Gam_gam(fl,il));
        wy_result(fl,il)=w(il)*y(fl,il);
    end
end
end