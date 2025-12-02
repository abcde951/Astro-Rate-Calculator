function format=data_format_set(model,Max_num,special_num)%此函数用以构建按列读取表格的数据读取格式
% model:模式选择
% Max_num：模式1最大列数；模式2最大行数
% special_num：模式1需要以字符形式读取的列数(通常是符号列,若无可设置0)，模式2需要跳过的行若无可留空
if model==1
for col_num=1:Max_num
    judge=ismember(col_num,special_num);
    if col_num==1
        if judge==1
            format_pre='%s';
        else
            format_pre='%f';
        end
    else
        if judge==1
            format_pre=[format_pre,'%s'];
        else
            format_pre=[format_pre,'%f'];
        end
    end
end
format=format_pre;
elseif model==2
    format=special_num;
end
end