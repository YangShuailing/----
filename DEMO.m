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
Node_Number = 5; %节点个数
Anchor_Number = 3; % 锚节点个数
p_band=0.1;%%MSP：不考虑保护带
% min_bound = 0.1;  %% LP的上下界，缺失将不能工作
% max_bound = 10;
Node_All_Num = Anchor_Number + Node_Number; % 普通节点 + 锚节点 
RUNS = 50; %%仿真次数
Scan_Time = 6; %%扫描次数
% cita=-90+180*(rand(1,Acoustic_Number));  %%朝向 [-90  90]  %%% 精度和声源个数有关系
angle = [];
normal_min = 1;
normal_max=10;
normal_gap=1;
%%%%%%%生成麦克风位置朝向信息
Microphone_Cita=fix(-90+180*(rand(Node_All_Num,1)));  %%朝向 [-90  90]    
Microphone_Center_Location=fix(Size_Grid*abs(rand(Node_All_Num,2))); % 中心 位置
Acoustic_Loc = Microphone_Center_Location ; % 声源位置
Microphone_1_Location=zeros(Node_All_Num,2); % 顶部 位置
Microphone_2_Location=zeros(Node_All_Num,2); % 底部 位置

for  i=1:Node_All_Num
%%(L/2,0)
Microphone_1_Location(i,1)=Microphone_Center_Location(i,1) + 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
Microphone_1_Location(i,2)=Microphone_Center_Location(i,2) + 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));  
 %%(-L/2,0)
Microphone_2_Location(i,1)=Microphone_Center_Location(i,1) - 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
Microphone_2_Location(i,2)=Microphone_Center_Location(i,2) - 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));        
end
node_all=Microphone_Center_Location; % 节点中心坐标
Dual_Microphone=[Microphone_1_Location Microphone_2_Location]; %% Node_All_Num*4
node_anchor=node_all(1:Anchor_Number,:);  % 锚节点坐标
node_normal=node_all(Anchor_Number+1:end,:); % 普通节点坐标
X_rank = calcul_rank(node_anchor,node_all); % 生成序列号
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%依次发声
Length = Size_Grid;
Width = Size_Grid;
Scale=4;%网格点放大尺度
Length_S = 0;
Width_S = 0;
Length_E = Size_Grid;
Width_E = Size_Grid;
L_Grid = Scale*Size_Grid;   
W_Grid = Scale*Size_Grid;
%生成离散点
AreaX = Length_S : Length/L_Grid : Length_E;
AreaY = Width_S : Width/W_Grid : Width_E;
for i=0:L_Grid
    for j=0:W_Grid
        Grid_all(i*(L_Grid+1)+j+1,1) = AreaX(i+1);
        Grid_all(i*(W_Grid+1)+j+1,2) = AreaY(j+1);
    end
end
%%说明：初始化box为区域内所有的点%%
for normal_counter = 1:Node_Number
   box(normal_counter).count=(L_Grid+1)*(W_Grid+1);
   box(normal_counter).x=Grid_all(:,1);
   box(normal_counter).y=Grid_all(:,2);
   box(normal_counter).angle = [0,360];
   box(normal_counter).flag=ones(size(Grid_all(:,1)));
end


start = 1; % 从随机指定起始锚节点为1
%%%%依次发声
for i = 1 : Node_All_Num
    speaker = node_all(X_rank(start,:),:);
     binary_table = creat_binary_table(speaker, node_all, X_rank);
    
    for j = 1 : Node_Number-1
        
        
        
    end

end


















%    disp('***************************************************')
         for ii=1:scan_time
             if cita(ii)<-90
              X_rank(:,ii)=X_rank(end:-1:1,ii);
             end
         end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

debugc=1;
% disp('******************************************')
% disp('Step1: Del point using anchor:');
% disp('******************************************')
[box_after_anchor]= del_point_using_anchor(box,X_rank,Num_Achohor,Node_Number,scan_time,anchor_node,cita,PB_anchor,normal_node);  
  
if plotflag==1
plot_box(box_after_anchor,Node_Number,Num_Achohor,anchor_node,normal_node);
end

for k=1:Node_Number
count_after_anchor(k)=box_after_anchor(k).count;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% IMSP， 进一步删除点！！
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ax+by+c=0  y=tan(cita)x     -tan(cita)*x +1*y =0  a=-tan(cita)  b=1   a=-sin b=cos  
% d= -tan(cita)*x +1*y= -sin*x + cos*y 
%%%[x' y']=[c -s; s c] [x y]  y'就是距离   y'=-sin*x+cos*y

A = -tan(cita*pi/180);
b = 1;
%%%%%%%%%make sure exist data in box_after_anchor
disp('******************************************')
disp('Step2: IMSP:');
disp('******************************************')
order = zeros(1,Node_Number);
[box_a,box_b] = size(box_after_anchor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Jin %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count_loop=0;
while 1
    count_loop=count_loop+1;
    disp(['count_loop = ',num2str(count_loop)]);
    
    for i = 1:scan_time 
          %  disp(['SCAN_TIMES  = ',num2str(i)]);
        a = A(i);
		%%%删除锚节点后，重新排序，生成只有目标节点的sequence   
         order_normal_list=rank_only_normal_node(X_rank(:,i),scan_time,Num_Achohor,Node_Number); %% added by Naigao-10.13
         box_after_anchor=delpoint(order_normal_list,a,b,box_after_anchor,Length, Width,p_band,i); 
		 if plotflag==1
		 disp(['Sequence_index=',num2str(i)]);
		 plot_box(box_after_anchor,Node_Number,Num_Achohor,anchor_node,normal_node);
		 end
    end  %%%%%%%%%%%%%%%%%%%% for i = 1:SCAN_TIMES  
    
    box_after_del=box_after_anchor; %%%modify this bug!!  

for k=1:Node_Number
count_after_del(k)=box_after_del(k).count;
end
count_after_del;

    %当box行数不变时结束循环，即在边界在迭代过程中不可能进一步缩小的情况下
%       if count_loop == 2
%         break;
%        end    
    if count_after_del == count_after_anchor
        break;
    end
 count_after_anchor =  count_after_del; 
end  %% while 1

  
disp('Center of Gravity');
%经过节点过滤后，求剩余节点的坐标平均值为最后的估计位置
Est_MSP = [];
tmp = [];
tmp_1 = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j = 1:Node_Number
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
      for i = 1: box_after_del(j).count
          tmp = [tmp; box_after_del(j).x(i),box_after_del(j).y(i)]; 
      end    
    tmp_1 = [mean(tmp(:,1))  mean(tmp(:,2))];
    Est_MSP = [Est_MSP; j tmp_1];
    tmp = [];    
end  %%for j = 1:Node_Number
% 估计位置
%Est_MSP = [目标节点序号 目标节点横坐标 目标节点纵坐标] 3列
Est_Normal = [Est_MSP(:,2) Est_MSP(:,3)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    rank_tmp=order_list;
   
    for j=1:length(rank_tmp)
        if rank_tmp(j)<=Num_Achohor
            rank_tmp(j)=0;
        end
    end
    
        index = find (rank_tmp == 0);%标记需要删除的节点
        rank_tmp(index) = [];%删除节点
  
        for k=1:Node_Number
    order_normal_list(k)=rank_tmp(k)-Num_Achohor;
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plotflag=0;


%%%%%  3 1 2 4 5 
for sequence_index = 1:scan_time %% i:index of sequence 
  
  ss0 = X_rank(:,sequence_index);  
  ss0';
  %%%%%%% 锚节点到直线距离 
  a=-tan(cita(sequence_index)*pi/180);
  b=1; 
  
   for i=1:NUM_ANCHOR
      distance_anchor_line(i)=point2line(anchor_node(i,1),anchor_node(i,2),a,b,0); 
   end
%%%%%%%%%%%%%% 加入-max  +max, 让每个目标节点都有前后锚节点，便于后续处理！！
%%网格边界点到直线的距离
distance_anchor_line(NUM_ANCHOR+1)=-100;
distance_anchor_line(NUM_ANCHOR+2)=+100;

[xx,idx]=sort(distance_anchor_line);

%%%%%%%%%% 根据锚节点在序列中的位置分组     节点序号   前锚节点序号  后锚节点序号 
group=[]; 
group_index = 1;
anchor_group(group_index)=NUM_ANCHOR+1;

%%%%%%%% 锚节点序号
  for i = 1:NUM_NORMAL+NUM_ANCHOR
        if(ss0(i)  <= NUM_ANCHOR)        
          group_index= group_index + 1;
          anchor_group(group_index)=ss0(i);
        end
  end
  
anchor_group(group_index+1)=NUM_ANCHOR+2;
group_index=1;

  for i = 1:NUM_NORMAL+NUM_ANCHOR
    if(ss0(i) > NUM_ANCHOR)
        group = [group; ss0(i) anchor_group(group_index)  anchor_group(group_index+1) ];    
    else
        group_index=group_index+1;
    end   

  end

%%%%%%%%%%%%%%%%%%%%%%%%%%% 更新box
     for group_num=1:NUM_NORMAL
         iindex=group(group_num,1)-NUM_ANCHOR;      
         for k = 1:box(iindex).count 
              x0=box(iindex).x(k);
               y0=box(iindex).y(k);
               dis = point2line(x0,y0,a,b,0) ;     
               
                min_index=group(group_num,2);
               mmin = distance_anchor_line(min_index);
                max_index=group(group_num,3);  
               mmax =  distance_anchor_line(max_index);
        
                if(dis < mmin-PB_anchor || dis > mmax + PB_anchor )
                   box(iindex).flag(k) = 0;                
                end       
         end
      
            index = find (box(iindex).flag(:) == 0);%标记需要删除的节点
            box(iindex).count =  box(iindex).count - length(index);
         if(box(iindex).count == 0)
               disp('****************************')
               disp(['node ',num2str(iindex),'  is keeped!'])
			   disp(['sequence: ',num2str(sequence_index)]);
               disp('****************************')     
               box(iindex).flag(index) = 1; %%%%change by jin  10.16  
               box(iindex).count =  box(iindex).count + length(index);
         else      
            box(iindex).x(index) = [];%删除节点
            box(iindex).y(index) = [];
            box(iindex).flag(index) = [];
         end
          
     end      %%%for group_num=1:NUM_NORMAL

if plotflag==1
    plot_box(box,NUM_NORMAL,NUM_ANCHOR,anchor_node,normal_node);
end

end  %%%for sequence_index = 1:scan_time


