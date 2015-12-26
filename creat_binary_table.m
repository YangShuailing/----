function [ table_binary ] = creat_binary_table(start,speaker,Dual_Microphone, X_rank)
%CREAT_BINARY TABLE 此处显示有关此函数的摘要
%   此处显示详细说明

%%%%依次发声
[list,row]=size(Dual_Microphone);  
table_binary=zeros(1,list); %   
x0 = speaker(1,1);
y0 = speaker(1,2);

for k = 1:list
    x1 =  Dual_Microphone(X_rank(start, k ),1);
    y1 =  Dual_Microphone(X_rank(start, k ),2);
    x2 =  Dual_Microphone(X_rank(start, k ),3);
    y2 =  Dual_Microphone(X_rank(start, k ),4);
    X0 = [x0, y0];
    X1 = [x1 y1];
    X2 = [x2 y2];
    dis = norm(X1 -X0) - norm(X2 -X0);
    if dis >= 0
        table_binary(1,k) = 0;
    else
        table_binary(1,k) = 1;
    end
end

end

