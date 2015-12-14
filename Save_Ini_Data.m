% Ini_Data
clc;
clear all  %清除 
close all; %关闭之前数据


%%%%  初始化数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
Size_Grid=10;  %房间大小，单位：m 
Room_Size = [Size_Grid Size_Grid];
Microphone_Distance = 0.5; %手机上两个mic之间距离 （m)
r = Microphone_Distance/2;
Point_Step = 0.01;% 空间粒度
Node_Number = 50; %节点个数
Anchor_Number = 3; % 锚节点个数
Scale=1;%网格点放大尺度
p_band=0.1;%%MSP：不考虑保护带
min_bound = 0.1;  %% LP的上下界，缺失将不能工作
max_bound = 10;
Node_All = Anchor_Number + Node_Number; % 普通节点 + 锚节点 
RUNS = 50; %%仿真次数
Acoustic_Number = 20; % 声源的个数
Scan_Time = 6; %%扫描次数
% cita=-90+180*(rand(1,Acoustic_Number));  %%朝向 [-90  90]  %%% 精度和声源个数有关系
angle = [];
normal_min = 1;
normal_max=10;
normal_gap=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 初始化变量
% Length = Size_Grid;
% Width = Size_Grid;
% Scale=2;%网格点放大尺度
% %区域起点与终点坐标
% LENGTH_S = 0;
% WIDTH_S = 0;
% LENGTH_E = Size_Grid;
% WIDTH_E = Size_Grid;
% LGRID = Scale*Size_Grid;  %200 speed too slow!
% WGRID = Scale*Size_Grid;
% %生成离散点
% AreaX = LENGTH_S : Length/LGRID : LENGTH_E;
% AreaY = WIDTH_S : Width/WGRID : WIDTH_E;

save Ini_Data.mat Size_Grid Room_Size  Microphone_Distance  r Point_Step Node_Number Anchor_Number Scale p_band  max_bound  min_bound Node_All RUNS Acoustic_Number Scan_Time  angle normal_min normal_gap normal_max;% Microphone_Center_Location Microphone_1_Location  Microphone_2_Location Anchor_Number;  
disp(sprintf('Ini_Data saved!\n'));