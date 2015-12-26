clc;
clear all  %��� 
close all; %�ر�֮ǰ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%%%  ��ʼ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
Size_Grid=10;  %�����С����λ��m 
Length = Size_Grid; %% ����ĳ��ȣ���λ��m 
Width = Size_Grid;  %% ����Ŀ�ȣ���λ��m 
Microphone_Distance = 0.5; %�ֻ�������mic֮����� ��m)
r = Microphone_Distance/2;
Point_Step = 0.01;% �ռ�����
Node_Number = 5; %�ڵ����
Anchor_Number = 3; % ê�ڵ����
p_band=0.1;%%MSP�������Ǳ�����
% min_bound = 0.1;  %% LP�����½磬ȱʧ�����ܹ���
% max_bound = 10;
RUNS = 50; %%�������
Scan_Time = 6; %%ɨ�����
% cita=-90+180*(rand(1,Acoustic_Number));  %%���� [-90  90]  %%% ���Ⱥ���Դ�����й�ϵ
angle = [];
normal_min = 1;
normal_max=10;
normal_gap=1;
%%%%%%%������˷�λ�ó�����Ϣ
Microphone_Cita=fix(360*(rand(Node_Number,1)));  %%���� [0 360] ��x����������˷�1�ļн���    

Microphone_Center_Location=fix(Size_Grid*abs(rand(Node_Number,2))); % ���� λ��
Anchor_Location = fix(Size_Grid*abs(rand(Anchor_Number,2)));  % ê�ڵ�����
Anchor_Cita=fix(-90+180*(rand(Anchor_Number,1)));  %%ê�ڵ㳯�� [-90  90]  
Acoustic_Loc = Microphone_Center_Location ; % ��Դλ��
Microphone_1_Location=zeros(Node_Number,2); % ���� λ��
Microphone_2_Location=zeros(Node_Number,2); % �ײ� λ��

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
% %%%% �����ڵ�λ��
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


