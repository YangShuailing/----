% main function
clc;
clear all  %清除 
close all; %关闭之前数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%%%  初始化数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
load('Ini_Data.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Acoustic_Loc = fix(Size_Grid*abs((rand(Acoustic_Number,2))));%声源位置已知，目前声源随机产生，可以更改为节点上speaker的坐标（手机上speaker位置还没确定）。
% %%% 画声源节点
%  plot(Acoustic_Loc(:,1),Acoustic_Loc(:,2),'k*');
%  hold on; 
 rmse_angle_tmp=zeros(RUNS,1);
 rmse_msp_tmp =zeros(RUNS,1);
for runs = 1:1%RUNS 
    disp(['runs = ',num2str(runs)]);
    disp(['---------- ']);        
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%生成麦克风位置朝向信息
%     Microphone_Cita=fix(-90+180*(rand(Node_All,1)));  %%朝向 [-90  90]    
%     Microphone_Center_Location=fix(Size_Grid*abs(rand(Node_All,2))); % 中心 位置
%     Microphone_1_Location=zeros(Node_All,2); % 顶部 位置
%     Microphone_2_Location=zeros(Node_All,2); % 底部 位置
%     for  i=1:Node_All
%         %%(L/2,0)
%         Microphone_1_Location(i,1)=Microphone_Center_Location(i,1) + 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
%         Microphone_1_Location(i,2)=Microphone_Center_Location(i,2) + 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));  
%          %%(-L/2,0)
%         Microphone_2_Location(i,1)=Microphone_Center_Location(i,1) - 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
%         Microphone_2_Location(i,2)=Microphone_Center_Location(i,2) - 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));        
%     end
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% 画出节点位置
%     disp('Microphone1: ');
%     disp(Microphone_1_Location);
%     disp('**********************************************');
%     disp('Microphone2: ');
%     disp(Microphone_2_Location);
%     disp('**********************************************');
    figure('Position',[1 1 900 900])
    plot(Microphone_1_Location(1:3,1),Microphone_1_Location(1:3,2),'r.',Microphone_2_Location(1:3,1),Microphone_2_Location(1:3,2),'b.',Microphone_Center_Location(1:3,1),Microphone_Center_Location(1:3,2),'k.');
    hold on;
    for i = 1:10
    text(Microphone_Center_Location(i,1)+0.3,Microphone_Center_Location(i,2)+0.3,cellstr(num2str(i)));
    end

    plot(Microphone_1_Location(4:Node_All,1),Microphone_1_Location(4:Node_All,2),'r.',Microphone_2_Location(4:Node_All,1),Microphone_2_Location(4:Node_All,2),'b.',Microphone_Center_Location(4:Node_All,1),Microphone_Center_Location(4:Node_All,2),'k.');
    axis([-1 Size_Grid+1 -1 Size_Grid+1]) ;
    hold on;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Node_Location=Microphone_Center_Location; % 节点中心坐标
    Mic_Location =[Microphone_1_Location Microphone_2_Location]; %% 33*4
    Xanchor=Node_Location(1:Anchor_Number,:);  % 锚节点坐标
    Anchor_Cita = Microphone_Cita(1:Anchor_Number,:);% 锚节点朝向
    Xnode=Node_Location(Anchor_Number+1:Node_All,:); % 普通节点坐标
    cita=-90:180/(Scan_Time-1):90; %%%  change 10.12 maybe need further consider!!!
    S=[-sin(cita*pi/180);cos(cita*pi/180)];  
    X_new=Node_Location*S;    
    [Xa,X_rank]=sort(X_new,1);  
    L=Microphone_Distance;%%一个phone上两个microphone距离
    k = 1;%参数
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for  i=1:Node_All
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PhoneA  
%             %%(L/2,0)
%             Microphone_1_Location(i,1)=Microphone_Center_Location(i,1) + 0.5*Microphone_Distance;
%             Microphone_1_Location(i,2)=Microphone_Center_Location(i,2) + 0.5*Microphone_Distance;  
%             %%(-L/2,0)
%             Microphone_2_Location(i,1)=Microphone_Center_Location(i,1) - 0.5*Microphone_Distance;
%             Microphone_2_Location(i,2)=Microphone_Center_Location(i,2) - 0.5*Microphone_Distance; 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%phoneA 的speaker坐标
            speaker1_x=Microphone_Center_Location(i,1);
            speaker1_y=Microphone_Center_Location(i,2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            for  j=i+1:Node_All
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PhoneB 
%                         %%(L/2,0)
%                     Microphone_11_Location(j,1)=Microphone_Center_Location(j,1) + 0.5*Microphone_Distance;
%                     Microphone_11_Location(j,2)=Microphone_Center_Location(j,2) + 0.5*Microphone_Distance;  
%                     %%(-L/2,0)
%                     Microphone_22_Location(j,1)=Microphone_Center_Location(j,1) - 0.5*Microphone_Distance;
%                     Microphone_22_Location(j,2)=Microphone_Center_Location(j,2) - 0.5*Microphone_Distance;  
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%phoneB 的speaker坐标
                   speaker2_x=Microphone_Center_Location(j,1);
                   speaker2_y=Microphone_Center_Location(j,2);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Microphone坐标
                     Microphone1_1=Microphone_1_Location(i,1);
                     Microphone1_2=Microphone_1_Location(i,2);%%%A1
                     Microphone2_1=Microphone_2_Location(i,1);
                     Microphone2_2=Microphone_2_Location(i,2);%%%A2        
                     Microphone3_1=Microphone_1_Location(j,1);
                     Microphone3_2=Microphone_1_Location(j,2);%%%B1         
                     Microphone4_1=Microphone_2_Location(j,1);
                     Microphone4_2=Microphone_2_Location(j,2);%%%B2
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Sab1代表a为声源到b的第一个麦克风的距离
                     Sab1=sqrt((speaker1_x-Microphone3_1)^2+(speaker1_y-Microphone3_2)^2);
                     Sab2=sqrt((speaker1_x-Microphone4_1)^2+(speaker1_y-Microphone4_2)^2);
                     Sba1=sqrt((speaker2_x-Microphone1_1)^2+(speaker2_y-Microphone1_2)^2);
                     Sba2=sqrt((speaker2_x-Microphone2_1)^2+(speaker2_y-Microphone2_2)^2);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%两个声源A-B真实距离      
                     speaker_to_speaker = sqrt((speaker1_x-speaker2_x)^2+(speaker1_y-speaker2_y)^2);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%计算
                     daa=Microphone_Distance/2;
                     dbb=Microphone_Distance/2;%%%一个手机上两个麦克风之间的距离
                     Sa11=daa+rand(2)-0.5; %% 距离 加误差 正负0.5 
                     Sa21=daa+rand(2)-0.5;
                     Sb13=daa+rand(2)-0.5;
                     Sb23=daa+rand(2)-0.5;
                     a=0;
                     b=0;
                     c=0;
                     d=0;
            if Sab1>=Sba2    
                    a = Sab1;
                    d = Sba2;           
                else  
                    d = Sab1;
                    a = Sba2;
            end
            if Sba1>=Sab2
                    b = Sba1;
                    c = Sab2;    
                else
                   c = Sba1;
                   b = Sab2;
            end       
            TDOA1 = abs(d-a);%% TDOA 值
            TDOA2 = abs(b-c);%%
            M = a+b+c+d;%%%%%%基于beepbeep
            cosa = TDOA2/L;
            cosb = TDOA1/L;
            Q=(TDOA1+TDOA2+M)/2;
            C = (Q*L*cosb-Q^2)/(L*cosb+L*cosa-2*Q);
            % C=c;
            A = Q-C;
            B = C-TDOA2;
            D = A+TDOA1;
            my1 = sqrt(C^2+(L/2)^2-2*C*(L/2)*cosa);
            my2 = sqrt(A^2+(L/2)^2-2*A*(L/2)*cosb);
            my = (my1+my2)/2;%%%实测两个声源的距离
            beep= (a+d+c+d)/4;

            Beep(k)  = beep;
            My(k) = my;
            % rmse_beep = norm(speaker_to_speaker-beep);
            % rmse_my = norm(speaker_to_speaker-my1);
            % Rmse_beep(k) = rmse_beep;
            % Rmse_my(k)= rmse_my;
            Speaker_to_speaker(k)=speaker_to_speaker;
            k=k+1;
        end
    end
    
    est_mds_my= mds_node(Microphone_Center_Location+0.2,My);
    est_mds_beep=mds_node(Microphone_Center_Location,Beep); %mds得到的坐标

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% my算法定出的节点坐标
%
% for  m=1:Node_All
% plot(est_mds_my(m,1),est_mds_my(m,2),'*r')
% hold on
% plot(Microphone_Center_Location(m,1),Microphone_Center_Location(m,2),'.k')
% 
%  legend( 'Our method localization','Node Location');
% end
  
%  %%%% 估计朝向信息
  [angle_temp box] = Angle_EDSL(Node_All,Scale,Point_Step,est_mds_my,Mic_Location,Microphone_Cita);
%   
%       [angle_temp box] = Angle_EDSNL( Node_All,Microphone_Distance,Scale,Node_Location,Mic_Location);
%    [angle_temp Microphone_Cita]
%   rmse_angle_tmp(runs)  = sqrt(sum(angle_temp-Microphone_Cita).^2 / Node_Number);   %
%   %%%%%%% 估计位置
%   xxest_msp= MSP_EDSNL(Anchor_Number,Node_Number,Scan_Time,Xanchor,X_rank,cita,p_band,Xnode) ;
%   plot_fig_msp(Xnode,xxest_msp,Xanchor,Node_Number,Anchor_Number,Size_Grid); 
%   rmse_msp_tmp(runs)  = sqrt(sum((xxest_msp(:)- Xnode(:)).^2) / Node_Number );   %
%    rmse_tmp =  rmse_msp_tmp(runs)
  
end
%  rmse_msp_tmp
%  rmse_angle_tmp

%  % 用 mode 函数来剔除异常值
% [m,n] = size(angle_temp);
% for i =1:n
%     [k,l] = mode(angle_temp(:,i)); % k、l分别代表众数和众数的频数
%     angle(i)=k;
% end
%  save Nl_result.mat  RUNS Size_Grid Node_Number Anchor_Number     rmse_angle_tmp;
save Nl_result.mat  RUNS Size_Grid Node_Number Anchor_Number  rmse_angle_tmp  rmse_msp_tmp;
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
