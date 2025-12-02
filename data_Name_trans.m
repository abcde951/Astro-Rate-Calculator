function result=data_Name_trans(model,Name)%将格式为A1nuc1(p,g)A2nuc2格式转化，比如32Cl(p,g)33Ar
%模式 0：A1 nuc1 A2 nuc2    1：A1nuc1  p  2：r_nuc1A1_pg_nuc2A2
%名称_str
Name=strrep(Name,'(p,g)',' ');
A_nuc1=[];
A_nuc2=[];
sym_nuc1=[];
sym_nuc2=[];
num_nuc=1;
for num_char=1:length(Name)
    if Name(num_char)==' '
        num_nuc=2;
    elseif double(Name(num_char))>=48&&double(Name(num_char))<=57
        if num_nuc==1
            A_nuc1=[A_nuc1,Name(num_char)];
        else
            A_nuc2=[A_nuc2,Name(num_char)];
        end
    elseif double(Name(num_char))>=65&&double(Name(num_char))<=90
        if num_nuc==1
            sym_nuc1=[sym_nuc1,char(Name(num_char)+32)];
        else
            sym_nuc2=[sym_nuc2,char(Name(num_char)+32)];
        end
    elseif double(Name(num_char))>=97&&double(Name(num_char))<=122
        if num_nuc==1
            sym_nuc1=[sym_nuc1,Name(num_char)];
        else
            sym_nuc2=[sym_nuc2,Name(num_char)];
        end
    else
        warning('Name格式不规范')
    end
end
if model==0
    result={[sym_nuc1,A_nuc1],[sym_nuc2,A_nuc2]};
elseif model==1
    blank_length=11-length(sym_nuc1)-length(A_nuc1)-1;
    result=[blanks(blank_length),sym_nuc1,A_nuc1,'    ','p'];
    blank_length=5-length(sym_nuc2)-length(A_nuc2);
    result=[result,blanks(blank_length),sym_nuc2,A_nuc2];
elseif model==2
    result=['r_',sym_nuc1,A_nuc1,'_pg_',sym_nuc2,A_nuc2];
end
end