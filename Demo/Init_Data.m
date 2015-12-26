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
% %%%% 画出节点位置
% figure('Position',[1 1 900 900])
% plot(Anchor_Microphone_1_Location(:,1),Anchor_Microphone_1_Location(:,2),'r*',Anchor_Microphone_2_Location(:,1),Anchor_Microphone_2_Location(:,2),'b*',Anchor_Location(:,1),Anchor_Location(:,2),'k*');
% hold on;
% plot(Microphone_1_Location(:,1),Microphone_1_Location(:,2),'r.',Microphone_2_Location(:,1),Microphone_2_Location(:,2),'b.',Microphone_Center_Location(:,1),Microphone_Center_Location(:,2),'k.');
% hold on;
% for i = 1:Anchor_Number
% text(Anchor_Location(i,1)+0.3,Anchor_Location(i,2)+0.3,cellstr(num2str(i)));
% end
% for i = 1:Node_Number
% text(Microphone_Center_Location(i,1)+0.3,Microphone_Center_Location(i,2)+0.3,cellstr(num2str(i)));
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


