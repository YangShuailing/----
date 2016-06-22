function [  Est_MSP,angle_temp ] = improve( box1, box2,Xnode,Xnode_Mic1,XCita)
%ANVANCE �˴���ʾ�йش˺�����ժҪ   improve( box1, box2,Xnode,Xnode_Mic1,XCita);
%   �˴���ʾ��ϸ˵��
%%% ׼��1 
Microphone_Cita = XCita;
[M N] = size(Xnode);
Node_Number =M;
for  i=1:Node_Number
         Xi = Xnode(i,:); %�� i���ڵ����ĵ�����
         for p = 1 : box1(i).count %% �ڵ�i������
             Xi_P = [box1(i).x(p)  box1(i).y(p)];%% ��p���ڽڵ�1������             
             for l = 1 :Node_Number
                  if l ~= i
                    Xl_1 =Xnode_Mic1(l,:);%% ��l���ڵ� micphone 1 ��λ��
%                     Xl_2 =Microphone_2_Location(l,:);%% ��l���ڵ� micphone 2 ��λ��
                    flag_pl(p) = calcul_flag(Xi_P, Xl_1, Xnode(l,:)); %%%%%% �� p �������ڵ� l �� 0 �� 1 ��Ϣ
                    flag_il = calcul_flag( Xi,Xl_1, Xnode(l,:) );%%%%%% �ڵ� i �������ڵ� l ����ʵ 0 �� 1 ��Ϣ
                    if (flag_pl(p) ==flag_il) %%%�ж� p ���Ƿ���������
                        box1(i).flag(p) = 1; %% ����������ֵΪ1�����ѭ������֮������Ϊ0��˵���õ㲻��������
                    end    
                  end
             end
         end    
          box1 = update(box1,Node_Number); %%% update box  
% %�����ڵ���˺���ʣ��ڵ������ƽ��ֵΪ���Ĺ���λ��
Est_MSP = [];
tmp = [];
tmp_1 = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j = 1:Node_Number
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
      for m = 1: box1(j).count
          tmp = [tmp; box1(j).x(m),box1(j).y(m)]; 
      end    
    tmp_1 = [mean(tmp(:,1))  mean(tmp(:,2))];
    Est_MSP = [Est_MSP; tmp_1];
    tmp = [];    
end         
          
% %%% ׼��2     
   Xi_1=Xnode_Mic1(i,:);
    for l = 1 :Node_Number
      if l ~= i
         Xl = Xnode_Mic1(l,:); %�� l ���ڵ㷢��
%          Xl_1 =Microphone_1_Location(l,:);%% ��l���ڵ� micphone 1 ��λ��
%          Xl_2 =Microphone_2_Location(l,:);%% ��l���ڵ� micphone 2 ��λ��
         flag_li = calcul_flag( Xl,Xi_1, Xnode(i,:));%%%%%% �ڵ� l �������ڵ� i ����ʵ 0 �� 1 ��Ϣ
         for p = 1 : box2(i).count %% �ڵ�i������
              Xi_P = [box2(i).x(p)  box2(i).y(p)];%% ��p���ڽڵ�1������              
%              plot(box(i).a_x(p,t),box(i).a_y(p,t),'g.');
              flag_temp_angle = calcul_flag(Xl, Xi_P, Xnode(i,:) ); %%%%%% �ڵ� l �������ڵ� i �ļ���� 0 �� 1 ��Ϣ
              if (flag_temp_angle ~= flag_li )
                  box2(i).flag(p) = 0;%% ������������ֵΪ0  
              end  
          end
    end
     
   end
         box2 = update(box2,Node_Number); %%% update box  
                      
      Xi_P = [0 0];
      for t = 1: box2(i).count
         Xi_P = [ Xi_P ; box2(i).x(t)  box2(i).y(t)];%% ��p���ڽڵ�i������   
      end    
         m1_est(i,:) = [mean(Xi_P(:,1))  mean(Xi_P(:,2))];%% i�����˷�1λ��  
         if m1_est(i,1) == 0
             temp = 45;
%         tan(deg2rad(Microphone_Cita(i)))
         else
              temp = fix(rad2deg(atan(m1_est(i,2) /m1_est(i,1))));
         end
        if Microphone_Cita(i)*temp >0
             angle_temp(i)=temp; 
        else
             angle_temp(i)=-temp; 
        end
   angle_temp = angle_temp';
    
end

