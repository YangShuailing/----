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
Point_Step = 0.01;% �ռ�����
Node_Number = 50; %�ڵ����
Anchor_Number = 3; % ê�ڵ����
Scale=1;%�����Ŵ�߶�
p_band=0.1;%%MSP�������Ǳ�����
min_bound = 0.1;  %% LP�����½磬ȱʧ�����ܹ���
max_bound = 10;
Node_All = Anchor_Number + Node_Number; % ��ͨ�ڵ� + ê�ڵ� 
RUNS = 50; %%�������
Acoustic_Number = 20; % ��Դ�ĸ���
Scan_Time = 6; %%ɨ�����
% cita=-90+180*(rand(1,Acoustic_Number));  %%���� [-90  90]  %%% ���Ⱥ���Դ�����й�ϵ
angle = [];
normal_min = 1;
normal_max=10;
normal_gap=1;
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

save Ini_Data.mat Size_Grid Room_Size  Microphone_Distance  r Point_Step Node_Number Anchor_Number Scale p_band  max_bound  min_bound Node_All RUNS Acoustic_Number Scan_Time  angle normal_min normal_gap normal_max;% Microphone_Center_Location Microphone_1_Location  Microphone_2_Location Anchor_Number;  
disp(sprintf('Ini_Data saved!\n'));