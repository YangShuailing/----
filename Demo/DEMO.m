clc;
clear all  %��� 
close all; %�ر�֮ǰ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%%%  ��ʼ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
Size_Grid=10;  %�����С����λ��m 
Length = Size_Grid; %% ����ĳ��ȣ���λ��m 
Width = Size_Grid;  %% ����Ŀ��ȣ���λ��m 
Microphone_Distance = 0.5; %�ֻ�������mic֮����� ��m)
r = Microphone_Distance/2;
Point_Step = 0.01;% �ռ�����
Node_Number = 4; %�ڵ����
Anchor_Number = 3; % ê�ڵ����
Node_all = Node_Number+Anchor_Number;
p_band=0.1;%%MSP�������Ǳ�����
% min_bound = 0.1;  %% LP�����½磬ȱʧ�����ܹ���
% max_bound = 10;
RUNS = 1; %%�������
Scan_Time = 6; %%ɨ�����
% cita=-90+180*(rand(1,Acoustic_Number));  %%���� [-90  90]  %%% ���Ⱥ���Դ�����й�ϵ
angle = [];
normal_min = 1;
normal_max=10;
normal_gap=1;
%%%%%%%������˷�λ�ó�����Ϣ
Microphone_Cita=fix(360*(rand(Node_Number,1)));  %%���� [0 360] ��x����������˷�1�ļн���    
% Microphone_Cita = [0 90 180 270];
Microphone_Center_Location=fix(Size_Grid*abs(rand(Node_Number,2))); % ���� λ��
% Microphone_Center_Location = [2 8; 8 2;2 2; 8 8];
% Anchor_Location = fix(Size_Grid*abs(rand(Anchor_Number,2)));  % ê�ڵ�����
Anchor_Location =[4 5; 5 4; 5 5];
Anchor_Cita = [45 90 135];
% Anchor_Cita=fix(-90+180*(rand(Anchor_Number,1)));  %%ê�ڵ㳯�� [-90  90]  
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
plot(Anchor_Microphone_1_Location(:,1),Anchor_Microphone_1_Location(:,2),'r*',Anchor_Microphone_2_Location(:,1),Anchor_Microphone_2_Location(:,2),'b*',Anchor_Location(:,1),Anchor_Location(:,2),'k*');
hold on;
plot(Microphone_1_Location(:,1),Microphone_1_Location(:,2),'r.',Microphone_2_Location(:,1),Microphone_2_Location(:,2),'b.',Microphone_Center_Location(:,1),Microphone_Center_Location(:,2),'k.');
hold on;
for i = 1:Anchor_Number
text(Anchor_Location(i,1)+0.3,Anchor_Location(i,2)+0.3,cellstr(num2str(i)));
end
for i = 1:Node_Number
text(Microphone_Center_Location(i,1)+0.3,Microphone_Center_Location(i,2)+0.3,cellstr(num2str(i+Anchor_Number)));
end
axis([-1 Size_Grid+1 -1 Size_Grid+1]) ;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
node_normal=Microphone_Center_Location; % ��ͨ�ڵ���������
node_anchor = Anchor_Location; % ê�ڵ�����
node_all = [node_anchor;node_normal];
dual_microphone_normal =[Microphone_1_Location Microphone_2_Location]; %% Node_Number*4
dual_microphone_anchor =[Anchor_Microphone_1_Location Anchor_Microphone_2_Location];
dual_node_all = [dual_microphone_anchor;dual_microphone_normal];
X_rank = calcul_rank(node_anchor,node_normal); % �������к�
table_binary = creat_table(dual_node_all,X_rank); % ���ɶ�Ӧ�Ե�0/1

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
   box(normal_counter).count=(L_Grid+1)*(W_Grid+1);
   box(normal_counter).x=Grid_all(:,1);
   box(normal_counter).y=Grid_all(:,2);
   box(normal_counter).flag=ones(size(Grid_all(:,1)));
   box(normal_counter).count_angle = 360+zeros(size(Grid_all(:,1)));
%    box(normal_counter).ax = onescell(360);
   
    for ii= 1:360
       box(normal_counter).a_x(:,ii)= box(normal_counter).x+r*sin(ii/360*2*pi);
       box(normal_counter).a_y(:,ii)= box(normal_counter).y+r*cos(ii/360*2*pi);
       box(normal_counter).angle_flag(:,ii) = box(normal_counter).flag;
   end
end

for i = 1: Node_Number
    Xi = node_normal(i,:); %�� i ���ڵ㷢��
    Xi_1 = Microphone_1_Location(i,:); %�� i ���ڵ����˷�1
    Xi_2 = Microphone_2_Location(i,:); %�� i ���ڵ����˷�2   
    for j = 1 : Anchor_Number       
          %%% ����ê�ڵ� 0/1��Ϣ ��С i�ڵ㷶Χ
        Xj_1 = Anchor_Microphone_1_Location(j,:); %% ��j��ê�ڵ� micphone 1 ��λ��
        Xj_2 = Anchor_Microphone_2_Location(j,:); %% ��j��ê�ڵ� micphone 2 ��λ��
        temp_ang_flag = calcul_flag(Xi ,Xj_1,Xj_2);
       %%% ����ê�ڵ�֮���ϵ
        for k = j+1 : Anchor_Number
             anchor_flag = calcul_flag(Xi,node_anchor(j,:),node_anchor(k,:)); 
             for temp = 1 : 360
                 X_temp = [box(i).x(temp)  box(i).y(temp)];
                 temp_flag(temp) = calcul_flag( X_temp ,node_anchor(j,:),node_anchor(k,:));       
                 if (temp_flag(temp) == anchor_flag )
                    box(i).flag(temp) = 1; %% ����������ֵΪ1
                 else
                    box(i).flag(temp) = 0; %% ������������ֵΪ0
                 end              
             end  
             box = update(box,Node_Number); %%% update box
        end       
        %%% �Ƕ��и�
        for temp = 1 : box(i).count
                 X_temp = [box(i).x(temp)  box(i).y(temp)];
                 temp_flag_angle(temp) = calcul_flag(X_temp,Xj_1,Xj_2);
                 if (temp_flag_angle(temp) == temp_ang_flag)
                    box(i).flag(temp) = 1; %% ����������ֵΪ1
                 else
                    box(i).flag(temp) = 0; %% ������������ֵΪ0
                 end              
        end         
        box = update(box,Node_Number); %%% update box      
        
        %%%  �Ƕȷ�Χ 
         flag_angle = calcul_flag(node_anchor(j,:),Xi_1,Xi_2);
         for temp = 1 : box(i).count
              X_temp = [box(i).x(temp)  box(i).y(temp)];
%                 plot(box(i).x(temp),box(i).y(temp),'go');
               for t = 1:box(i).count_angle(temp) %% box(i).count_angle(temp) =360
                   X_ang = [box(i).a_x(temp,t) box(i).a_y(temp,t)]; %% ��˷� 1 ���ڵ�λ��  
%                    plot(box(i).a_x(temp,t),box(i).a_y(temp,t),'g.');
                   flag_temp_angle = calcul_flag(node_anchor(j,:), X_ang,X_temp);    
                  if (flag_temp_angle ==  flag_angle )
                    box(i).angle_flag(temp,t) = 1;%% ����������ֵΪ1
                  else
                    box(i).angle_flag(temp,t) = 0;%% ������������ֵΪ0  
                  end  
               end
          
         end  
%       box = update_angle(box, Node_Number); %%% update box
    end

%       for l = 1 :Node_Number
%             Xl1 =Microphone_1_Location(l,:);
%             Xl2 =Microphone_2_Location(l,:);
%             flag_il = calcul_flag( Xi,Xl1,Xl2 );
%             for temp = 1 : box(i).count
%                      X_temp = [box(i).x(temp)  box(i).y(temp)];
%                      temp_flag(temp) = calcul_flag(X_temp, Xl1, Xl2);
%                      if (temp_flag(temp) == flag_il)
%                         box(i).flag(temp) = 1; %% ����������ֵΪ1
%                      else
%                         box(i).flag(temp) = 0; %%  ������������ֵΪ0
%                      end          
%             end
%         end

    
    
    
    
    
    
    
    
    
    
    
    
end
 
%%% �����ڵ���������
for count = 1:Node_Number
    if count == 1
        for temp = 1 : box(count).count
            if  box(count).flag(temp) == 1
                plot(box(count).x(temp),box(count).y(temp),'ko');
                hold on;
                axis([-1 Size_Grid+1 -1 Size_Grid+1]) ;
            end 
        end
    end

    if count == 2
        for temp = 1 : box(count).count
            if  box(count).flag(temp) == 1
                plot(box(count).x(temp),box(count).y(temp),'bo');
                hold on;
                axis([-1 Size_Grid+1 -1 Size_Grid+1]) ;
            end
        end
    end
    
    
    if count == 3
        for temp = 1 : box(count).count
            if  box(count).flag(temp) == 1
                plot(box(count).x(temp),box(count).y(temp),'go');
                hold on;
                axis([-1 Size_Grid+1 -1 Size_Grid+1]) ;
            end
        end
    end
    if count == 4
        for temp = 1 : box(count).count
            if  box(count).flag(temp) == 1
                plot(box(count).x(temp),box(count).y(temp),'ro');
                hold on;
                axis([-1 Size_Grid+1 -1 Size_Grid+1]) ;
            end
        end
    end
    
    
    
end
% 
% tan(deg2rad(45));

debug = 0;
        
%         for l = 1 :Node_Number
%             Xl1 =Microphone_1_Location(l,:);
%             Xl2 =Microphone_2_Location(l,:);
%             flag_il = calcul_flag( Xi,Xl1,Xl2 );
%             for temp = 1 : box(i).count
%                      X_temp = [box(i).x(temp)  box(i).y(temp)];
%                      temp_flag(temp) = calcul_flag(X_temp, Xl1, Xl2);
%                      if (temp_flag(temp) == flag_il)
%                         box(i).flag(temp) = 1; %% ����������ֵΪ1
%                      else
%                         box(i).flag(temp) = 0; %%  ������������ֵΪ0
%                      end          
%             end
%         end