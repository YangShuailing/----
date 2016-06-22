function [temp] = fun_flag(point, lin)
% 求解点到直线间的距离
  % point=[x0,y0] 
  % lin ax+by+c = 0  
temp =  point(1,1)*lin(1)+point(1,2)*lin(2)+lin(3) ;
% if temp >=0
%     flag = 0;
% else
%     flag =1;
% end

end