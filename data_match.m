function match_result=data_match(subject,object,condition)%该函数作为多条件筛选函数的子函数，仅接受单客体，并返回所选数据整行
%具体输入请看data_match_multicondition函数介绍
match_result_cache=[];
for object_row=1:length(object(:,1))
    for object_condition_num=1:length(condition(:,1))
        if object_condition_num==1
            if condition(object_condition_num,3)==0
                find_result_object=find(subject(:,condition(object_condition_num,1))==object(object_row,condition(object_condition_num,2)));
            elseif condition(object_condition_num,3)==-1
                find_result_object=find(subject(:,condition(object_condition_num,1))<object(object_row,condition(object_condition_num,2)));
            elseif condition(object_condition_num,3)==-1.5
                find_result_object=find(subject(:,condition(object_condition_num,1))<=object(object_row,condition(object_condition_num,2)));
            elseif condition(object_condition_num,3)==1
                find_result_object=find(subject(:,condition(object_condition_num,1))>object(object_row,condition(object_condition_num,2)));
            elseif condition(object_condition_num,3)==1.5
                find_result_object=find(subject(:,condition(object_condition_num,1))>=object(object_row,condition(object_condition_num,2)));
            else
                error('条件输入格式错误')
            end
            match_cache=subject(find_result_object(:),:);
            clear find_result_object
        else
            if isempty(match_cache)==1
                match_cache=[];
            else
                if condition(object_condition_num,3)==0
                    find_result_object=find(match_cache(:,condition(object_condition_num,1))==object(object_row,condition(object_condition_num,2)));
                elseif condition(object_condition_num,3)==-1
                    find_result_object=find(match_cache(:,condition(object_condition_num,1))<object(object_row,condition(object_condition_num,2)));
                elseif condition(object_condition_num,3)==-1.5
                    find_result_object=find(match_cache(:,condition(object_condition_num,1))<=object(object_row,condition(object_condition_num,2)));
                elseif condition(object_condition_num,3)==1
                    find_result_object=find(match_cache(:,condition(object_condition_num,1))>object(object_row,condition(object_condition_num,2)));
                elseif condition(object_condition_num,3)==1.5
                    find_result_object=find(match_cache(:,condition(object_condition_num,1))>=object(object_row,condition(object_condition_num,2)));
                else
                    error('条件输入格式错误')
                end
                match_cache=match_cache(find_result_object(:),:);
                clear find_result_object
            end
        end
    end
    match_result_cache=[match_result_cache;match_cache];
end
match_result=match_result_cache;
end