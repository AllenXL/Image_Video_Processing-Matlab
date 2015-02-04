%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�������ã�������������������һ����[0,1]
%���룺
%vector����Ҫ��һ��������cell
%�������һ���õ�cell
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vector_scaled=Scaling(vector)

sample_total=size(vector,2);      %cell�е�Ԫ����Ŀ�����ܵ�������
sample_dim=size(vector{1},1);     %ÿ����������������ά��

combined_matrix=zeros(sample_dim,sample_total);   %������������������������һ�����󣬷�����ÿһά�������Сֵ

for i=1:sample_dim
   for j=1:sample_total
     
       combined_matrix(i,j)=vector{j}(i);
   
   end
end

max_vector=max(combined_matrix,[],2);             %ÿһά�������Сֵ
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
    

