function  plot_fig_msp(normal_node,Est_Normal,anchor_node,NUM_NORMAL,NUM_ANCHOR,Size_Grid) 
    


   figure(1) 


   plot(normal_node(:,1),normal_node(:,2),'k.' ,Est_Normal(:,1) ,Est_Normal(:,2),'bo',anchor_node(1:NUM_ANCHOR,1),anchor_node(1:NUM_ANCHOR,2),'rsquare');
     legend('True','ESP','Achohor');  

   hold on; 
   

         
%   for i=1:NUM_NORMAL            
%    x1=normal_node(i,1);
%    x2=Est_Normal(i,1);
%    y1=normal_node(i,2);
%    y2=Est_Normal(i,2);
%     plot_arrow([x1,y1],[x2,y2],'Length ',2,'BaseAngle',15,'TipAngle',30 ); 
%    end
%    
% %    for i=1:NUM_NORMAL
% %    plot([normal_node(i,1) Est_Normal(i,1)],[normal_node(i,2) Est_Normal(i,2)],'-g','LineWidth',2);
% %    end
% 
%     hold off;
%  grid;
% title('MSP');



    
    %     ��matlab)plot��ͼ����ɫ����   
%      y         ��ɫ           ��             ����
%      m         �ۺ�           ��             Ȧ��
%      c         ����           ��             ����
%      r         ���           ��             ������ 
%      g         ��ɫ           ��             ʵ��
%      b         ��ɫ           *              ������
%      w         ��ɫ           ��             ����
%      k         ��ɫ         ��.
%                              --            �㻮��
% matlab6.1����:
% [ + | o | * | . | x | square | diamond | v | ^ | > | < | pentagram | hexagram ]
%     square           ������
%     diamond        ����
%     pentagram     �����
%     hexagram      ������
