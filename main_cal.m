clear all
tic
load('Log_read.mat')
delete('Log_read.mat')
%% 一、参数设置
% 1.1 常量设置
global hb c MeV T9
hb=6.5821220*10^(-22);
c=299792458;
MeV=931.5;
T9 = [0.001, 0.002, 0.003, 0.004, 0.005, 0.006, 0.007, 0.008,0.009, 0.01,...
0.011, 0.012, 0.013, 0.014, 0.015, 0.016, 0.018,0.02, 0.025, 0.03, 0.04, ...
0.05, 0.06, 0.07, 0.08, 0.09, 0.1, 0.11,0.12, 0.13, 0.14, 0.15, 0.16, 0.18, ...
0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5,0.6, 0.7, 0.8, 0.9, 1.0, 1.25, 1.5, 1.75, ...
2.0, 2.5, 3.0, 3.5, 4.0,5.0, 6.0, 7.0, 8.0, 9.0, 10.0];%温度区间
J_proj=0.5;%入射粒子自旋
J_emission=1;%出射粒子自旋
% 1.2 核参数赋值以及公式设置
global Zp Ap Zt At r miu
inputbase=filecoe{1};
Zp=inputbase(1);
Ap=inputbase(2);
Zt=inputbase(3);
At=inputbase(4);
Sp=inputbase(5);
r0=inputbase(6);
consider_target_nlevel=inputbase(7);
TG=inputbase(8);

r = (r0*(1+At)^(1/3))*10^(-15);%半径计算公式
miu=Ap*At/(Ap+At);%约化质量
clear filecoe
%% 四、Gamov窗及阈值计算
E(:,1) =linspace(0,4,1000);
% 4.1 计算
E0=cal_GGPKAdd(Zp,Zt,Ap,At,TG);
Dt=cal_GGPKDt(Zp,Zt,Ap,At,TG);
for i = 1:1000
GGP(i,1)=cal_GGPK(E0,Dt,TG,E(i,1));
end
GPKoutcome(1,3)=E0+Dt/2;
GPKoutcome(1,2)=E0;
GPKoutcome(1,1)=E0-Dt/2;
% 4.2 输出
fid=fopen([inputdata_path,'outp_data\GaussGP.txt'],'w');
fprintf(fid,'%%GamovPeak');
fprintf(fid,'\n');
fprintf(fid,'%7.4f\t',GPKoutcome(:));
fprintf(fid,'\n');
fclose(fid);
% 4.3 作图
if gamovpeak_plotornot==1
figure(1)
plot(E(:,1),GGP(:,1))
ylabel('Probability (arb. scale)')
xlabel('E(Mev)')
end
clear T Dt fid i TG E
%% 五、筛选能级及修正
% 5.1 靶核能级
inlevdata=data_match_multiobject(read_result{1,2},{consider_target_nlevel},{{[Ini_levelnumberloc,1,-1.5]}});
Lin=length(inlevdata(:,1));
for il=1:Lin
    threshold(il,1)=Sp+inlevdata(il,Ini_levelenetgyloc);
    threshold(il,3)=GPKoutcome(1,3)+Sp;   
end
Sp_write=(inlevdata(:,Ini_levelenetgyloc)+Sp)*1000;
% 5.2 直接俘获能级
for il=1:Lin
    dcfilevdata{il,1}=data_match_multiobject(read_result{2,2},{threshold(il,:)},{{[Fin_levelenergyloc,1,-1]}});
    Ldc(il,1)=length(dcfilevdata{il,1}(:,1));
end
if dc_ornot==1
    if sf_sheet_num~=Lin
        error('Sfactor数据不匹配或输入格式有误')
    end
end
% 5.3 共振能级
for il=1:Lin
    resfilevdata{il,1}=data_match_multiobject(read_result{2,2},{threshold(il,:)},{{[Fin_levelenergyloc,1,1.5;Fin_levelenergyloc,3,-1.5]}});
    Lres(il,1)=length(resfilevdata{il,1}(:,1));
end
if length(error_inp{3})<Lres(1)+Ldc(1)
    error('复合核能级误差输入数量与计算包含复合核能级数量不匹配')
end
% 5.4 自旋修正
Lc2s=C2S_filnum;
Lb=B_filnum;
for il=1:Lin
    if Fin_2Jornot==1
        resfilevdata{il,1}(:,Fin_levelspinloc)=resfilevdata{il,1}(:,Fin_levelspinloc)/2;
        dcfilevdata{il,1}(:,Fin_levelspinloc)=dcfilevdata{il,1}(:,Fin_levelspinloc)/2;
    else
        resfilevdata{il,1}(:,Fin_levelspinloc)=resfilevdata{il,1}(:,Fin_levelspinloc);
        dcfilevdata{il,1}(:,Fin_levelspinloc)=dcfilevdata{il,1}(:,Fin_levelspinloc);
    end
end
if Ini_2Jornot==1
    inlevdata(:,Ini_levelspinloc)=inlevdata(:,Ini_levelspinloc)/2;
else
    inlevdata(:,Ini_levelspinloc)=inlevdata(:,Ini_levelspinloc);
end
if B_ilevel2Jornot==1
    for num_B=1:Lb
        read_result{2+C2S_filnum+num_B,2}(:,B_ilevelspinloc)=read_result{2+C2S_filnum+num_B,2}(:,B_ilevelspinloc)/2;
    end
end
if B_flvel2Jornot==1
    for num_B=1:Lb
        read_result{2+C2S_filnum+num_B,2}(:,B_flevelspinloc)=read_result{2+C2S_filnum+num_B,2}(:,B_flevelspinloc)/2;
    end
end
clear dcfilev resfilev B_ilevel2Jornot B_flvel2Jornot Ini_2Jornot Fin_2Jornot
%% 六、C2S及B(M1/E2)筛选
% 6.1 源数据整合
C2S_data=read_result(3:(2+C2S_filnum),:);%c2s源数据提取
B_data=read_result((2+C2S_filnum+1):(2+C2S_filnum+B_filnum),:);%B(M1/E2)源数据提取
% 6.2 数据筛选
for il=1:Lin
    for num_c2s=1:Lc2s
        %若出现超出数组索引报错请检查客体条件输入格式
        C2S_dc_select_data{num_c2s,1}=data_match_multiobject(C2S_data{num_c2s,2},{dcfilevdata{il,1};inlevdata(il,:)},{{[C2S_jlevelnumloc,Fin_levelnumberloc,0]};{[C2S_ilevelnumloc,Ini_levelnumberloc,0]}});
        C2S_res_select_data{num_c2s,1}=data_match_multiobject(C2S_data{num_c2s,2},{resfilevdata{il,1};inlevdata(il,:)},{{[C2S_jlevelnumloc,Fin_levelnumberloc,0]};{[C2S_ilevelnumloc,Ini_levelnumberloc,0]}});
        [C2S_dc_summary_lebel{il,1}{num_c2s,1},~]=data_extract(C2S_dc_select_data{num_c2s,1},C2S_C2Sloc,C2S_jlevelnumloc,C2S_ilevelnumloc);
        [C2S_res_summary_lebel{il,1}{num_c2s,1},~]=data_extract(C2S_res_select_data{num_c2s,1},C2S_C2Sloc,C2S_jlevelnumloc,C2S_ilevelnumloc);
        clear C2S_dc_select_data C2S_res_select_data
    end
    for num_B=1:Lb
        B_select_data{num_B,1}=data_match_multiobject(B_data{num_B,2},{resfilevdata{il}},{{[B_ilevelspinloc,Fin_levelspinloc,0];[B_ilevelfrequencyloc,Fin_levelfrequencyloc,0];[B_ilevelpartyloc,Fin_levelpartyloc,0]}});
        [B_summary_lebel{il,1}{num_B,1},~]=data_extract(B_select_data{num_B,1},B_Bloc,B_ilevelenergyloc,B_flevelenergyloc);
        clear B_select_data
    end
end
% 6.3 DC_C2S数据整合
for il=1:Lin
    C2S_dc_all{il,1}=NaN(Ldc(il),num_c2s);
    for dl=1:Ldc(il) 
        for num_c2s=1:Lc2s
            if num_c2s==1
                C2S_dc_all{il,1}(dl,Lc2s+1)=0;
            end
            row_loc=find(dcfilevdata{il,1}(dl,Fin_levelnumberloc)==C2S_dc_summary_lebel{il,1}{num_c2s,1}(:,1));
            if isempty(row_loc)==1
                C2S_dc_all{il,1}(dl,num_c2s)=NaN;
                C2S_dc_all{il,1}(dl,Lc2s+1)=C2S_dc_all{il,1}(dl,Lc2s+1)+0;
            else
                C2S_dc_all{il,1}(dl,num_c2s)=C2S_dc_summary_lebel{il,1}{num_c2s,1}(row_loc,2);
                if isnan(C2S_dc_all{il,1}(dl,num_c2s))==1
                    C2S_dc_all{il,1}(dl,Lc2s+1)=C2S_dc_all{il,1}(dl,Lc2s+1)+0;
                else
                    C2S_dc_all{il,1}(dl,Lc2s+1)=C2S_dc_all{il,1}(dl,Lc2s+1)+C2S_dc_all{il,1}(dl,num_c2s);
                end
            end
        end
    end
end
% 6.4 RES_C2S数据整合
for il=1:Lin
    C2S_res_all{il,1}=NaN(Lres(il),num_c2s);
    for fl=1:Lres(il)
        for num_c2s=1:Lc2s
            if num_c2s==1
                C2S_res_all{il,1}(fl,Lc2s+1)=0;
            end
            row_loc=find(resfilevdata{il,1}(fl,Fin_levelnumberloc)==C2S_res_summary_lebel{il,1}{num_c2s,1}(:,1));
            if isempty(row_loc)==1
                C2S_res_all{il,1}(fl,num_c2s)=NaN;
                C2S_res_all{il,1}(fl,Lc2s+1)=C2S_res_all{il,1}(fl,Lc2s+1)+0;
            else
                C2S_res_all{il,1}(fl,num_c2s)=C2S_res_summary_lebel{il,1}{num_c2s,1}(row_loc,2);
                if isnan(C2S_res_all{il,1}(fl,num_c2s))==1
                    C2S_res_all{il,1}(fl,Lc2s+1)=C2S_res_all{il,1}(fl,Lc2s+1)+0;
                else
                    C2S_res_all{il,1}(fl,Lc2s+1)=C2S_res_all{il,1}(fl,Lc2s+1)+C2S_res_all{il,1}(fl,num_c2s);
                end
            end
        end
    end
end
% 6.5 B数据整合
for il=1:Lin
    for fl=1:Lres(il)
        for num_B=1:Lb
            judge_lebel=find(B_summary_lebel{il,1}{num_B}(:,1)==resfilevdata{il,1}(fl,Fin_levelenergyloc));
            if isempty(judge_lebel)==0
                for tl=1:(length(B_summary_lebel{il,1}{num_B,1}(1,:))-1)
                    if isnan(B_summary_lebel{il,1}{num_B,1}(judge_lebel,tl+1))==0
                        B_ALL{il,1}{fl,num_B}(tl,1)=B_summary_lebel{il,1}{num_B}(1,tl+1);%跃迁末态能级能量
                        B_ALL{il,1}{fl,num_B}(tl,2)=B_summary_lebel{il,1}{num_B}(judge_lebel,1)-B_summary_lebel{il,1}{num_B}(1,tl+1);%ΔE
                        B_ALL{il,1}{fl,num_B}(tl,3)=B_summary_lebel{il,1}{num_B}(judge_lebel,tl+1);%B值

                        B_trans{il,1}{fl,num_B}(tl,1)=fl+Ldc(il);%跃迁初态能级数
                        Btrans_wait=find(read_result{2,2}(:,Fin_levelenergyloc)==B_summary_lebel{il,1}{num_B}(1,tl+1));
                        if isempty(Btrans_wait)==1
                            error('请检查B能级能量(%f MeV)是否与Fin中能量一致',B_summary_lebel{il,1}{num_B}(1,tl+1))
                        else
                            B_trans{il,1}{fl,num_B}(tl,2)=Btrans_wait;%跃迁末态能级数
                        end
                        clear Btrans_wait
                        kgama=B_ALL{il,1}{fl,num_B}(tl,2)/(hb*c);
                        if num_B==1
                            lamda(tl,1)=((4*pi)/(75*hb))*(kgama)^5*B_summary_lebel{il,1}{num_B}(judge_lebel,tl+1);
                        elseif num_B==2
                            lamda(tl,1)=((16*pi)/(9*hb))*(kgama)^3*B_summary_lebel{il,1}{num_B}(judge_lebel,tl+1);
                        else
                            error('请在此处添加λ计算公式')
                        end
                    end
                end
                B_ALL{il,1}{fl,num_B}(:,4)=lamda(:,1)/sum(lamda(:,1));%分支比
                B_trans{il,1}{fl,num_B}(:,3)=B_ALL{il,1}{fl,num_B}(:,4);
                clear lamda
            else
                B_ALL{il,1}{fl,num_B}=[];
                B_trans{il,1}{fl,num_B}=[];
            end
        end
    end
end
% 6.6 DC数据整合
if dc_ornot==1
    for il=1:Lin
        for dl=1:Ldc(il)
            Sfactor_fix{il}(dl,1)=sum(Sfactor{il}(dl,:))*1e-3;%eV--keV
        end
        Sfactor_all(il)=sum(Sfactor_fix{il}(:,1));
    end
end
clear row_loc Blebel B_filnum judge_lebel
%% 七、标准值计算            
% 7.1 轨道角动量计算
%ldc=cal_L(dcfilevdata,Fin_levelspinloc,Ldc,inlevdata,Ini_levelspinloc,Lin,S_incident,0);
for il=1:Lin
    lres{il}=cal_L(resfilevdata{il},Fin_levelspinloc,Fin_levelpartyloc,Lres(il),inlevdata(il,:),Ini_levelspinloc,Ini_levelpartyloc,1,J_proj,0);%计算复合核所以出射粒子不考虑
end
% 7.2 Er计算
for il=1:Lin
    for fl=1:Lres(il)
        Er_res{il}(fl,1)=resfilevdata{il}(fl,Fin_levelenergyloc)-Sp-inlevdata(il,Ini_levelenetgyloc);%Er标准值
        if Er_res{il}(fl,1)<=0
            Er_res{il}(fl,1)=NaN;
        end
    end
end
% 7.3 Γp计算
for il=1:Lin
    for fl=1:Lres(il)
        Gsp{il}(fl,1)=cal_Gamma_SP(Er_res{il}(fl,1),lres{il}(fl,1));
        Gp{il}(fl,1)=C2S_res_all{il}(fl,Lc2s+1)*Gsp{il}(fl,1);
    end
end
% 7.4 Γγ计算
for il=1:Lin
    Gamgam{il}=zeros(Lres(il),num_B);
    for fl=1:Lres(il)
        %Gamgam(fl,1)=resfilevdata(fl,Fin_levelnumberloc);
        for num_B=1:Lb
            if isempty(B_ALL{il}{fl,num_B})==0
                for corr_lev=1:length(B_ALL{il}{fl,num_B}(:,1))
                    Gamgamor=cal_Gamma_gam(B_ALL{il}{fl,num_B}(corr_lev,2),B_ALL{il}{fl,num_B}(corr_lev,3),num_B) * B_ALL{il}{fl,num_B}(corr_lev,4);%此处已乘分支比
                    if corr_lev==1
                        Gamgam{il}(fl,num_B)=Gamgamor;
                        clear Gamgamor
                    else
                        Gamgam{il}(fl,num_B)=Gamgam{il}(fl,num_B)+Gamgamor;
                        clear Gamgamor
                    end
                end
            else
                Gamgam{il}(fl,num_B)=Gamgam{il}(fl,num_B)+0;
            end
        end
        Gamgam{il}(fl,Lb+1)=sum(Gamgam{il}(fl,1:Lb));
    end
end
clear corr_lev
% 7.5 wγ计算
for il=1:Lin
    if il==1
        Gp_wy_cal=Gp{il};
        Gamgam_wy_cal=Gamgam{il}(:,Lb+1);
    else
        add_zero_raw=Lres(1,1)-Lres(il);
        Gamgam_wy_cal_cache=[zeros(add_zero_raw,1);Gamgam{il}(:,Lb+1)];
        Gamgam_wy_cal=[Gamgam_wy_cal,Gamgam_wy_cal_cache];
        Gp_wy_cal_cache=[zeros(add_zero_raw,1);Gp{il}];
        Gp_wy_cal=[Gp_wy_cal,Gp_wy_cal_cache];
        clear Gp_wy_cal_cache Gamgam_wy_cal_cache
    end
end
Omggam_cal=cal_wy(inlevdata(:,Ini_levelspinloc),Gp_wy_cal,Gamgam_wy_cal);
for il=1:Lin
    add_zero_raw=Lres(1,1)-Lres(il);
    Omggam_cache=Omggam_cal(:,il);
    if add_zero_raw==0
        Omggam{il}=Omggam_cache;
    else
        Omggam_cache(1:add_zero_raw)=[];
        Omggam{il}=Omggam_cache;
    end
end
clear Gp_wy_cal Gamgam_wy_cal add_zero_raw Omggam_cache
% 7.6 反应速率计算
% 7.6.1 加权因子计算
weightcoe=cal_weigthcoe(inlevdata(:,Ini_levelspinloc),inlevdata(:,Ini_levelenetgyloc),T9);
% 7.6.2 各靶核对应所有复合核能级加权直接俘获反应速率计算(直俘分支)
if dc_ornot==1
    for il=1:Lin
        for Tv=1:length(T9)
            NA0dc_cache(Tv,1)=cal_DCNA(At,Ap,T9(Tv),Zt,Sfactor_all(il)*1e-3,GPKoutcome(3))*weightcoe(Tv,il);%不同靶核能级到不同直接俘获能级的反应速率（已加权）
        end
        NA0dc{il}=NA0dc_cache;
        clear NA0dc_cache
    end
end
% 7.6.3 各靶核对应所有复合核能级加权共振反应速率计算(共振分支)
for il=1:Lin
    for fl=1:Lres(il)
        for Tv=1:length(T9)
            NA0res_cache(Tv,1)=cal_NReNA(Ap,At,T9(Tv),Omggam_cal(fl,il),Er_res{il}(fl,1))*weightcoe(Tv,il);%不同靶核能级到不同共振能级的反应速率（已加权）
        end
        NA0res{il}{fl,1}=NA0res_cache;
        clear NA0res_cache
    end
end
% 7.6.4 各靶核对应总反应速率计算
for il=1:Lin
    NA1_cache=zeros(length(T9),1);
    for fl=1:Lres(il)
        NA1_cache(:,1)=NA0res{il}{fl,1}(:,1)+NA1_cache(:,1);
    end
    if dc_ornot==1
        NA1_cache(:,1)=NA0dc{il}(:,1)+NA1_cache(:,1);
    end
    NA1{il,1}=NA1_cache;
    clear NA1_cache
end
% 7.6.5 总反应速率计算
NA_cal=zeros(length(T9),1);
for il=1:Lin
    NA_cal=NA_cal+NA1{il,1};
end
fprintf('标值计算完成 \n\n')
%% 八、标准值作图
if standard_plotornot==1
for il=1:Lin
    figure(il+1)
    for fl=1:Lres(il)
        loglog(T9(:),NA0res{il}{fl,1}(:,1),'linewidth',2);%共振速率
        hold on
        legend_st{fl}=num2str(resfilevdata{il}(fl,Fin_levelenergyloc));
    end
    if dc_ornot==1
        loglog(T9(:),NA0dc{il}(:,1),'linewidth',2);%直俘速率
        hold on
        legend_st{Lres(il)+1}='dc';
    end
    loglog(T9(:),NA_cal(:,1),'linewidth',2);%总速率
    legend_st{length(legend_st)+1}='Total';
    legend(legend_st);
    xlim([0.01,10]);
    ylim([1e-16,20]);
    ylabel('Reactionrate (cm^3s^-^1mole^-^1)')
    xlabel('Temperature(GK)')
    clear legend_st
end
end
%% 十一、整理数据
% 11.1 直俘数据整理
if dc_ornot==1
    for il=1:Lin
        title1=["能级数","宇称(43+)","自旋","末态能级能量(MeV)","C2S(1)","C2S(2)","C2S(3)","C2S(all)",space_origin(:)'];
        ALL_dc{il,1}=[dcfilevdata{il}(:,Fin_levelnumberloc),dcfilevdata{il}(:,Fin_levelpartyloc),dcfilevdata{il}(:,Fin_levelspinloc),dcfilevdata{il}(:,Fin_levelenergyloc),...
            C2S_dc_all{il},Sfactor{il}];
        ALL_dc{il,1}=[title1;ALL_dc{il,1}];
        ALL_dc{il,2}=NA0dc{il};
    end
end
% 11.2 共振数据整理
for il=1:Lin
    title2=["能级数","宇称(43+)","自旋","末态能级能量(MeV)","C2S(1)","C2S(2)","C2S(3)","C2S(all)","Er(MeV)","Γp(MeV)","ΓBE2(MeV)","ΓBM1(MeV)","Γγ(MeV)","wγ(MeV)"];
    ALL_res{il,1}=[resfilevdata{il}(:,Fin_levelnumberloc),resfilevdata{il}(:,Fin_levelpartyloc),resfilevdata{il}(:,Fin_levelspinloc),resfilevdata{il}(:,Fin_levelenergyloc),...
        C2S_res_all{il},Er_res{il},Gp{il},Gamgam{il},Omggam{il}];
    ALL_res{il,1}=[title2;ALL_res{il,1}];
    ALL_res{il,2}=NA0res{il};
end
clear title1 title2 legend_st inputbase inputdata_path hb c kgama MeV miu r r0 J_emission J_proj space Res_write DC_write
clear Ldc Lin Lres Lb Lc2s al il fl dl ans consider_target_nlevel...
     Fin_levelenergyloc Fin_levelfrequencyloc Fin_levelnumberloc Fin_levelpartyloc Fin_char Fin_Max Fin_levelspinloc...
     Ini_levelenetgyloc Ini_levelfrequencyloc Ini_levelnumberloc Ini_levelpartyloc Ini_levelspinloc Ini_char Ini_Max...
     B_flevelenergyloc B_ilevelenergyloc B_Bloc B_flevelfrequencyloc B_flevelpartyloc B_flevelspinloc B_ilevelfrequencyloc B_ilevelpartyloc B_ilevelspinloc B_Maxloc...
     C2S_C2Sloc C2S_char C2S_filnum C2S_ilevelnumloc C2S_jlevelnumloc C2S_Max  ...
     num_B num_c2s num_file num_plot times_sample mc_ornot dc_ornot dclev_space_loc E judge_result Omggam_cal E0 gamovpeak_plotornot mainpath num_space...
     sfactorpath sheet_name standard_plotornot GGP
save('Log_cal')
warning('off','MATLAB:MKDIR:DirectoryExists')
eval(['mkdir(''data/',Name,'/outp_data/''',',''Matlab'')']);
save(['data/',Name,'/outp_data/Matlab/result_cal'])
toc
fprintf('速率计算模块完成  2/3 \n\n')
     