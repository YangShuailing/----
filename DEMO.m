clc;
clear all  %��� 
close all; %�ر�֮ǰ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%%%  ��ʼ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
Size_Grid=10;  %�����С����λ��m 
Room_Size = [Size_Grid Size_Grid];
Microphone_Distance = 0.5; %�ֻ�������mic֮����� ��m)
r = Microphone_Distance/2;
Point_Step = 0.01;% �ռ�����
Node_Number = 5; %�ڵ����
Anchor_Number = 3; % ê�ڵ����
p_band=0.1;%%MSP�������Ǳ�����
% min_bound = 0.1;  %% LP�����½磬ȱʧ�����ܹ���
% max_bound = 10;
Node_All_Num = Anchor_Number + Node_Number; % ��ͨ�ڵ� + ê�ڵ� 
RUNS = 50; %%�������
Scan_Time = 6; %%ɨ�����
% cita=-90+180*(rand(1,Acoustic_Number));  %%���� [-90  90]  %%% ���Ⱥ���Դ�����й�ϵ
angle = [];
normal_min = 1;
normal_max=10;
normal_gap=1;
%%%%%%%������˷�λ�ó�����Ϣ
Microphone_Cita=fix(-90+180*(rand(Node_All_Num,1)));  %%���� [-90  90]    
Microphone_Center_Location=fix(Size_Grid*abs(rand(Node_All_Num,2))); % ���� λ��
Acoustic_Loc = Microphone_Center_Location ; % ��Դλ��
Microphone_1_Location=zeros(Node_All_Num,2); % ���� λ��
Microphone_2_Location=zeros(Node_All_Num,2); % �ײ� λ��

for  i=1:Node_All_Num
%%(L/2,0)
Microphone_1_Location(i,1)=Microphone_Center_Location(i,1) + 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
Microphone_1_Location(i,2)=Microphone_Center_Location(i,2) + 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));  
 %%(-L/2,0)
Microphone_2_Location(i,1)=Microphone_Center_Location(i,1) - 0.5*Microphone_Distance*(cos(Microphone_Cita(i)*pi/180));
Microphone_2_Location(i,2)=Microphone_Center_Location(i,2) - 0.5*Microphone_Distance*(-sin(Microphone_Cita(i)*pi/180));        
end
node_all=Microphone_Center_Location; % �ڵ���������
Dual_Microphone=[Microphone_1_Location Microphone_2_Location]; %% Node_All_Num*4
node_anchor=node_all(1:Anchor_Number,:);  % ê�ڵ�����
node_normal=node_all(Anchor_Number+1:end,:); % ��ͨ�ڵ�����
X_rank = calcul_rank(node_anchor,node_all); % �������к�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���η���
Length = Size_Grid;
Width = Size_Grid;
Scale=4;%�����Ŵ�߶�
Length_S = 0;
Width_S = 0;
Length_E = Size_Grid;
Width_E = Size_Grid;
L_Grid = Scale*Size_Grid;   
W_Grid = Scale*Size_Grid;
%������ɢ��
AreaX = Length_S : Length/L_Grid : Length_E;
AreaY = Width_S : Width/W_Grid : Width_E;
for i=0:L_Grid
    for j=0:W_Grid
        Grid_all(i*(L_Grid+1)+j+1,1) = AreaX(i+1);
        Grid_all(i*(W_Grid+1)+j+1,2) = AreaY(j+1);
    end
end
%%˵������ʼ��boxΪ���������еĵ�%%
for normal_counter = 1:Node_Number
   box(normal_counter).count=(L_Grid+1)*(W_Grid+1);
   box(normal_counter).x=Grid_all(:,1);
   box(normal_counter).y=Grid_all(:,2);
   box(normal_counter).angle = [0,360];
   box(normal_counter).flag=ones(size(Grid_all(:,1)));
end


start = 1; % �����ָ����ʼê�ڵ�Ϊ1
%%%%���η���
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
%%%%%%%%%%%%%%%% IMSP�� ��һ��ɾ���㣡��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ax+by+c=0  y=tan(cita)x     -tan(cita)*x +1*y =0  a=-tan(cita)  b=1   a=-sin b=cos  
% d= -tan(cita)*x +1*y= -sin*x + cos*y 
%%%[x' y']=[c -s; s c] [x y]  y'���Ǿ���   y'=-sin*x+cos*y

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
		%%%ɾ��ê�ڵ��������������ֻ��Ŀ��ڵ��sequence   
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

    %��box��������ʱ����ѭ�������ڱ߽��ڵ��������в����ܽ�һ����С�������
%       if count_loop == 2
%         break;
%        end    
    if count_after_del == count_after_anchor
        break;
    end
 count_after_anchor =  count_after_del; 
end  %% while 1

  
disp('Center of Gravity');
%�����ڵ���˺���ʣ��ڵ������ƽ��ֵΪ���Ĺ���λ��
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
% ����λ��
%Est_MSP = [Ŀ��ڵ���� Ŀ��ڵ������ Ŀ��ڵ�������] 3��
Est_Normal = [Est_MSP(:,2) Est_MSP(:,3)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    rank_tmp=order_list;
   
    for j=1:length(rank_tmp)
        if rank_tmp(j)<=Num_Achohor
            rank_tmp(j)=0;
        end
    end
    
        index = find (rank_tmp == 0);%�����Ҫɾ���Ľڵ�
        rank_tmp(index) = [];%ɾ���ڵ�
  
        for k=1:Node_Number
    order_normal_list(k)=rank_tmp(k)-Num_Achohor;
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plotflag=0;


%%%%%  3 1 2 4 5 
for sequence_index = 1:scan_time %% i:index of sequence 
  
  ss0 = X_rank(:,sequence_index);  
  ss0';
  %%%%%%% ê�ڵ㵽ֱ�߾��� 
  a=-tan(cita(sequence_index)*pi/180);
  b=1; 
  
   for i=1:NUM_ANCHOR
      distance_anchor_line(i)=point2line(anchor_node(i,1),anchor_node(i,2),a,b,0); 
   end
%%%%%%%%%%%%%% ����-max  +max, ��ÿ��Ŀ��ڵ㶼��ǰ��ê�ڵ㣬���ں���������
%%����߽�㵽ֱ�ߵľ���
distance_anchor_line(NUM_ANCHOR+1)=-100;
distance_anchor_line(NUM_ANCHOR+2)=+100;

[xx,idx]=sort(distance_anchor_line);

%%%%%%%%%% ����ê�ڵ��������е�λ�÷���     �ڵ����   ǰê�ڵ����  ��ê�ڵ���� 
group=[]; 
group_index = 1;
anchor_group(group_index)=NUM_ANCHOR+1;

%%%%%%%% ê�ڵ����
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

%%%%%%%%%%%%%%%%%%%%%%%%%%% ����box
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
      
            index = find (box(iindex).flag(:) == 0);%�����Ҫɾ���Ľڵ�
            box(iindex).count =  box(iindex).count - length(index);
         if(box(iindex).count == 0)
               disp('****************************')
               disp(['node ',num2str(iindex),'  is keeped!'])
			   disp(['sequence: ',num2str(sequence_index)]);
               disp('****************************')     
               box(iindex).flag(index) = 1; %%%%change by jin  10.16  
               box(iindex).count =  box(iindex).count + length(index);
         else      
            box(iindex).x(index) = [];%ɾ���ڵ�
            box(iindex).y(index) = [];
            box(iindex).flag(index) = [];
         end
          
     end      %%%for group_num=1:NUM_NORMAL

if plotflag==1
    plot_box(box,NUM_NORMAL,NUM_ANCHOR,anchor_node,normal_node);
end

end  %%%for sequence_index = 1:scan_time


