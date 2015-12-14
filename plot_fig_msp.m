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



    
    %     （matlab)plot画图的颜色线型   
%      y         黄色           ·             点线
%      m         粉红           ○             圈线
%      c         亮蓝           ×             ×线
%      r         大红           ＋             ＋字线 
%      g         绿色           －             实线
%      b         蓝色           *              星形线
%      w         白色           ：             虚线
%      k         黑色         －.
%                              --            点划线
% matlab6.1线形:
% [ + | o | * | . | x | square | diamond | v | ^ | > | < | pentagram | hexagram ]
%     square           正方形
%     diamond        菱形
%     pentagram     五角星
%     hexagram      六角星
