function [  Est_MSP,angle_temp ] = improve( box1, box2,Xnode,Xnode_Mic1,XCita)
%ANVANCE 此处显示有关此函数的摘要   improve( box1, box2,Xnode,Xnode_Mic1,XCita);
%   此处显示详细说明
%%% 准则1 
Microphone_Cita = XCita;
[M N] = size(Xnode);
Node_Number =M;
for  i=1:Node_Number
         Xi = Xnode(i,:); %第 i个节点中心点坐标
         for p = 1 : box1(i).count %% 节点i的区域
             Xi_P = [box1(i).x(p)  box1(i).y(p)];%% 点p属于节点1的区域             
             for l = 1 :Node_Number
                  if l ~= i
                    Xl_1 =Xnode_Mic1(l,:);%% 第l个节点 micphone 1 的位置
%                     Xl_2 =Microphone_2_Location(l,:);%% 第l个节点 micphone 2 的位置
                    flag_pl(p) = calcul_flag(Xi_P, Xl_1, Xnode(l,:)); %%%%%% 点 p 发声，节点 l 的 0 、 1 信息
                    flag_il = calcul_flag( Xi,Xl_1, Xnode(l,:) );%%%%%% 节点 i 发声，节点 l 的真实 0 、 1 信息
                    if (flag_pl(p) ==flag_il) %%%判断 p 点是否满足条件
                        box1(i).flag(p) = 1; %% 满足条件赋值为1，如果循环结束之后依旧为0，说明该点不满足条件
                    end    
                  end
             end
         end    
          box1 = update(box1,Node_Number); %%% update box  
% %经过节点过滤后，求剩余节点的坐标平均值为最后的估计位置
Est_MSP = [];
tmp = [];
tmp_1 = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j = 1:Node_Number
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
      for m = 1: box1(j).count
          tmp = [tmp; box1(j).x(m),box1(j).y(m)]; 
      end    
    tmp_1 = [mean(tmp(:,1))  mean(tmp(:,2))];
    Est_MSP = [Est_MSP; tmp_1];
    tmp = [];    
end         
          
% %%% 准则2     
   Xi_1=Xnode_Mic1(i,:);
    for l = 1 :Node_Number
      if l ~= i
         Xl = Xnode_Mic1(l,:); %第 l 个节点发声
%          Xl_1 =Microphone_1_Location(l,:);%% 第l个节点 micphone 1 的位置
%          Xl_2 =Microphone_2_Location(l,:);%% 第l个节点 micphone 2 的位置
         flag_li = calcul_flag( Xl,Xi_1, Xnode(i,:));%%%%%% 节点 l 发声，节点 i 的真实 0 、 1 信息
         for p = 1 : box2(i).count %% 节点i的区域
              Xi_P = [box2(i).x(p)  box2(i).y(p)];%% 点p属于节点1的区域              
%              plot(box(i).a_x(p,t),box(i).a_y(p,t),'g.');
              flag_temp_angle = calcul_flag(Xl, Xi_P, Xnode(i,:) ); %%%%%% 节点 l 发声，节点 i 的计算的 0 、 1 信息
              if (flag_temp_angle ~= flag_li )
                  box2(i).flag(p) = 0;%% 不满足条件赋值为0  
              end  
          end
    end
     
   end
         box2 = update(box2,Node_Number); %%% update box  
                      
      Xi_P = [0 0];
      for t = 1: box2(i).count
         Xi_P = [ Xi_P ; box2(i).x(t)  box2(i).y(t)];%% 点p属于节点i的区域   
      end    
         m1_est(i,:) = [mean(Xi_P(:,1))  mean(Xi_P(:,2))];%% i点的麦克风1位置  
         if m1_est(i,1) == 0
             temp = 45;
%         tan(deg2rad(Microphone_Cita(i)))
         else
              temp = fix(rad2deg(atan(m1_est(i,2) /m1_est(i,1))));
         end
        if Microphone_Cita(i)*temp >0
             angle_temp(i)=temp; 
        else
             angle_temp(i)=-temp; 
        end
   angle_temp = angle_temp';
    
end

