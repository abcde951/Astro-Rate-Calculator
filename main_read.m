clear all
tic
%% 一、读取
% 2.1 读取位置设置
load Setting_start.mat
delete Setting_start.mat
inputdata_path=[mainpath,Name,'\'];
initxtpath=[inputdata_path,'inp_data\re_data\ini\']; %初态核能级数据输入文件位置（记得加'\'）
fintxtpath=[inputdata_path,'inp_data\re_data\fin\']; %终态核能级数据输入文件位置
c2stxtpath=[inputdata_path,'inp_data\re_data\c2s\']; %C2S输入文件位置
btxtpath=[inputdata_path,'inp_data\re_data\b\']; %B(E2/M1)输入文件位置  
inputpath=[inputdata_path,'inp_data\input_cal.xlsx']; %核数据及文件参数设置输入文件位置
sfactorpath=[inputdata_path,'inp_data\Sfactor.xlsx']; %直接俘获数据输入文件位置
errorpath=[inputdata_path,'inp_data\error.xlsx'];%误差输入文件位置
txtpath={initxtpath;fintxtpath;c2stxtpath;btxtpath};
% 2.2 文件及读取参数设置
[~,sheet_name_inp]=xlsfinfo(inputpath);
for num_sheet=1:length(sheet_name_inp)
    [filecoe{num_sheet},~,~]=xlsread(inputpath,num_sheet);
end
[~,sheet_name_err]=xlsfinfo(errorpath);
for num_sheet=1:length(sheet_name_err)
    [error_inp{num_sheet},~,~]=xlsread(errorpath,num_sheet);
end
% 2.2.2 Ini文件
Ini_levelnumberloc=filecoe{2}(1,1); 
Ini_levelspinloc=filecoe{2}(1,2); 
Ini_2Jornot=filecoe{2}(1,3); 
Ini_levelpartyloc=filecoe{2}(1,4); 
Ini_levelfrequencyloc=filecoe{2}(1,5);  
Ini_levelenetgyloc=filecoe{2}(1,6);  
Ini_Max=filecoe{2}(1,7);
Ini_char=filecoe{2}(:,8);
% 2.2.3 Fin文件
Fin_levelnumberloc=filecoe{3}(1,1);
Fin_levelspinloc=filecoe{3}(1,2);
Fin_2Jornot=filecoe{3}(1,3);
Fin_levelpartyloc=filecoe{3}(1,4);
Fin_levelfrequencyloc=filecoe{3}(1,5);
Fin_levelenergyloc=filecoe{3}(1,6);
Fin_Max=filecoe{3}(1,7);
Fin_char=filecoe{3}(:,8);
% 2.2.4 C2S文件
C2S_filnum=filecoe{4}(1,1);
C2S_ilevelnumloc=filecoe{4}(1,2);
C2S_jlevelnumloc=filecoe{4}(1,3);
C2S_C2Sloc=filecoe{4}(1,4);
C2S_Max=filecoe{4}(1,5);
C2S_char=filecoe{4}(:,6);
% 2.2.5 B文件
B_filnum=filecoe{5}(1,1);
B_ilevelspinloc=filecoe{5}(1,2);
B_ilevel2Jornot=filecoe{5}(1,3);
B_ilevelpartyloc=filecoe{5}(1,4);
B_ilevelfrequencyloc=filecoe{5}(1,5);
B_ilevelenergyloc=filecoe{5}(1,6);
B_flevelspinloc=filecoe{5}(1,7);
B_flvel2Jornot=filecoe{5}(1,8);
B_flevelpartyloc=filecoe{5}(1,9);
B_flevelfrequencyloc=filecoe{5}(1,10);
B_flevelenergyloc=filecoe{5}(1,11);
B_deltEloc=filecoe{5}(1,12);
B_Bloc=filecoe{5}(1,13);
B_Maxloc=filecoe{5}(1,14);
B_charloc=filecoe{5}(:,15);
% 2.2.6 读取参数
ininum=data_format_set(1,Ini_Max,Ini_char);
finnum=data_format_set(1,Fin_Max,Fin_char);
c2snum=data_format_set(1,C2S_Max,C2S_char);
bnum=data_format_set(1,B_Maxloc,B_charloc);
read_format={ininum;finnum;c2snum;bnum};
% 2.3 读取程序
if dc_ornot==1
    [~,sf_sheet_name]=xlsfinfo(sfactorpath);
    sf_sheet_num=length(sf_sheet_name);
    for num_sheet=1:sf_sheet_num
        [Sfactor_cache{num_sheet},~,Sfactor_lebel_cache{num_sheet}]=xlsread(sfactorpath,num_sheet);
        Sfactor_lebel{num_sheet}=Sfactor_lebel_cache{num_sheet}(1,:);
        Sfactor{num_sheet}=cell2mat(Sfactor_cache);
        clear Sfactor_cache Sfactor_lebel_cache
    end
end
[read_result,judge_result]=data_read_txt(1,txtpath,read_format);%读取并校验
space_lebel_origin=read_result(2+1:2+C2S_filnum,1);
for num_space=1:length(space_lebel_origin)
    space_origin{num_space}=space_lebel_origin{num_space};
    space_origin{num_space}(1:5)=[];
end
%% 二、检验数据并报错
if length(error_inp{2})<filecoe{1}(7)
    error('靶核能级误差输入数量与考虑靶核能级数不匹配')
end
for num_file=1:length(judge_result(:,1))
    if isempty(judge_result{num_file,3})==0
        error('读取格式有误，请检查读取格式设置， ~_char 参数')%一般是B_charloc参数设置问题
    else
        if isempty(judge_result{num_file,2})==0
            error('输入文件数据格式有误，请检查 judge_result 矩阵并修整输入文件')%一般是输入文件没有列对齐或者糅合
        end
    end
end
clear txtpath c2stxtpath bnum btxtpath c2snum finnum fintxtpath ininum initxtpath read_format inputpath B_charloc num_sheet ...
    sf_sheet_name space_lebel_origin sfactorpath num_file sheet_name_inp sheet_name_err
save('Log_read')
toc
fprintf('数据读取模块完成  1/3 \n\n')