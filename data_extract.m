function [extract_result_lebel,extract_result]=data_extract(database,subjectloc,row_objectloc,col_objectloc)%此函数将会从数据集中提取所需主体数据并按照所给客体排列
%所需数据库（矩阵），所提取主体数据所在列（数值），行客体数据所在列（向量），列客体数据所在列（向量）
row_kinds=unique(database(:,row_objectloc));
col_kinds=unique(database(:,col_objectloc));
cache_matrix=NaN(length(row_kinds),length(col_kinds));
for num_row=1:length(database(:,1))
    lebel_row_object=database(num_row,row_objectloc);
    lebel_col_object=database(num_row,col_objectloc);
    cache_matrix(find(row_kinds(:)==lebel_row_object),find(col_kinds(:)==lebel_col_object))=database(num_row,subjectloc);
end
extract_result=cache_matrix;
cache_matrix=[col_kinds';cache_matrix];
row_kinds=[NaN;row_kinds];
extract_result_lebel=[row_kinds,cache_matrix];
end