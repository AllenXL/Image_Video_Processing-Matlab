%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%函数作用：将样本的特征向量归一化至[0,1]
%输入：
%vector：需要归一化的向量cell
%输出：归一化好的cell
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vector_scaled=Scaling(vector)

sample_total=size(vector,2);      %cell中的元素数目，即总的样本数
sample_dim=size(vector{1},1);     %每个样本特征向量的维数

combined_matrix=zeros(sample_dim,sample_total);   %把所有样本的特征向量并成一个矩阵，方便找每一维的最大最小值

for i=1:sample_dim
   for j=1:sample_total
     
       combined_matrix(i,j)=vector{j}(i);
   
   end
end

max_vector=max(combined_matrix,[],2);             %每一维的最大、最小值
min_vector=min(combined_matrix,[],2);
    
for i=1:sample_total
    
    for j=1:sample_dim
        
        if (min_vector(j)==0) && (max_vector(j)==0)
            vector{i}(j)=0;
        else        
            vector{i}(j)=(vector{i}(j)-min_vector(j))/(max_vector(j)-min_vector(j));
        end
        
    end
end

vector_scaled=vector;
    

