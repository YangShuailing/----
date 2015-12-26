

clc;
clear all  %清除 
close all; %关闭之前数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%%%  初始化数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
Size_Grid=10;  %房间大小，单位：m 
Length = Size_Grid; %% 房间的长度，单位：m 
Width = Size_Grid;  %% 房间的宽度，单位：m 
Microphone_Distance = 0.5; %手机上两个mic之间距离 （m)
r = Microphone_Distance/2;
Point_Step = 0.01;% 空间粒度
Node_Number = 5; %节点个数
Anchor_Number = 3; % 锚节点个数
p_band=0.1;%%MSP：不考虑保护带
% min_bound = 0.1;  %% LP的上下界，缺失将不能工作
% max_bound = 10;
RUNS = 50; %%仿真次数
Scan_Time = 6; %%扫描次数
% cita=-90+180*(rand(1,Acoustic_Number));  %%朝向 [-90  90]  %%% 精度和声源个数有关系
angle = [];
normal_min = 1;
normal_max=10;
normal_gap=1;
%%%%%%%生成麦克风位置朝向信息
Microphone_Cita=fix(360*(rand(Node_Number,1)));  %%朝向 [0 360] 以x正半轴与麦克风1的夹角上    

Microphone_Center_Location=fix(Size_Grid*abs(rand(Node_Number,2))); % 中心 位置
Anchor_Location = fix(Size_Grid*abs(rand(Anchor_Number,2)));  % 锚节点坐标
Anchor_Cita=fix(-90+180*(rand(Anchor_Number,1)));  %%锚节点朝向 [-90  90]  
Acoustic_Loc = Microphone_Center_Location ; % 声源位置
Microphone_1_Location=zeros(Node_Number,2); % 顶部 位置
Microphone_2_Location=zeros(Node_Number,2); % 底部 位置

for  i=1:Node_Number
%%(L/2,0)
Microphone_1_Location(i,1)=Microphone_Center_Location(i,1) + 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
Microphone_1_Location(i,2)=Microphone_Center_Location(i,2) + 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));  
 %%(-L/2,0)
Microphone_2_Location(i,1)=Microphone_Center_Location(i,1) - 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
Microphone_2_Location(i,2)=Microphone_Center_Location(i,2) - 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));        
end
for  i=1:Anchor_Number
%%(L/2,0)
Anchor_Microphone_1_Location(i,1)=Anchor_Location(i,1) + 0.5*Microphone_Distance*(cos(Anchor_Cita(i)*pi/180));
Anchor_Microphone_1_Location(i,2)=Anchor_Location(i,2) + 0.5*Microphone_Distance*(-sin(Anchor_Cita(i)*pi/180));  
 %%(-L/2,0)
Anchor_Microphone_2_Location(i,1)=Anchor_Location(i,1) - 0.5*Microphone_Distance*(cos(Anchor_Cita(i)*pi/180));
Anchor_Microphone_2_Location(i,2)=Anchor_Location(i,2) - 0.5*Microphone_Distance*(-sin(Anchor_Cita(i)*pi/180));        
end
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 画出节点位置
figure('Position',[1 1 900 900])
plot(Anchor_Microphone_1_Location(:,1),Anchor_Microphone_1_Location(:,2),'k.',Anchor_Microphone_2_Location(:,1),Anchor_Microphone_2_Location(:,2),'k.',Anchor_Location(:,1),Anchor_Location(:,2),'k.');
hold on;
plot(Microphone_1_Location(:,1),Microphone_1_Location(:,2),'r.',Microphone_2_Location(:,1),Microphone_2_Location(:,2),'b.',Microphone_Center_Location(:,1),Microphone_Center_Location(:,2),'k.');
hold on;
for i = 1:Anchor_Number
text(Anchor_Location(i,1)+0.3,Anchor_Location(i,2)+0.3,cellstr(num2str(i)));
end
for i = 1:Node_Number
text(Microphone_Center_Location(i,1)+0.3,Microphone_Center_Location(i,2)+0.3,cellstr(num2str(i)));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
node_normal=Microphone_Center_Location; % 普通节点中心坐标
node_anchor = Anchor_Location; % 锚节点坐标
Dual_Microphone=[Microphone_1_Location Microphone_2_Location]; %% Node_Number*4
% X_rank = calcul_rank(node_anchor,node_normal); % 生成序列号
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%依次发声

Scale=4;%网格点放大尺度
L_Grid = Scale*Size_Grid; %%离散化点的个数  
W_Grid = Scale*Size_Grid; %%离散化点的个数  
%生成离散点
AreaX = 0 : Length/L_Grid : Size_Grid;
AreaY = 0 : Width/W_Grid : Size_Grid;
for i=0:L_Grid
    for j=0:W_Grid
        Grid_all(i*(L_Grid+1)+j+1,1) = AreaX(i+1);
        Grid_all(i*(W_Grid+1)+j+1,2) = AreaY(j+1);
    end
end
%%说明：初始化box为区域内所有的点%%
for normal_counter = 1:Node_Number
    %%% update 
    
    %%%
    
   box(normal_counter).count=(L_Grid+1)*(W_Grid+1);
   box(normal_counter).x=Grid_all(:,1);
   box(normal_counter).y=Grid_all(:,2);
   box(normal_counter).flag=zeros(size(Grid_all(:,1)));

   for i = 1:360 
       %%% 用坐标信息来表示朝向角度
       %%% X = [box(normal_counter).a_x  box(normal_counter).a_y]表示以基点 
       %%% X0 = [box(normal_counter).x  box(normal_counter).y]的圆上的点
       box(normal_counter).a_x(:,i)= box(normal_counter).x+r*sin(i/360*2*pi);
       box(normal_counter).a_y(:,i)= box(normal_counter).y+r*sin(i/360*2*pi);
       box(normal_counter).angle_flag(i) = i;
   end
end


 
%%%% 位置修正
for i = 1 : Node_Number
    X0 = node_normal(i,:); %% 第i个节点真实位置
    for j = 1 : Anchor_Number 
        Xj_1 = Anchor_Microphone_1_Location(j,:); %% 第j个锚节点真实位置
        Xj_2 = Anchor_Microphone_2_Location(j,:); %% 第j个锚节点真实位置
        Anchor_flag(j) = calcul_flag( X0,Xj_1,Xj_2);%% 第i个普通节点发声，锚节点得到 0/1 信息。
        %%%% 根据节点i发声锚节点得到的0/1信息，对节点i的可行域进行切割，缩小第i个节点的范围
        for temp = 1 : box(i).count
            X_temp = [box(i).x(temp)  box(i).y(temp)];
            temp_flag(temp) = calcul_flag( X_temp ,Xj_1,Xj_2);
            if temp_flag(temp) == Anchor_flag
               box(i).flag(temp) = 1; %% 满足条件赋值为1
            else
                box(i).flag(temp) = 0; %% 满足条件赋值为1
            end
          %%%% 角度 
             for a = 1:360 
                 temp_loc = [box(normal_counter).a_x(temp,a) box(normal_counter).a_y(temp,a)];
                 temp_loc_flag = calcul_flag(temp_loc,Xj_1,Xj_2);
                 if temp_flag(temp) == Anchor_flag
                    box(normal_counter).angle_flag(temp,a) = 1;
                 else
                     box(normal_counter).angle_flag(temp,a) = 0;
                 end
             end
            
            
        end

     %%%% 根据 第i个节点发声，产生的序列（MSP）缩小第i个节点的范围
        for k = j+1:Anchor_Number 
            X1 = node_anchor(j,:);
            X2 = node_anchor(k,:);
            Between_Anchor_flag(j) = calcul_flag( X0,X1,X2); %% 锚节点之间的信息进行切割。
            for temp = 1 : box(i).count
                X_temp = [box(i).x(temp)  box(i).y(temp)];
                temp_flag(temp) = calcul_flag( X_temp ,Xj_1,Xj_2);
                if temp_flag(temp) == Anchor_flag
                   box(i).flag(temp) = 1; %% 满足条件赋值为1
                else
                   box(i).flag(temp) = 0; %% 满足条件赋值为1
                end
             end
        end
 
  
 
%          for m = i : Node_number
%             Xo_0 = node_normal(m,:); %% 第m个节点真实位置
%             Xm_1 = Microphone_1_Location(m,:);
%             Xm_2 = Microphone_2_Location(m,:);
%             mi_flag(j) = calcul_flag( X0,Xj_1,Xj_2);%% 第i个普通节点发声，锚节点得到 0/1 信息
%             
%          end
        
        
    end

end
%%% 画出节点修正区域
for count = 1 : Node_Number

        for temp = 1 : box(count).count
            if  box(count).flag(temp) == 1
                plot(box(count).x(temp),box(count).y(temp),'*');
                hold on;
                axis([-1 Size_Grid+1 -1 Size_Grid+1]) ;
            end
        end
end

