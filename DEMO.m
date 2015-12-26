

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
%%%% �����ڵ�λ��
figure('Position',[1 1 900 900])
plot(Anchor_Microphone_1_Location(:,1),Anchor_Microphone_1_Location(:,2),'k.',Anchor_Microphone_2_Location(:,1),Anchor_Microphone_2_Location(:,2),'k.',Anchor_Location(:,1),Anchor_Location(:,2),'k.');
hold on;
plot(Microphone_1_Location(:,1),Microphone_1_Location(:,2),'r.',Microphone_2_Location(:,1),Microphone_2_Location(:,2),'b.',Microphone_Center_Location(:,1),Microphone_Center_Location(:,2),'k.');
hold on;
for i = 1:Anchor_Number
text(Anchor_Location(i,1)+0.3,Anchor_Location(i,2)+0.3,cellstr(num2str(i)));
end
for i = 1:Node_Number
text(Microphone_Center_Location(i,1)+0.3,Microphone_Center_Location(i,2)+0.3,cellstr(num2str(i)));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
node_normal=Microphone_Center_Location; % ��ͨ�ڵ���������
node_anchor = Anchor_Location; % ê�ڵ�����
Dual_Microphone=[Microphone_1_Location Microphone_2_Location]; %% Node_Number*4
% X_rank = calcul_rank(node_anchor,node_normal); % �������к�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���η���

Scale=4;%�����Ŵ�߶�
L_Grid = Scale*Size_Grid; %%��ɢ����ĸ���  
W_Grid = Scale*Size_Grid; %%��ɢ����ĸ���  
%������ɢ��
AreaX = 0 : Length/L_Grid : Size_Grid;
AreaY = 0 : Width/W_Grid : Size_Grid;
for i=0:L_Grid
    for j=0:W_Grid
        Grid_all(i*(L_Grid+1)+j+1,1) = AreaX(i+1);
        Grid_all(i*(W_Grid+1)+j+1,2) = AreaY(j+1);
    end
end
%%˵������ʼ��boxΪ���������еĵ�%%
for normal_counter = 1:Node_Number
    %%% update 
    
    %%%
    
   box(normal_counter).count=(L_Grid+1)*(W_Grid+1);
   box(normal_counter).x=Grid_all(:,1);
   box(normal_counter).y=Grid_all(:,2);
   box(normal_counter).flag=zeros(size(Grid_all(:,1)));

   for i = 1:360 
       %%% ��������Ϣ����ʾ����Ƕ�
       %%% X = [box(normal_counter).a_x  box(normal_counter).a_y]��ʾ�Ի��� 
       %%% X0 = [box(normal_counter).x  box(normal_counter).y]��Բ�ϵĵ�
       box(normal_counter).a_x(:,i)= box(normal_counter).x+r*sin(i/360*2*pi);
       box(normal_counter).a_y(:,i)= box(normal_counter).y+r*sin(i/360*2*pi);
       box(normal_counter).angle_flag(i) = i;
   end
end


 
%%%% λ������
for i = 1 : Node_Number
    X0 = node_normal(i,:); %% ��i���ڵ���ʵλ��
    for j = 1 : Anchor_Number 
        Xj_1 = Anchor_Microphone_1_Location(j,:); %% ��j��ê�ڵ���ʵλ��
        Xj_2 = Anchor_Microphone_2_Location(j,:); %% ��j��ê�ڵ���ʵλ��
        Anchor_flag(j) = calcul_flag( X0,Xj_1,Xj_2);%% ��i����ͨ�ڵ㷢����ê�ڵ�õ� 0/1 ��Ϣ��
        %%%% ���ݽڵ�i����ê�ڵ�õ���0/1��Ϣ���Խڵ�i�Ŀ���������и��С��i���ڵ�ķ�Χ
        for temp = 1 : box(i).count
            X_temp = [box(i).x(temp)  box(i).y(temp)];
            temp_flag(temp) = calcul_flag( X_temp ,Xj_1,Xj_2);
            if temp_flag(temp) == Anchor_flag
               box(i).flag(temp) = 1; %% ����������ֵΪ1
            else
                box(i).flag(temp) = 0; %% ����������ֵΪ1
            end
          %%%% �Ƕ� 
             for a = 1:360 
                 temp_loc = [box(normal_counter).a_x(temp,a) box(normal_counter).a_y(temp,a)];
                 temp_loc_flag = calcul_flag(temp_loc,Xj_1,Xj_2);
                 if temp_flag(temp) == Anchor_flag
                    box(normal_counter).angle_flag(temp,a) = 1;
                 else
                     box(normal_counter).angle_flag(temp,a) = 0;
                 end
             end
            
            
        end

     %%%% ���� ��i���ڵ㷢�������������У�MSP����С��i���ڵ�ķ�Χ
        for k = j+1:Anchor_Number 
            X1 = node_anchor(j,:);
            X2 = node_anchor(k,:);
            Between_Anchor_flag(j) = calcul_flag( X0,X1,X2); %% ê�ڵ�֮�����Ϣ�����и
            for temp = 1 : box(i).count
                X_temp = [box(i).x(temp)  box(i).y(temp)];
                temp_flag(temp) = calcul_flag( X_temp ,Xj_1,Xj_2);
                if temp_flag(temp) == Anchor_flag
                   box(i).flag(temp) = 1; %% ����������ֵΪ1
                else
                   box(i).flag(temp) = 0; %% ����������ֵΪ1
                end
             end
        end
 
  
 
%          for m = i : Node_number
%             Xo_0 = node_normal(m,:); %% ��m���ڵ���ʵλ��
%             Xm_1 = Microphone_1_Location(m,:);
%             Xm_2 = Microphone_2_Location(m,:);
%             mi_flag(j) = calcul_flag( X0,Xj_1,Xj_2);%% ��i����ͨ�ڵ㷢����ê�ڵ�õ� 0/1 ��Ϣ
%             
%          end
        
        
    end

end
%%% �����ڵ���������
for count = 1 : Node_Number

        for temp = 1 : box(count).count
            if  box(count).flag(temp) == 1
                plot(box(count).x(temp),box(count).y(temp),'*');
                hold on;
                axis([-1 Size_Grid+1 -1 Size_Grid+1]) ;
            end
        end
end

