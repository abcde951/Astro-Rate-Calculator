function match_result=data_match_multiobject(subject_matrix,object_cell,condition_cell)%该函数为多客体筛选函数，返回所选数据整行，若要提取某一数据请结合data_etract函数
%1.筛选主体（矩阵）；2.筛选客体（多个客体请用元胞形式的!!列!!向量表示，每个元胞放一个客体）；
%3.客体筛选条件（多个客体的条件请用元胞形式的!!列!!向量表示，每个元胞放一个客体的!!所有!!筛选条件，每个筛选条件在元胞中!!列!!排列,仅有一个条件也需要{}。
% 例C2S_jlevelnumloc(主)=Fin_levelnumberloc（客）则输入[C2S_jlevelnumloc,Fin_levelnumberloc,0]，一个客体的多个条件分号隔开[~,~,0;~,~,-1;...]）;
%condition_cell中前两列放主体和客体的筛选依据位，第三列放逻辑关系（代表关系如下 0_'=' ; 1_'>' ; 1.5_>'=' ; -1_'<' ; -1.5_'<='）
for object_num=1:length(object_cell(:,1))
    object_cache=object_cell{object_num};
    condition_cache=cell2mat(condition_cell{object_num});
    if object_num==1
        find_result=data_match(subject_matrix,object_cache,condition_cache);
        match_cache=find_result;
        clear find_result
    else
        if isempty(match_cache)==1
            match_cache=[];
        else
            find_result=data_match(match_cache,object_cache,condition_cache);
            match_cache=find_result;
            clear find_result
        end
    end
    clear object_cache condition_cache
end
match_result=match_cache;
end