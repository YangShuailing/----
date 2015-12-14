function  [ xxest_normal, xxest_anchor]=LP_EDSNL(Num_Achohor,NUM_NORMAL,Scan_time,Xanohor,X_rank,est_angle,mminbb,mmaxb)

         
%%%%%%%%%%%%%%%%%%  inequation constraint   A  b  c
%%%%%%%%%%%%%%  mminbb   positive


M=NUM_NORMAL+Num_Achohor;
N=Scan_time;
Num_equa=N*(M-1);%  等式个数

%%%%using est_angle to generate A
A=zeros(N*(M-1),2*M+Num_equa);  
A=get_lp(X_rank,est_angle); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%>%%%Protect Band for LP
% mminbb>=0 is the min of distance,
% if exist node flip,  mminbb<0;
%set mminbb id a little minux number,such as -1,-2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bb=-mminbb-0.0001; %%%%%%%
b= kron(bb,ones(N*(M-1),1));

c=zeros(2*M+Num_equa,1);
cc=0;
c(1:2*M)= kron(cc,ones(2*M,1));
c(2*M+1:2*M+Num_equa)= 1;

%%%%%%%%%%%% Bound of x %%%%%%%%%%%% 
lb = zeros(2*M+Num_equa,1);
ub = mmaxb*ones(2*M+Num_equa,1);  
%%%%%%%%%%% mmaxb the place of wrong code ！！！
%%1 singleton variables in the equality constraints are not within bounds.


%%%%%%%%%%   equation constraint  %%%%%%%%%%  
%%%%%%%%%%%%%%%% 
% realx=[XX;zeros(Num_equa ,1)];
sa=2*M+Num_equa; %[sa,sb]=size(realx);
Aequ=zeros(2*Num_Achohor,sa);
for i=1:2*Num_Achohor
Aequ(i,i)=1;
end

bequ=reshape(Xanohor',2*Num_Achohor,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aequ
% bequ
% pause;

[x,fval,exitflag,output,lambda] = linprog(c,A,b,Aequ,bequ,lb,ub);  % without equation constraint,do not work correctly

%[x,fval,exitflag,output,lambda] = linprog(c,A,b,Aequ,bequ);  %%%%%% without Bound do not work correctly %%
%[x,fval,exitflag,output,lambda] = linprog(c,A,b,Aequ,bequ,lb,ub,init_x);
if size(x,1)==2*M+Num_equa
 X_est=x(2*Num_Achohor+1:2*M); 
 X_est_anchor=x(1:2*Num_Achohor); 
else
disp('LP wrong!');
X_est=zeros(2*NUM_NORMAL,1);
pause;
end

 for i=1:NUM_NORMAL
     xxest_normal(i,1)=X_est(2*(i-1)+1);
     xxest_normal(i,2)=X_est(2*(i-1)+2);
end

for i=1:Num_Achohor
     xxest_anchor(i,1)=X_est_anchor(2*(i-1)+1);
     xxest_anchor(i,2)=X_est_anchor(2*(i-1)+2);
end

