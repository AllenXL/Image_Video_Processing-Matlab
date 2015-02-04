function New_Sample_Set=Select(Sample_Set,Sample_probability,loop,I,N)
%implement the Select part of tracking


New_image=I;
C_probability(1)=Sample_probability(1);
%calculate the normalized cumulative probabilities
for i=2:1:N
    C_probability(i)=Sample_probability(i)+C_probability(i-1);
end

for i=1:1:N  
    Cumulative_probability(i)= C_probability(i)/C_probability(N);
end

%generate a uniformly distributed random number 0~1 
Y=rand(1,N);
%binary search &get new sample set
for i=1:1:N
    
   j=min(find(Cumulative_probability>=Y(i)));
   New_Sample_Set(i)=Sample_Set(j);
      
end


%a=num2str(loop,'%05.5g');
%b=[a,'.jpg'];
%imwrite(New_image,b);


    




