function [ box ] = update( box,Node_Number)
%UPDATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    for i = 1:Node_Number
        %%% update
             index = find (box(i).flag(:) == 0);%�����Ҫɾ���Ľڵ�
             box(i).count =  box(i).count - length(index);
             if(box(i).count == 0)
    %                        disp('****************************')
    %                        disp(['node ',num2str(iindex),'  is keeped!'])
    %                        disp(['sequence: ',num2str(sequence_index)]);
    %                        disp('****************************')     
                   box(i).flag(index) = 1;  
                   box(i).count =  box(i).count + length(index);
             else      
                box(i).x(index) = [];%ɾ���ڵ�
                box(i).y(index) = [];
                box(i).flag(index) = [];
                box(i).a_x(index,:) = [];
                box(i).a_y(index,:) = [];
                box(i).angle_flag(index,:)=[];
             end
         %%% update angle  
%         for temp = 1 : box(i).count
%             A = box(i).angle_flag(temp,:);
%              angle_index = find (A == 0);%�����Ҫɾ���Ľڵ�
%                 box(i).a_x(angle_index) = [];%ɾ���ڵ�
%                 box(i).a_y(angle_index) = [];
%                 box(i).angle_flag(angle_index) = [];
%              
%         end
         
             
    end
end
