function  box = del_point_using_anchor(box,X_rank,NUM_ANCHOR,NUM_NORMAL,scan_time,anchor_node,cita,PB_anchor,normal_node)
plotflag=0;
for sequence_index = 1:scan_time %% i:index of sequence 
  
  ss0 = X_rank(:,sequence_index);  
  ss0';%%% �� i�� ɨ�������
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




function [dis]=point2line(x,y,a,b,c)

dis=(a*x+b*y+c)/sqrt(a*a+b*b);

return