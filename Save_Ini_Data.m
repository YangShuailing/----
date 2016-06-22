% Ini_Data
clc;
clear all  %��� 
close all; %�ر�֮ǰ����


%%%%  ��ʼ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
Size_Grid=10;  %�����С����λ��m 
Room_Size = [Size_Grid Size_Grid];
Microphone_Distance = 0.5; %�ֻ�������mic֮����� ��m)
r = Microphone_Distance/2;
Point_Step = 0.1;% �ռ�����
Node_Number = 7; %�ڵ����
Anchor_Number = 3; % ê�ڵ����
Scale=1;%�����Ŵ�߶�
p_band=0.1;%%MSP�������Ǳ�����
min_bound = 0.1;  %% LP�����½磬ȱʧ�����ܹ���
max_bound = 10;
Node_All = Anchor_Number + Node_Number; % ��ͨ�ڵ� + ê�ڵ� 
RUNS = 200; %%�������
% Acoustic_Number = 20; % ��Դ�ĸ���
Scan_Time = 6; %%ɨ�����
% cita=-90+180*(rand(1,Acoustic_Number));  %%���� [-90  90]  %%% ���Ⱥ���Դ�����й�ϵ
angle = [];
normal_min = 1;
normal_max=10;
normal_gap=1;
% Acoustic_Loc = fix(Size_Grid*abs((rand(Acoustic_Number,2))));%��Դλ����֪��Ŀǰ��Դ������������Ը���Ϊ�ڵ���speaker�����꣨�ֻ���speakerλ�û�ûȷ������

Microphone_Cita=fix(-90+180*(rand(Node_All,1)));  %%���� [-90  90]    
Microphone_Center_Location=fix(Size_Grid*abs(rand(Node_All,2))); % ���� λ��
Microphone_1_Location=zeros(Node_All,2); % ���� λ��
Microphone_2_Location=zeros(Node_All,2); % �ײ� λ��
    for  i=1:Node_All
        %%(L/2,0)
        Microphone_1_Location(i,1)=Microphone_Center_Location(i,1) + 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
        Microphone_1_Location(i,2)=Microphone_Center_Location(i,2) + 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));  
         %%(-L/2,0)
        Microphone_2_Location(i,1)=Microphone_Center_Location(i,1) - 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
        Microphone_2_Location(i,2)=Microphone_Center_Location(i,2) - 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));        
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ��ʼ������
% Length = Size_Grid;
% Width = Size_Grid;
% Scale=2;%�����Ŵ�߶�
% %����������յ�����
% LENGTH_S = 0;
% WIDTH_S = 0;
% LENGTH_E = Size_Grid;
% WIDTH_E = Size_Grid;
% LGRID = Scale*Size_Grid;  %200 speed too slow!
% WGRID = Scale*Size_Grid;
% %������ɢ��
% AreaX = LENGTH_S : Length/LGRID : LENGTH_E;
% AreaY = WIDTH_S : Width/WGRID : WIDTH_E;

save Ini_Data.mat Size_Grid Room_Size  Microphone_Distance  r Point_Step Node_Number Anchor_Number Scale p_band  max_bound  min_bound Node_All RUNS  Scan_Time  angle normal_min normal_gap normal_max Microphone_Center_Location  Microphone_1_Location  Microphone_2_Location Anchor_Number Microphone_Cita;  
disp(sprintf('Ini_Data saved!\n'));