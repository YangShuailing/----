function [ angle_temp box ] = Angle_EDSL( Node_All,Scale,Point_Step,Node_Location,Mic_Location,Microphone_Cita )

%ANGLE_EDSNL �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% ������Ϣ     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
angle_temp = zeros(Node_All,1);   

for normal_counter = 1:Node_All
    box(normal_counter).flag=ones((2*Scale/Point_Step+1)^2,1);
    box(normal_counter).count=(2*Scale/Point_Step+1)^2;
%     box(normal_counter).x=Grid_all(:,1);
%     box(normal_counter).y=Grid_all(:,2);
end

for i =1:Node_All 
    flag=ones((2*Scale/Point_Step+1)^2,1);%���
      %%%�� i ���ڵ�����ĵ�����
        x0 =  Node_Location(i,1);
        y0  = Node_Location(i,2);
        Xi = [x0 y0];
        %%% �� i ���ڵ��������˷�����
        x1 =  Mic_Location(i,1);
        y1  = Mic_Location(i,2);
        X1 = [x1 y1];
        x2 =  Mic_Location(i,3);
        y2  = Mic_Location(i,4);
        X2 = [x2 y2];
    for j = 1 : Node_All         
      %%%%%%%%%%%%%%%%%%%
        %����ʸ��Mic_vector
        Mic_vector=Node_Location(j,:)-Node_Location(i,:);
        %%%��֪����ʸ��Direct_vector=[a,b]������λ��(x0,y0)Microphone_Center_Location��
        %%%����ֱ��b(x-x0)-a(y-y0)=0  
        %%%���㴹ֱƽ����a(x-x0)+b(y-y0)=0  
        a=Mic_vector(1,1);
        b=Mic_vector(1,2);
        c = a*y0-b*x0; %ֱ�ߵ�����
        cc = -(a*x0 + b*y0); %���ߵ�����
%         %%%% ��ֱ��
%         if a==0
%             y = 1:10;
%             x = zeros(Node_All) + x0;
%             plot(x,y,'k-');
%             hold on;
%         else
%             x = 0 : 10;
%             y = subs(solve('b*x - a*y + c ','y')); % solve�ⷽ��; subs ���ʽת����ֵ�� sym ����תС��
%             plot(x,y,'k-');
%             hold on;
%         end
%            
%         %%%% ������
%         
%         if b==0
%             y = 1:10;
%             x = zeros(Node_All) + x0;
%             plot(x,y,'k-');
%             hold on;
%         else
%             x = 1:10;
%             y = subs(solve('a*x + b*y + cc ','y'));  % solve�ⷽ��; subs ���ʽת����ֵ�� sym ����תС��
%             plot(x,y,'k-');
%             hold on;
%         end
%   %%ֱ�߷���yy=aa*xx+bb;     
%   %%f = ax + by + cc;
    lin = [a b cc];  %% ֱ�߷���  
      f =  fun_flag(X1,lin);%ֱ�ߺ���  
      k =1;   
        for temp_x=x0-Scale:Point_Step:x0+Scale
                for temp_y=y0-Scale:Point_Step:y0+Scale
                      X_temp = [temp_x temp_y];
                      f_temp = fun_flag(X_temp,lin);%ֱ�ߺ���  
%                          %%% ����դ�������е�
%                          plot(temp_x,temp_y,'k.');
%                          hold on;     
                        if f * f_temp < 0  
                            flag(k) = 0; 
                        end
                        box(i).x(k) = temp_x; %%դ���е������
                        box(i).y(k) = temp_y; %%
                        box(i).flag(k) = flag(k);
                        k =k+1;
                end
        end  

    end
   
    sum_x=0;
    sum_y=0;
    totalcounnt=0;
    k=1;   
      for temp_x=x0-Scale:Point_Step:x0+Scale
           for temp_y=y0-Scale:Point_Step:y0+Scale
                if flag(k)==1
                sum_x=sum_x+temp_x;
                sum_y=sum_y+temp_y;
                totalcounnt=totalcounnt+1;
                %�����и�����                 
%                 plot(temp_x,temp_y,'g.');
%                 hold on;   
            end
            k =k+1;
           end
      end
   
        temp_sum=[sum_x/totalcounnt sum_y/totalcounnt];           
        k = ( temp_sum(1,2) - y0)/( temp_sum(1,1) - x0);
%         tan(deg2rad(Microphone_Cita(i)))
        temp = fix(rad2deg(atan(k)));
        if Microphone_Cita(i)*temp >0
             angle_temp(i)=temp; 
        else
             angle_temp(i)=-temp; 
        end
%         %%% �����������ĵ�
%         plot(x0,y0,'ro',temp_sum(1,1),temp_sum(1,2),'r^');
%         axis([-1 11 -1 11]);
%         hold on ; 

%         if isnan(angle_temp) %û�ж����Ƕȣ�����ê�ڵ�����
%             
%         end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% ����box
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   [ box ] = update( box,Node_All);
   for temp = 1 : box(i).count
%         if  box(i).flag(temp) == 1
            plot(box(i).x(temp),box(i).y(temp),'k.');
            hold on;
%         end
   end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ��������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ׼��1 
         for p = 1 : box(i).count %% �ڵ�i������
             Xi_P = [box(i).x(p)  box(i).y(p)];%% ��p���ڽڵ�i������   
             for l = 1 :Node_All
                  if l ~= i
                    Xl_1 = [Mic_Location(l,1) Mic_Location(l,2)];%% ��l���ڵ� micphone 1 ��λ��
                    Xl_2 = [Mic_Location(l,3) Mic_Location(l,4)];%% ��l���ڵ� micphone 2 ��λ��
                    flag_pl(p) = calcul_flag(Xi_P, Xl_1, Xl_2); %%%%%% �� p �������ڵ� l �� 0 �� 1 ��Ϣ
                    flag_il = calcul_flag( Xi,Xl_1,Xl_2 );%%%%%% �ڵ� i �������ڵ� l ����ʵ 0 �� 1 ��Ϣ
                    if (flag_pl(p) ~=flag_il) %%%�ж� p ���Ƿ���������
                        box(i).flag(p) = 0; %% ����������ֵΪ0��˵���õ㲻��������
                        continue;
                    end    
                  end
             end
         end
         box = update(box,Node_All); %%% update box ȥ��flagΪ0�ĵ�     
          for temp = 1 : box(i).count
%               if  box(i).flag(temp) == 1
                    plot(box(i).x(temp),box(i).y(temp),'go');
                    hold on;
%               end
          end
         
% % %%% ׼��2      
%     for l = 1 :Node_All
%       if l ~= i
%          Xl = Node_Location(l,:); %�� l ���ڵ㷢��
% %          Xl_1 =Microphone_1_Location(l,:);%% ��l���ڵ� micphone 1 ��λ��
% %          Xl_2 =Microphone_2_Location(l,:);%% ��l���ڵ� micphone 2 ��λ��
%          flag_li = calcul_flag( Xl,Xi_1,Xi_2 );%%%%%% �ڵ� l �������ڵ� i ����ʵ 0 �� 1 ��Ϣ
%          for p = 1 : box(i).count %% �ڵ�i������
%              Xi_P = [box(i).x(p)  box(i).y(p)];%% ��p���ڽڵ�i������         
%               for t = 1:box(i).count_angle %% box(i).count_angle(temp) =360
%                    if box(i).angle_flag(p,t) == 1
%                       X_m1 = [box(i).a_x(p,t) box(i).a_y(p,t)]; %% p����˷� 1 ���ڵ�λ��  
% %                      plot(box(i).a_x(p,t),box(i).a_y(p,t),'g.');
%                       flag_temp_angle = calcul_flag(Xl, X_m1, Xi_P ); %%%%%% �ڵ� l �������ڵ� i �ļ���� 0 �� 1 ��Ϣ
%                       if (flag_temp_angle ~= flag_li )
%                           box(i).angle_flag(p,t) = 0;%% ������������ֵΪ0  
%                       end  
%                    end
%                   
%                end
% 
%           end
%      end
%    end
%          box = update(box,Node_Number); %%% update box    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

end

