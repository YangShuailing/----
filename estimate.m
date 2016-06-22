function return_value = estimate(d , angle,refangle )
%ESTIMATE 此处显示有关此函数的摘要
%   此处显示详细说明
if refangle <90
x =d*cos(angle);
y = d*sin(angle);
elseif refangle >=90   && refangle <180
y = d*sin(angle);
x =  d*cos(angle);
elseif  refangle >=180
x =  d*sin(angle);
y = d*cos(angle);
end 
 


return_value=[x, y];
end

