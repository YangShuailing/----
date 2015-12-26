function [ flag] = calcul_flag( X0,X1,X2 )
%CALCUL_FLAG 此处显示有关此函数的摘要
%   此处显示详细说明
    s1=sqrt((X0(1,1)-X1(1,1))^2+(X0(1,2)-X1(1,2))^2);
    s2=sqrt((X0(1,1)-X2(1,1))^2+(X0(1,2)-X2(1,2))^2);
    if s1<=s2
        flag =0;
    else
        flag =1;
    end
end

