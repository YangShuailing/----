function [ box ] = Angle_EDSNL( Node_All,Microphone_Distance,Scale,Node_Location,Mic_Location)
%ANGLE_EDSNL 此处显示有关此函数的摘要
%   此处显示详细说明
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% 朝向信息     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Length = Microphone_Distance;
Width = Microphone_Distance;
Scale=4;%网格点放大尺度
L_Grid = Scale*Scale; %%离散化点的个数  
W_Grid = Scale*Scale; %%离散化点的个数  
%生成离散点
AreaX = -Microphone_Distance : Length/L_Grid : Microphone_Distance;
AreaY = -Microphone_Distance : Width/W_Grid : Microphone_Distance;
for i=0:L_Grid*2
    for j=0:W_Grid*2
        Grid_all(i*(L_Grid+1)+j+2,1) = AreaX(i+1);
        Grid_all(i*(W_Grid+1)+j+2,2) = AreaY(j+1);
    end
end

for normal_counter = 1:Node_All
   box(normal_counter).count=2*(L_Grid+1)*(W_Grid+1);
   box(normal_counter).x=Grid_all(:,1);
   box(normal_counter).y=Grid_all(:,2);
   box(normal_counter).flag=ones(size(Grid_all(:,1)));
end
for i = 1:Node_All
      for temp = 1 : box(i).count
          x0 =  Node_Location(i,1);
          y0  = Node_Location(i,2);
%         if  box(i).flag(temp) == 1
            plot(x0+box(i).x(temp),y0+box(i).x(temp),'bo');
            hold on;
%         end
      end
end     
      
angle_temp = zeros(Node_All,1);    

for  i=1:Node_All
%     flag=ones((Microphone_Distance/Point_Step+1)^2,1);%标记
%%%第 i 个节点的中心点坐标
        x0 =  Node_Location(i,1);
        y0  = Node_Location(i,2);
        X0 = [x0 y0];
        %%% 第 i 个节点的两个麦克风坐标
        x1 =  Mic_Location(i,1);
        y1  = Mic_Location(i,2);
        X1 = [x1 y1];
        x2 =  Mic_Location(i,3);
        y2  = Mic_Location(i,4);
        X2 = [x2 y2];
              for temp = 1 : box(i).count
%         if  box(i).flag(temp) == 1
            plot(x0+box(i).x(temp),y0+box(i).x(temp),'bo');
            hold on;
%         end
       end
    for j = 1 : Node_All   
        
%%%%%%%%%%%%%%%%%%%
        %方向矢量Mic_vector
        Mic_vector=Node_Location(j,:)-Node_Location(i,:);
        %%%已知方向矢量Direct_vector=[a,b]与中心位置(x0,y0)Microphone_Center_Location，
        %%%计算垂直平分线a(x-x0)+b(y-y0)=0  
        a=Mic_vector(1,1);
        b=Mic_vector(1,2);
        aa=-a/b; %%%% 中垂线斜率
        bb=(a*x0+b*y0)/b;  %%%截距    
        
%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% % %%%  画出中垂线
% % %%%%%%%%%%%%%%%%%%%%%%%%% 
%         xx=0:10;
%         yy=aa*xx+bb;      
%         plot(xx,yy,'color','black','Linewidth',1);
%         plot(Node_Location(i,1),Node_Location(i,2),'*');
%         plot(Node_Location(j,1),Node_Location(j,2),'o');
%         hold on; 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   %%直线方程yy=aa*xx+bb;     
%   %%f = y1 - aa*x1 - bb;
    lin = [1 -aa -bb];  %% 直线方程  
      f =  fun_flag(X1,lin);%直线函数  
       for temp = 1 : box(i).count
            X_temp = [x0+box(i).x(temp)  y0+box(i).y(temp)];
            f_temp = fun_flag(X_temp,lin);%直线函数  
            if f * f_temp < 0  
                 box(i).flag(temp) = 0; 
            end  
        
        end
    end 
    %%%%%
 
      %%%%%
      index = find (box(i).flag(:) == 0);%标记需要删除的节点
             box(i).count =  box(i).count - length(index);
             if(box(i).count == 0)
                   box(i).flag(index) = 1;  
                   box(i).count =  box(i).count + length(index);
             else      
                box(i).x(index) = [];%删除节点
                box(i).y(index) = [];
                box(i).flag(index) = [];
             end
   for temp = 1 : box(i).count
%         if  box(i).flag(temp) == 1
            plot(x0+box(i).x(temp),y0+box(i).x(temp),'b.');
            hold on;
%         end
   end

end

end


%%% 画出节点修正区域
       
%       Xi_P = [0 0];
%       for t = 1:box(i).count
%          Xi_P = [ Xi_P ; box(i).x(t)  box(i).y(t)];%% 点p属于节点i的区域   
%       end    
%       
%          m1_est(i,:) = mean(Xi_P);%% i点的麦克风1位置  
%          if m1_est(i,1) == 0
%              temp = 90;
% %         tan(deg2rad(Microphone_Cita(i)))
%          else
%               temp = fix(rad2deg(atan(m1_est(i,2) /m1_est(i,1))));
%          end
%         if Microphone_Cita(i)*temp >0
%              angle_temp(i)=temp; 
%         else
%              angle_temp(i)=-temp; 
%         end
%     
