clear all
t1=clock;
%% 参数设置
% 1.1 输入设置
% 1.1.1 路径设置
mainpath='E:\test\github\data\' ; %程序主文件夹地址，记得最后的\
Name='30Cl(p,g)31Ar';%文件夹名称

% 1.2 计算程序设置
% 1.2.1 内部程序使用设置
dc_ornot=1;%是否考虑直接俘获

% 1.3 输出设置
% 1.3.1 作图设置
gamovpeak_plotornot=1;%gamov窗作图
standard_plotornot=1;%标准值作图
%% 执行
warning ('开始计算 %s 反应速率',Name)
save('Setting_start')
run('main_read.m')
run('main_cal.m')
load('Log_cal.mat','t1')
t2=clock;
warning ('结束咧！全都结束咧！！共用时 %0.2f 秒',etime(t2,t1))