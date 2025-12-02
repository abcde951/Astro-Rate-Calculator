function cal_result=cal_L(fin_spin,fspin_loc,fparty_loc,range1,targ_spin,tspin_loc,tparty_loc,range2,proj_spin,exit_spin)%此函数用以计算反应的轨道角动量
%含有末态核自旋的矩阵；末态自旋在矩阵中的位置；末态核矩阵计算范围；含有靶核自旋的矩阵；靶核自旋在矩阵中的位置；靶核矩阵计算范围；入射核自旋;出射核子自旋
for fl=1:range1 
    for il=1:range2
        l_inp1(fl,il)=targ_spin(il,tspin_loc)+proj_spin;
        l_inp2(fl,il)=targ_spin(il,tspin_loc)-proj_spin;
        l_oup1(fl,il)=fin_spin(fl,fspin_loc)+exit_spin;
        l_oup2(fl,il)=fin_spin(fl,fspin_loc)-exit_spin;

        la(1,1)=abs(l_inp1(fl,il)-l_oup1(fl,il));
        la(1,2)=mod(la(1,1),2);
        la(2,1)=abs(l_inp2(fl,il)-l_oup1(fl,il));
        la(2,2)=mod(la(2,1),2);
        la(3,1)=abs(l_inp1(fl,il)-l_oup1(fl,il));
        la(3,2)=mod(la(3,1),2);
        la(4,1)=abs(l_inp1(fl,il)-l_oup1(fl,il));
        la(4,2)=mod(la(4,1),2);


        if targ_spin(il,tparty_loc)==fin_spin(fl,fparty_loc)
            lw(:,1)=find(la(:,2)==0);
            lww=la(lw(:),1);
            l(fl,il)=min(lww);
            clear lw lww
        else
            lw(:,1)=find(la(:,2)==1);
            lww=la(lw(:),1);
            l(fl,il)=min(lww);
            clear lw lww
        end
    end
end
cal_result=l;