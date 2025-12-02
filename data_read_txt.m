function [read_result,judge_result]=data_read_txt(model,txt_path,read_format)%此函数用以读取txt文件
% model（val）：模式选取（1用于读取文件夹中所有txt文件并需要修整文件只包含数据列；2用于读取单个txt文件需要确定哪些行不读取）
% txt_path（cell）：模式1（txt文件夹地址（多个文件夹请用不同cell））；模式2（txt文件地址）
% read_format（matrix）：模式1（用data_format_set函数1生成形如'%f%s%f'）；模式2（用data_format_set函数2生成形如[2,5,7]）
listnum=1;
if model==1
for tp=1:length(txt_path)
    %读取数据
    txtpathor=cell2mat(txt_path(tp));
    namelist=dir([txtpathor,'*.txt']);
    L=length(namelist(:,1));    
    for error_row=1:L
        na=namelist(error_row).name;
        nam=na;
        nam(nam=='.')=[];
        nam(nam=='t')=[];
        nam(nam=='x')=[];
        fi=cell2mat(txt_path(tp));
        fi=[fi,na];
        fileID = fopen(fi);
        result = textscan(fileID,cell2mat(read_format(tp)),'Delimiter',' ',...
            'MultipleDelimsAsOne',1);
        char_loc=find(cell2mat(read_format(tp))=='s')/2;
        for num_char=1:length(char_loc)
            result{1,char_loc(num_char)}=double(cell2mat(result{1,char_loc(num_char)}));
        end 
        

        %校验数据
        error_row=1;
        format_error=0;
        judge_set=[];
        
        try
            data_pre=cell2mat(result);
        catch
            format_error=1;
        end
        for num_row=1:length(data_pre(:,1))
            judge=isnan(data_pre(num_row,length(data_pre(1,:))))||isempty(data_pre(num_row,length(data_pre(1,:))));
            if judge==1
                judge_set(error_row)=num_row;
                error_row=error_row+1;
            end
        end

        fil_name=['File_',nam];
        judge_name=['judge_',nam];
        read_result{listnum,1}=fil_name;
        try
            read_result{listnum,2}=data_pre;
        catch
            format_error=1;
        end

        if format_error==1
            judge_result{listnum,3}='读取格式设置错误';     
        else
            judge_result{listnum,1}=judge_name;
            judge_result{listnum,2}=judge_set;
            judge_result{listnum,3}=[];
        end

        fclose(fileID);        
        listnum=listnum+1;%文件数
        clear judge_set
    end
end
elseif model==2
    for num_file=1:length(txt_path)
        num_line=1;
        fidin=fopen(txt_path{num_file});
        fidout=fopen('read_cache.txt','w');
        while ~feof(fidin)
            tline=fgetl(fidin);
            judge=strrep(tline,' ','');
            if isempty(judge)~=1
                if double(judge(1))>=48&&double(judge(1))<=57
                    if ismember(num_line,read_format)==0
                        tline(find(tline=='D'))='e';
                        fprintf(fidout,'%s\n\n',tline);
                        continue
                    end
                end
            end
            num_line=num_line+1;
        end
        waitdata=importdata('read_cache.txt');
        read_result{num_file,1}=waitdata;
        if isempty(waitdata)==1
            judge_result(num_file)=0;
        else
            judge_result(num_file)=1;
        end
        clear waitdata judge
        fclose all;
        delete('read_cache.txt')
    end
elseif model==3
    for num_file=1:length(txt_path)
        num_line=1;
        num_readformat=1;
        fidin=fopen(txt_path{num_file});
        while ~feof(fidin)
            tline=fgetl(fidin);
            if num_line<=max(read_format)
                if ismember(num_line,read_format)==1
                    read_result{num_readformat}=tline;
                    num_readformat=num_readformat+1;
                    num_line=num_line+1;
                    continue
                else
                    num_line=num_line+1;
                end
            else
                break
            end
        end
        if isempty(read_result)==1
            judge_result=0;
        else
            judge_result=1;
        end
    end
end
end