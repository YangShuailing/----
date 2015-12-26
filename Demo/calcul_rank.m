%获取所有锚节点和目标节点的序列
function [Xrank] = calcul_rank(node_anchor,node_normal)

[ Anchor_Number p]= size(node_anchor);  % 锚节点个数
[Node_normal_Num q] = size(node_normal); % 普通节点 
node_all = [node_anchor;node_normal];
[Node_All_Num q] = size(node_all); % 所有节点 
for  i=1:Node_All_Num
    X0=node_all(i,:);
    for  j=1:Node_All_Num
        X = node_all(j,:);
        dis_anchor(j) = norm(X0-X);
    end
    temp_dis(:,i) = dis_anchor';
end
[Xa,rank]=sort(temp_dis,1);
Xrank = rank';

end
% Xa %距离大小
% Xrank 序号，目标节点序号在前