function [trans_result,trans_lebel] = data_modspace_trans(modspace_lebel)%此函数用以计将模型空间的标签转化为其波函数阶数、轨道角动量、总角动量
%模型空间标签_matrix
for num_space=1:length(modspace_lebel)
    lebel=modspace_lebel{num_space};
    trans_lebel{num_space,1}=lebel;
    modspace(num_space,1)=str2num(lebel(1));
    lebel(1)=[];
    if lebel(1)=='s'
        modspace(num_space,2)=0;
    elseif lebel(1)=='p'
        modspace(num_space,2)=1;
    elseif lebel(1)=='d'
        modspace(num_space,2)=2;
    elseif lebel(1)=='f'
        modspace(num_space,2)=3;
    elseif lebel(1)=='g'
        modspace(num_space,2)=4;
    elseif lebel(1)=='h'
        modspace(num_space,2)=5;
    end
    lebel(1)=[];
    lebel(length(lebel))=[];
    modspace(num_space,3)=str2num(lebel)/2;
end
trans_result=modspace;
end