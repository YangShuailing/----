%获取所有锚节点和目标节点的序列
function [Xrank] = calcul_rank(node_anchor,node_all)

[ Anchor_Number p]= size(node_anchor);  % 锚节点个数
[Node_All_Num q] = size(node_all); % 普通节点 

 temp_dis = zeros(Node_All_Num,Anchor_Number);
for  i=1:Anchor_Number
    X0=node_anchor(i,:);
    for  j=1:Node_All_Num
        X = node_all(j,:);
        dis_anchor(j) = norm(X0-X);
    end
    temp_dis(:,i) = dis_anchor';
end
[Xa,Xrank]=sort(temp_dis,1);
Xrank = Xrank';
end
% Xa %距离大小
% Xrank 序号，目标节点序号在前