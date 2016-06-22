% main function
clc;
clear all  %清除 
close all; %关闭之前数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%%%  初始化数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
Size_Grid=10;  %房间大小，单位：m 
Room_Size = [Size_Grid Size_Grid];
Microphone_Distance = 0.5; %手机上两个mic之间距离 （m)
r = Microphone_Distance/2;
Point_Step = 0.01;% 空间粒度
Node_Number = 20; %节点个数
Anchor_Number = 3; % 锚节点个数
Scale=4;%网格点放大尺度
p_band=0.1;%%MSP：不考虑保护带
min_bound = 0.1;  %% LP的上下界，缺失将不能工作
max_bound = 10;
Node_All = Anchor_Number + Node_Number; % 普通节点 + 锚节点 
RUNS = 10; %%仿真次数
Acoustic_Number = 20+ Node_Number; % 声源的个数
Scan_Time = 20;
% cita=-90+180*(rand(1,Acoustic_Number));  %%朝向 [-90  90]  %%% 精度和声源个数有关系
angle = [];
normal_min = 1;
normal_max=10;
normal_gap=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 初始化变量
Size = Microphone_Distance;
Length = Microphone_Distance;
Width = Microphone_Distance;

% Scale=4;%网格点放大尺度
L_Grid = Scale*Scale; %%离散化点的个数  
W_Grid = Scale*Scale; %%离散化点的个数  
%生成离散点
AreaX = 0 : Length/L_Grid : Size;
AreaY = 0 : Width/W_Grid : Size;
for i=0:L_Grid
    for j=0:W_Grid
        Grid_all(i*(L_Grid+1)+j+1,1) = AreaX(i+1);
        Grid_all(i*(W_Grid+1)+j+1,2) = AreaY(j+1);
    end
end

for normal_counter = 1:Node_All
   box(normal_counter).count=(L_Grid+1)*(W_Grid+1);
   box(normal_counter).x=Grid_all(:,1);
   box(normal_counter).y=Grid_all(:,2);
   box(normal_counter).flag=ones(size(Grid_all(:,1)));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

for runs = 1:RUNS 
    
        disp(['runs = ',num2str(runs)]);
        disp(['---------- ']);        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
Acoustic_Loc1 = fix(Size_Grid*abs((rand(Acoustic_Number,2))));%声源位置已知，目前声源随机产生，可以更改为节点上speaker的坐标（手机上speaker位置还没确定）。
% %%% 画声源节点
%  plot(Acoustic_Loc(:,1),Acoustic_Loc(:,2),'k*');
%  hold on; 
 rmse_angle_tmp=zeros(RUNS,1);
 rmse_msp_tmp =zeros(RUNS,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%生成麦克风位置朝向信息
    Microphone_Cita=fix(-90+180*(rand(Node_All,1)));  %%朝向 [-90  90]    
    Microphone_Center_Location=fix(Size_Grid*abs((rand(Node_All,2)))); % 中心 位置
    Microphone_1_Location=zeros(Node_All,2); % 顶部 位置
    Microphone_2_Location=zeros(Node_All,2); % 底部 位置
    for  i=1:Node_All
        %%(L/2,0)
        Microphone_1_Location(i,1)=Microphone_Center_Location(i,1) + 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
        Microphone_1_Location(i,2)=Microphone_Center_Location(i,2) + 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));  
         %%(-L/2,0)
        Microphone_2_Location(i,1)=Microphone_Center_Location(i,1) - 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
        Microphone_2_Location(i,2)=Microphone_Center_Location(i,2) - 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));        
    end
 Acoustic_Loc =  [Acoustic_Loc1;Microphone_1_Location];   
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% 画出节点位置
% % disp('Microphone1: ');
% % % disp(Microphone_1_Location);
% % disp('**********************************************');
% % disp('Microphone2: ');
% % % disp(Microphone_2_Location);
% % disp('**********************************************');
% figure('Position',[1 1 900 900])
% plot(Microphone_1_Location(1:3,1),Microphone_1_Location(1:3,2),'r.',Microphone_2_Location(1:3,1),Microphone_2_Location(1:3,2),'b.',Microphone_Center_Location(1:3,1),Microphone_Center_Location(1:3,2),'k.');
% hold on;
% for i = 1:3
% text(Microphone_Center_Location(i,1)+0.3,Microphone_Center_Location(i,2)+0.3,cellstr(num2str(i)));
% end
% plot(Microphone_1_Location(4:Node_All,1),Microphone_1_Location(4:Node_All,2),'r.',Microphone_2_Location(4:Node_All,1),Microphone_2_Location(4:Node_All,2),'b.',Microphone_Center_Location(4:Node_All,1),Microphone_Center_Location(4:Node_All,2),'k.');
% axis([-1 Size_Grid+1 -1 Size_Grid+1]) ;
% hold on;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Xnode_All=Microphone_Center_Location; % 节点中心坐标
    Node_Location =[Microphone_1_Location Microphone_2_Location]; %% 33*4
    Xanchor=Xnode_All(1:Anchor_Number,:);  % 锚节点坐标
    Xnode=Xnode_All(Anchor_Number+1:Node_All,:); % 普通节点坐标
    XCita = Microphone_Cita(Anchor_Number+1:Node_All,:);
    Xnode_Mic1=Microphone_1_Location(Anchor_Number+1:Node_All,:); % 普通节点坐标麦克风1位置
    cita=-90:180/(Scan_Time-1):90; %%%  change 10.12 maybe need further consider!!!
    S=[-sin(cita*pi/180);cos(cita*pi/180)];  
    X_new=Xnode_All*S;    
    [Xa,X_rank]=sort(X_new,1);  
%  %%%% 估计朝向信息
  box1 = Angle_EDSNL( Node_All,Microphone_Distance,Scale,Xnode_All,Node_Location,Acoustic_Loc,Acoustic_Number);
%   %%%%%%% 估计位置
  box2 =  Loc_EDSNL(Anchor_Number,Node_Number,Scan_Time,Xanchor,X_rank,cita,p_band,Xnode) ;
  [ xxest,angle_temp] = improve( box1, box2,Xnode,Xnode_Mic1,XCita);
  
 %  % 用 mode 函数来剔除异常值
[m,n] = size(angle_temp);
for i =1:n
    [k,l] = mode(angle_temp(:,i)); % k、l分别代表众数和众数的频数
    angle(i)=k;
end

%   plot_fig_msp(Xnode,xxest_msp,Xanchor,Node_Number,Anchor_Number,Size_Grid); 
rmse_angle_tmp(runs)  = sqrt(sum(angle_temp-XCita).^2 / Node_Number);   %
rmse_msp_tmp(runs)  = sqrt(sum((xxest(:)- Xnode(:)).^2) / Node_Number );   %
 
  
end



%  rmse_msp_tmp


save result.mat  RUNS Size_Grid Node_Number Anchor_Number  rmse_angle_tmp  rmse_msp_tmp;
disp(sprintf('The_Loc_Result saved!\n'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
figure('Position',[1 1 400 300])
 
plot(Node_Number, rmse_msp_tmp, 'r-', 'LineWidth', 2, 'MarkerFaceColor', 'r');
hold on;
plot(Node_Number, rmse_angle_tmp, 'b^', 'LineWidth', 2, 'MarkerFaceColor', 'b');% 
hold off;
legend(' MSP','Angle');
% legend('\fontsize{12}\bf MSP','\fontsize{12}\bf Angle');
xlabel('\fontsize{12}\bf m');
ylabel('\fontsize{12}\bf Localization Error(in units)');
title('\fontsize{12}\bf Error VS Number of Target Nodes');
% axis([Node_Number(1),Node_Number(length(Node_Number)),0,max(max(rmse_msp_tmp,rmse_angle_tmp))+1]);
