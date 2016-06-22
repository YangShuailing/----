function [ angle_temp box ] = Angle_EDSL( Node_All,Scale,Point_Step,Node_Location,Mic_Location,Microphone_Cita )

%ANGLE_EDSNL 此处显示有关此函数的摘要
%   此处显示详细说明
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% 朝向信息     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
angle_temp = zeros(Node_All,1);   

for normal_counter = 1:Node_All
    box(normal_counter).flag=ones((2*Scale/Point_Step+1)^2,1);
    box(normal_counter).count=(2*Scale/Point_Step+1)^2;
%     box(normal_counter).x=Grid_all(:,1);
%     box(normal_counter).y=Grid_all(:,2);
end

for i =1:Node_All 
    flag=ones((2*Scale/Point_Step+1)^2,1);%标记
      %%%第 i 个节点的中心点坐标
        x0 =  Node_Location(i,1);
        y0  = Node_Location(i,2);
        Xi = [x0 y0];
        %%% 第 i 个节点的两个麦克风坐标
        x1 =  Mic_Location(i,1);
        y1  = Mic_Location(i,2);
        X1 = [x1 y1];
        x2 =  Mic_Location(i,3);
        y2  = Mic_Location(i,4);
        X2 = [x2 y2];
    for j = 1 : Node_All         
      %%%%%%%%%%%%%%%%%%%
        %方向矢量Mic_vector
        Mic_vector=Node_Location(j,:)-Node_Location(i,:);
        %%%已知方向矢量Direct_vector=[a,b]与中心位置(x0,y0)Microphone_Center_Location，
        %%%计算直线b(x-x0)-a(y-y0)=0  
        %%%计算垂直平分线a(x-x0)+b(y-y0)=0  
        a=Mic_vector(1,1);
        b=Mic_vector(1,2);
        c = a*y0-b*x0; %直线的余项
        cc = -(a*x0 + b*y0); %垂线的余项
%         %%%% 画直线
%         if a==0
%             y = 1:10;
%             x = zeros(Node_All) + x0;
%             plot(x,y,'k-');
%             hold on;
%         else
%             x = 0 : 10;
%             y = subs(solve('b*x - a*y + c ','y')); % solve解方程; subs 表达式转成数值； sym 分数转小数
%             plot(x,y,'k-');
%             hold on;
%         end
%            
%         %%%% 画垂线
%         
%         if b==0
%             y = 1:10;
%             x = zeros(Node_All) + x0;
%             plot(x,y,'k-');
%             hold on;
%         else
%             x = 1:10;
%             y = subs(solve('a*x + b*y + cc ','y'));  % solve解方程; subs 表达式转成数值； sym 分数转小数
%             plot(x,y,'k-');
%             hold on;
%         end
%   %%直线方程yy=aa*xx+bb;     
%   %%f = ax + by + cc;
    lin = [a b cc];  %% 直线方程  
      f =  fun_flag(X1,lin);%直线函数  
      k =1;   
        for temp_x=x0-Scale:Point_Step:x0+Scale
                for temp_y=y0-Scale:Point_Step:y0+Scale
                      X_temp = [temp_x temp_y];
                      f_temp = fun_flag(X_temp,lin);%直线函数  
%                          %%% 画出栅格中所有点
%                          plot(temp_x,temp_y,'k.');
%                          hold on;     
                        if f * f_temp < 0  
                            flag(k) = 0; 
                        end
                        box(i).x(k) = temp_x; %%栅格中点的坐标
                        box(i).y(k) = temp_y; %%
                        box(i).flag(k) = flag(k);
                        k =k+1;
                end
        end  

    end
   
    sum_x=0;
    sum_y=0;
    totalcounnt=0;
    k=1;   
      for temp_x=x0-Scale:Point_Step:x0+Scale
           for temp_y=y0-Scale:Point_Step:y0+Scale
                if flag(k)==1
                sum_x=sum_x+temp_x;
                sum_y=sum_y+temp_y;
                totalcounnt=totalcounnt+1;
                %画出切割区域                 
%                 plot(temp_x,temp_y,'g.');
%                 hold on;   
            end
            k =k+1;
           end
      end
   
        temp_sum=[sum_x/totalcounnt sum_y/totalcounnt];           
        k = ( temp_sum(1,2) - y0)/( temp_sum(1,1) - x0);
%         tan(deg2rad(Microphone_Cita(i)))
        temp = fix(rad2deg(atan(k)));
        if Microphone_Cita(i)*temp >0
             angle_temp(i)=temp; 
        else
             angle_temp(i)=-temp; 
        end
%         %%% 画出区域中心点
%         plot(x0,y0,'ro',temp_sum(1,1),temp_sum(1,2),'r^');
%         axis([-1 11 -1 11]);
%         hold on ; 

%         if isnan(angle_temp) %没有定出角度，采用锚节点修正
%             
%         end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% 更新box
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   [ box ] = update( box,Node_All);
   for temp = 1 : box(i).count
%         if  box(i).flag(temp) == 1
            plot(box(i).x(temp),box(i).y(temp),'k.');
            hold on;
%         end
   end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 迭代过程
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 准则1 
         for p = 1 : box(i).count %% 节点i的区域
             Xi_P = [box(i).x(p)  box(i).y(p)];%% 点p属于节点i的区域   
             for l = 1 :Node_All
                  if l ~= i
                    Xl_1 = [Mic_Location(l,1) Mic_Location(l,2)];%% 第l个节点 micphone 1 的位置
                    Xl_2 = [Mic_Location(l,3) Mic_Location(l,4)];%% 第l个节点 micphone 2 的位置
                    flag_pl(p) = calcul_flag(Xi_P, Xl_1, Xl_2); %%%%%% 点 p 发声，节点 l 的 0 、 1 信息
                    flag_il = calcul_flag( Xi,Xl_1,Xl_2 );%%%%%% 节点 i 发声，节点 l 的真实 0 、 1 信息
                    if (flag_pl(p) ~=flag_il) %%%判断 p 点是否满足条件
                        box(i).flag(p) = 0; %% 满足条件赋值为0，说明该点不满足条件
                        continue;
                    end    
                  end
             end
         end
         box = update(box,Node_All); %%% update box 去除flag为0的点     
          for temp = 1 : box(i).count
%               if  box(i).flag(temp) == 1
                    plot(box(i).x(temp),box(i).y(temp),'go');
                    hold on;
%               end
          end
         
% % %%% 准则2      
%     for l = 1 :Node_All
%       if l ~= i
%          Xl = Node_Location(l,:); %第 l 个节点发声
% %          Xl_1 =Microphone_1_Location(l,:);%% 第l个节点 micphone 1 的位置
% %          Xl_2 =Microphone_2_Location(l,:);%% 第l个节点 micphone 2 的位置
%          flag_li = calcul_flag( Xl,Xi_1,Xi_2 );%%%%%% 节点 l 发声，节点 i 的真实 0 、 1 信息
%          for p = 1 : box(i).count %% 节点i的区域
%              Xi_P = [box(i).x(p)  box(i).y(p)];%% 点p属于节点i的区域         
%               for t = 1:box(i).count_angle %% box(i).count_angle(temp) =360
%                    if box(i).angle_flag(p,t) == 1
%                       X_m1 = [box(i).a_x(p,t) box(i).a_y(p,t)]; %% p点麦克风 1 所在的位置  
% %                      plot(box(i).a_x(p,t),box(i).a_y(p,t),'g.');
%                       flag_temp_angle = calcul_flag(Xl, X_m1, Xi_P ); %%%%%% 节点 l 发声，节点 i 的计算的 0 、 1 信息
%                       if (flag_temp_angle ~= flag_li )
%                           box(i).angle_flag(p,t) = 0;%% 不满足条件赋值为0  
%                       end  
%                    end
%                   
%                end
% 
%           end
%      end
%    end
%          box = update(box,Node_Number); %%% update box    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

end

