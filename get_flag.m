function  [a] = get_flag(Acoustic_Loc,xrank, Node_Location)  
% �õ�ɨ����


[M,N_scans]=size(xrank); % M �ǽڵ���� 30

T_count=(M-1);
a=zeros(T_count*N_scans,2*M+T_count*N_scans);
% a=zeros(T_count*N_scans,2*M+T_count*N_scans);
count=1;
for i=1:N_scans
    table_binary = creat_table(Acoustic_Loc(i), Node_Location); %���ɶ����Ʊ���Ϣ
    for j=1:M
       
            aa=construct_Line(xrank(j,i),Node_Location,table_binary,M);
            %  a(tmpp,:)=www;    
            a(count,1:2*M)=aa;
            a(count,2*M+count)=-1;       
            count=count+1;
       
    end

end

end