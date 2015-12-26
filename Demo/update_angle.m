function [ output_args ] = update_angle( box,Node_Number)
%UPDATE_ANGLE 此处显示有关此函数的摘要
%   此处显示详细说明
 %%% update
  for i = 1:Node_Number
           for temp = 1 : box(i).count
               angle_index = find (box(i).angle_flag(temp,:) == 0);%标记需要删除的节点
                box(i).count_angle(temp) =  box(i).count_angle(temp) - length(angle_index);
                 if(box(i).count == 0)
                       box(i).flag(index) = 1;  
                       box(i).count =  box(i).count + length(index);
                 else      
                      box(i).a_x(te,box(i).a_x(te,angle_index)) = inf;%删除节点
                     box(i).a_y(te,angle_index) = inf;
                     box(i).angle_flag(te,angle_index) = -1;
                 end
            end
  end
end

