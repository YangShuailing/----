% main function
clc;
clear all  %清除 
close all; %关闭之前数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
load('Ini_Data.mat') ;   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Acoustic_Loc = fix(Size_Grid*abs((rand(Acoustic_Number,2))));%声源位置已知，目前声源随机产生，可以更改为节点上speaker的坐标（手机上speaker位置还没确定）。
% %%% 画声源节点
%  plot(Acoustic_Loc(:,1),Acoustic_Loc(:,2),'k*');
%  hold on; 
 rmse_angle_tmp=zeros(RUNS,1);
 rmse_msp_tmp =zeros(RUNS,1);
for runs = 1:RUNS 
        disp(['runs = ',num2str(runs)]);
        disp(['---------- ']);        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%生成麦克风位置朝向信息
   
    Microphone_Cita=fix(-90+180*(rand(Node_All,1)));  %%朝向 [-90  90]    
    Microphone_Center_Location=fix(Size_Grid*abs(rand(Node_All,2))); % 中心 位置
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
%     for  scans =normal_min:normal_gap:normal_max;
       
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% 画出节点位置
% disp('Microphone1: ');
% disp(Microphone_1_Location);
% disp('**********************************************');
% disp('Microphone2: ');
% disp(Microphone_2_Location);
% disp('**********************************************');
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
    cita=-90:180/(Scan_Time-1):90; %%%  change 10.12 maybe need further consider!!!
    S=[-sin(cita*pi/180);cos(cita*pi/180)];  
    X_new=Xnode_All*S;    
    [Xa,X_rank]=sort(X_new,1);  
%  %%%% 估计朝向信息
  [angle_temp ] = Angle_EDSNL( Node_All,Microphone_Distance,Point_Step,Xnode_All,Node_Location,Acoustic_Loc,Acoustic_Number,Microphone_Cita);
%    [angle_temp Microphone_Cita]
  rmse_angle_tmp(runs)  = sqrt(sum(angle_temp-Microphone_Cita).^2 / Node_Number);   %
  %%%%%%% 估计位置
%   xxest_msp= MSP_EDSNL(Anchor_Number,Node_Number,Scan_Time,Xanchor,X_rank,cita,p_band,Xnode) ;
% plot_fig_msp(Xnode,xxest_msp,Xanchor,Node_Number,Anchor_Number,Size_Grid); 
%   rmse_msp_tmp(runs)  = sqrt(sum((xxest_msp(:)- Xnode(:)).^2) / Node_Number );   %
%    rmse_tmp =  rmse_msp_tmp(runs)
  
% end

end
%  rmse_msp_tmp
%  rmse_angle_tmp

%  % 用 mode 函数来剔除异常值
% [m,n] = size(angle_temp);
% for i =1:n
%     [k,l] = mode(angle_temp(:,i)); % k、l分别代表众数和众数的频数
%     angle(i)=k;
% end
 save Nl_result.mat  RUNS Size_Grid Node_Number Anchor_Number     rmse_angle_tmp;
% save Nl_result.mat  RUNS Size_Grid Node_Number Anchor_Number  rmse_angle_tmp  rmse_msp_tmp;
disp(sprintf('The_Loc_Result saved!\n'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% figure('Position',[1 1 400 300])
% box on
% plot(Node_Number, rmse_msp_tmp, 'r-', 'LineWidth', 2, 'MarkerFaceColor', 'r');
% hold on;
% plot(Node_Number, rmse_angle_tmp, 'b^', 'LineWidth', 2, 'MarkerFaceColor', 'b');% 
% hold off;
% legend(' MSP','Angle');
% % legend('\fontsize{12}\bf MSP','\fontsize{12}\bf Angle');
% xlabel('\fontsize{12}\bf m');
% ylabel('\fontsize{12}\bf Localization Error(in units)');
% %title('\fontsize{6}\bf Error VS Number of Target Nodes');
% % axis([Node_Number(1),Node_Number(length(Node_Number)),0,max(max(rmse_IMSP_Anchors_MC,rmse_LP_Anchors_MC))+1]);
