%��ȡ����ê�ڵ��Ŀ��ڵ������
function [Xrank] = calcul_rank(node_anchor,node_normal)

[ Anchor_Number p]= size(node_anchor);  % ê�ڵ����
[Node_normal_Num q] = size(node_normal); % ��ͨ�ڵ� 
node_all = [node_anchor;node_normal];
[Node_All_Num q] = size(node_all); % ���нڵ� 
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
% Xa %�����С
% Xrank ��ţ�Ŀ��ڵ������ǰ