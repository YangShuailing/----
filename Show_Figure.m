clc;
clear all;
load('result.mat');
rmse_msp_tmp ;
rmse_angle_tmp ;

totalNum=size(rmse_msp_tmp,1);
ymin=min(rmse_msp_tmp); 
ymax=max(rmse_msp_tmp);
x=linspace(ymin,ymax,20); 
yy=hist(rmse_msp_tmp,x); %计算各个区间的个数 
yy=yy/totalNum;%计算各个区间的概率
for i=2:size(x,2)
    yy(1,i)=yy(1,i-1)+yy(1,i);
end
plot(x, yy, 'bo-', 'LineWidth', 1, 'MarkerFaceColor', 'r');
   axis([0 ymax 0 1]); 
 xlabel('Positioning error(m)');
ylabel('CDF');
legend( 'Loc Err' );


figure(2)
totalNum=size(rmse_angle_tmp,1);
ymin=min(rmse_angle_tmp); 
ymax=max(rmse_angle_tmp);
x=linspace(ymin,ymax,20);
yy=hist(rmse_angle_tmp,x); %计算各个区间的个数 
yy=yy/totalNum;%计算各个区间的概率
for i=2:size(x,2)
    yy(1,i)=yy(1,i-1)+yy(1,i);
end
plot(x, yy, 'bo-', 'LineWidth', 1, 'MarkerFaceColor', 'b');

 axis([0 ymax 0 1]); 
 xlabel('angel error');
ylabel('CDF');
legend( 'Angle');




