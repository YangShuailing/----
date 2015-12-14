function [ angle_temp ] = Angle_EDSNL( Node_All,Microphone_Distance,Point_Step,Xnode_All,Node_Location,Acoustic_Loc,Acoustic_Number,Microphone_Cita )
%ANGLE_EDSNL �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% ������Ϣ     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
angle_temp = zeros(Node_All,1);    
for i =1:Node_All 
    
    flag=ones((Microphone_Distance/Point_Step+1)^2,1);%���
    for j = 1 : Acoustic_Number  
        
        %%%�� i ���ڵ�����ĵ�����
        x0 =  Xnode_All(i,1);
        y0  = Xnode_All(i,2);
        X0 = [x0 y0];
        %%% �� i ���ڵ��������˷�����
        x1 =  Node_Location(i,1);
        y1  = Node_Location(i,2);
        X1 = [x1 y1];
        x2 =  Node_Location(i,3);
        y2  = Node_Location(i,4);
        X2 = [x2 y2];
%%%%%%%%%%%%%%%%%%%
        %����ʸ��Mic_vector
        Mic_vector=Acoustic_Loc(j,:)-Xnode_All(i,:);
        %%%��֪����ʸ��Direct_vector=[a,b]������λ��(x0,y0)Microphone_Center_Location��
        %%%���㴹ֱƽ����a(x-x0)+b(y-y0)=0  
        a=Mic_vector(1,1);
        b=Mic_vector(1,2);
        aa=-a/b; %%%% �д���б��
        bb=(a*x0+b*y0)/b;  %%%�ؾ�        
%         %%%  �����д���
%         xx=0:10;
%         yy=aa*xx+bb;
%         plot(xx,yy,'color','black','Linewidth',1);
%         hold on; 
%   %%ֱ�߷���yy=aa*xx+bb;     
%   %%f = y1 - aa*x1 - bb;
    lin = [1 -aa -bb];  %% ֱ�߷���  
      f =  fun_flag(X1,lin);%ֱ�ߺ���  
      k =1;   
        for temp_x=x0-Microphone_Distance/2:Point_Step:x0+Microphone_Distance/2
                for temp_y=y0-Microphone_Distance/2:Point_Step:y0+Microphone_Distance/2
                      X_temp = [temp_x temp_y];
                      f_temp = fun_flag(X_temp,lin);%ֱ�ߺ���  
%                           plot(temp_x,temp_y,'ko');
%                               hold on;
              
                    if f * f_temp < 0  
                        flag(k) = 0; 
                    end  
                    k =k+1;
                end
        end  

    end
   
    sum_x=0;
    sum_y=0;
    totalcounnt=0;
    k=1;
    
      for temp_x=x0-Microphone_Distance/2:Point_Step:x0+Microphone_Distance/2
           for temp_y=y0-Microphone_Distance/2:Point_Step:y0+Microphone_Distance/2
               
            if flag(k)==1
                sum_x=sum_x+temp_x;
                sum_y=sum_y+temp_y;
                totalcounnt=totalcounnt+1;
%                 %%�����и�����                 
%                 plot(temp_x,temp_y,'bo');
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
%         plot(x0,y0,'ro',temp_sum(1,1),temp_sum(1,2),'b*');
%         axis([-1 11 -1 11]);
%         hold on ; 

%         if isnan(angle_temp) %û�ж����Ƕȣ�����ê�ڵ�����
%             
%         end

end

end

